import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflex/core/utils/constants.dart';
import 'package:payflex/features/home/models/beneficiary.dart';
import 'package:payflex/features/home/repositories/beneficiary_repository.dart';
import 'package:payflex/features/user/cubit/user_cubit.dart';

part 'beneficiaries_state.dart';

class BeneficiariesCubit extends Cubit<BeneficiariesState> {
  final BeneficiariesRepository _beneficiariesRepository;
  final UserCubit _userCubit;

  BeneficiariesCubit(this._beneficiariesRepository, this._userCubit)
      : super(BeneficiariesInitial());

  Future<void> loadBeneficiaries() async {
    try {
      emit(BeneficiariesLoading());
      final beneficiaries =
          await _beneficiariesRepository.getBeneficiaries(_userCubit.user.id);
      emit(BeneficiariesLoaded(beneficiaries));
    } catch (e) {
      emit(const BeneficiariesError("Failed to load beneficiaries"));
    }
  }

  Future<void> addBeneficiary(Beneficiary beneficiary) async {
    try {
      if (state is BeneficiariesLoaded) {
        final loadedState = state as BeneficiariesLoaded;
        final activeBene =
            loadedState.beneficiaries.where((b) => b.isActive).length;
        if (activeBene >= 5) {
          emit(BeneficiariesSnackBarError(
              "Cannot add more than 5 active beneficiaries.",
              cachedBeneficiaries: loadedState.beneficiaries));
          emit(BeneficiariesLoaded(List.from(loadedState.beneficiaries)));
        }
        await _beneficiariesRepository.addBeneficiary(
            _userCubit.user.id, beneficiary);
        final updatedBeneficiaries =
            List<Beneficiary>.from((state as BeneficiariesLoaded).beneficiaries);
        emit(BeneficiariesLoaded(updatedBeneficiaries));
      }
    } catch (e) {
      emit(BeneficiariesSnackBarError(e.toString()));
    }
  }

  Future<void> deleteBeneficiary(Beneficiary beneficiary) async {
    try {
      if (state is BeneficiariesLoaded) {
        await _beneficiariesRepository.deleteBeneficiary(
            _userCubit.user.id, beneficiary);
        final loadedState = state as BeneficiariesLoaded;
        final updatedBeneficiaries =
            List<Beneficiary>.from(loadedState.beneficiaries)
              ..removeWhere((b) => b == beneficiary);
        emit(BeneficiariesLoaded(updatedBeneficiaries));
      }
    } catch (e) {
      emit(BeneficiariesSnackBarError(e.toString()));
    }
  }

  Future<void> toggleBeneficiaryStatus(Beneficiary bene) async {
    try {
      if (state is BeneficiariesLoaded) {
        await _beneficiariesRepository.toggleBeneficiaryStatus(
            _userCubit.user.id, bene);
        final updatedBeneficiaries =
            (state as BeneficiariesLoaded).beneficiaries;

        emit(BeneficiariesLoaded(updatedBeneficiaries));
      }
    } catch (e) {
      emit(BeneficiariesSnackBarError(e.toString()));
    }
  }

  Future<void> topupBeneficiary(Beneficiary bene, double amount) async {
    try {
      if (state is BeneficiariesLoaded) {
        final loadedState = state as BeneficiariesLoaded;
        final user = _userCubit.user;

        // Calculate total amount including transaction charge
        final totalAmount = amount + transactionCharge;

        // Check user balance
        if (user.balance < totalAmount) {
          emit(BeneficiariesSnackBarError(
            "Insufficient balance.",
            cachedBeneficiaries: loadedState.beneficiaries,
          ));

          emit(BeneficiariesLoaded(loadedState.beneficiaries));

          return;
        }

        // Check beneficiary monthly top-up limit
        final beneficiaryMonthlyTopUp = await _beneficiariesRepository
            .getBeneficiaryMonthlyTopUp(user.id, bene);
        if (beneficiaryMonthlyTopUp + amount >
            getBeneficiaryLimit(user.isVerified)) {
          emit(BeneficiariesSnackBarError(
            "Exceeded monthly top-up limit for this beneficiary.",
            cachedBeneficiaries: loadedState.beneficiaries,
          ));
          emit(BeneficiariesLoaded(loadedState.beneficiaries));

          return;
        }

        // Check total monthly top-up limit
        final totalMonthlyTopUp =
            await _beneficiariesRepository.getTotalMonthlyTopUp(user.id);
        if (totalMonthlyTopUp + amount > totalMonthlyLimit) {
          emit(BeneficiariesSnackBarError(
            "Exceeded total monthly top-up limit.",
            cachedBeneficiaries: loadedState.beneficiaries,
          ));
          emit(BeneficiariesLoaded(loadedState.beneficiaries));

          return;
        }

        // Proceed with top-up
        await _beneficiariesRepository.topupBeneficiary(user.id, bene, amount);
        _userCubit.updateUserBalance(-totalAmount);

        // Update beneficiary state
        final updatedBeneficiaries =
            List<Beneficiary>.from(loadedState.beneficiaries);

        emit(BeneficiariesLoaded(updatedBeneficiaries));
      }
    } catch (e) {
      emit(BeneficiariesSnackBarError(e.toString()));
    }
  }
}
