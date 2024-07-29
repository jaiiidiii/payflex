part of 'add_beneficiary_form_cubit.dart';

class AddBeneficiaryFormData {
  final String? name, phoneNumber;
  final bool isActive;

  const AddBeneficiaryFormData({
    this.name,
    this.phoneNumber,
    this.isActive = true,
  });

  AddBeneficiaryFormData copyWith({
    String? Function()? name,
    String? Function()? phoneNumber,
    bool? isActive,
  }) {
    return AddBeneficiaryFormData(
      name: name == null ? this.name : name(),
      phoneNumber: phoneNumber == null ? this.phoneNumber : phoneNumber(),
      isActive: isActive ?? this.isActive,
    );
  }

  bool get isValid => name != null && phoneNumber != null;
}
