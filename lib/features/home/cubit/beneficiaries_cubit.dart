import 'package:flutter/material.dart';
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

  Future<void> addBeneficiary(
      BuildContext context, Beneficiary beneficiary) async {
    try {
      if (state is BeneficiariesLoaded) {
        final loadedState = state as BeneficiariesLoaded;
        final activeBene =
            loadedState.beneficiaries.where((b) => b.isActive).length;
        if (activeBene >= 5) {
          _showSnackBar(
              context, "Cannot add more than 5 active beneficiaries.");
          return;
        }

        await _beneficiariesRepository.addBeneficiary(
            _userCubit.user.id, beneficiary);

        emit(BeneficiariesLoaded(loadedState.beneficiaries));
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, e.toString());
      }
    }
  }

  Future<void> deleteBeneficiary(
      BuildContext context, Beneficiary beneficiary) async {
    try {
      if (state is BeneficiariesLoaded) {
        await _beneficiariesRepository.deleteBeneficiary(
            _userCubit.user.id, beneficiary);
        final loadedState = state as BeneficiariesLoaded;

        emit(BeneficiariesLoaded(loadedState.beneficiaries));
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, e.toString());
      }
    }
  }

  Future<void> toggleBeneficiaryStatus(
      BuildContext context, Beneficiary bene) async {
    try {
      if (state is BeneficiariesLoaded) {
        final loadedState = state as BeneficiariesLoaded;
        final activeBene =
            loadedState.beneficiaries.where((b) => b.isActive).length;
        if (activeBene >= 5) {
          _showSnackBar(
              context, "Cannot add more than 5 active beneficiaries.");
          return;
        }

        await _beneficiariesRepository.toggleBeneficiaryStatus(
            _userCubit.user.id, bene);
        final updatedBeneficiaries =
            (state as BeneficiariesLoaded).beneficiaries;

        emit(BeneficiariesLoaded(updatedBeneficiaries));
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, e.toString());
      }
    }
  }

  Future<void> topupBeneficiary(
      BuildContext context, Beneficiary bene, double amount) async {
    try {
      if (state is BeneficiariesLoaded) {
        final loadedState = state as BeneficiariesLoaded;
        final user = _userCubit.user;

        // Calculate total amount including transaction charge
        final totalAmount = amount + transactionCharge;

        // Check user balance
        if (user.balance < totalAmount) {
          _showSnackBar(context, "Insufficient balance.");
          return;
        }

        // Check beneficiary monthly top-up limit
        final beneficiaryMonthlyTopUp = await _beneficiariesRepository
            .getBeneficiaryMonthlyTopUp(user.id, bene);
        if (beneficiaryMonthlyTopUp + amount >
            getBeneficiaryLimit(user.isVerified)) {
          if (context.mounted) {
            _showSnackBar(
                context, "Exceeded monthly top-up limit for this beneficiary.");
          }
          return;
        }

        // Check total monthly top-up limit
        final totalMonthlyTopUp =
            await _beneficiariesRepository.getTotalMonthlyTopUp(user.id);
        if (totalMonthlyTopUp + amount > totalMonthlyLimit) {
          if (context.mounted) {
            _showSnackBar(context, "Exceeded total monthly top-up limit.");
          }
          return;
        }

        // Proceed with top-up
        await _beneficiariesRepository.topupBeneficiary(user.id, bene, amount);
        _userCubit.updateUserBalance(-totalAmount);

        // Update beneficiary state

        emit(BeneficiariesLoaded(loadedState.beneficiaries));
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, e.toString());
      }
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
