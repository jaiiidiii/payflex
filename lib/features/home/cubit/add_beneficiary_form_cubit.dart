import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_beneficiary_form_data.dart';

class AddBeneficiaryFormCubit extends Cubit<AddBeneficiaryFormData> {
  AddBeneficiaryFormCubit() : super(const AddBeneficiaryFormData()) {
    nameController.addListener(_onNameChanged);
    phoneNumberController.addListener(_onPhoneNumberChanged);
  }

  final nameController = TextEditingController(),
      phoneNumberController = TextEditingController();

  void _onNameChanged() {
    emit(state.copyWith(name: () => nameController.text));
  }

  void _onPhoneNumberChanged() {
    emit(state.copyWith(phoneNumber: () => phoneNumberController.text));
  }

  toggleActiveStatus() {
    emit(state.copyWith(isActive: !state.isActive));
  }

  @override
  Future<void> close() {
    nameController.dispose();
    phoneNumberController.dispose();
    return super.close();
  }
}
