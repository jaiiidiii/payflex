part of 'beneficiaries_cubit.dart';

abstract class BeneficiariesState {
  const BeneficiariesState();
}

class BeneficiariesInitial extends BeneficiariesState {}

class BeneficiariesLoading extends BeneficiariesState {}

class BeneficiariesLoaded extends BeneficiariesState {
  final List<Beneficiary> beneficiaries;

  const BeneficiariesLoaded(this.beneficiaries);
}

class BeneficiariesError extends BeneficiariesState {
  final String message;

  const BeneficiariesError(this.message);
}

class BeneficiariesSnackBarError extends BeneficiariesState {
  final List<Beneficiary>? cachedBeneficiaries;
  final String message;

  const BeneficiariesSnackBarError(this.message, {this.cachedBeneficiaries});
}
