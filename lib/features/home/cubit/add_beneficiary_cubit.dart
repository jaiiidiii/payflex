import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflex/features/home/models/beneficiary.dart';

part 'add_beneficiary_state.dart';

class AddBeneficiaryCubit extends Cubit<AddBeneficiaryState> {
  AddBeneficiaryCubit() : super(AddBeneficiaryInitial());

  void addBeneficiary(
      {String? name, String? phoneNumber, bool isActive = false}) {
    if (name == null || name.isEmpty) {
      emit(const BeneficiaryError('Name is required'));
      return;
    }
    if (phoneNumber == null || phoneNumber.isEmpty) {
      emit(const BeneficiaryError('Phone number is required'));
      return;
    }

    final newBeneficiary = Beneficiary(
      name: name,
      phoneNumber: phoneNumber,
      isActive: isActive,
      balance: 0,
    );

    emit(BeneficiaryAdded(newBeneficiary));
    // emit(AddBeneficiaryInitial());
  }
}
