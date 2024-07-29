part of 'add_beneficiary_cubit.dart';

sealed class AddBeneficiaryState extends Equatable {
  const AddBeneficiaryState();

  @override
  List<Object> get props => [];
}

final class AddBeneficiaryInitial extends AddBeneficiaryState {}

class BeneficiaryAdded extends AddBeneficiaryState {
  final Beneficiary beneficiary;

  const BeneficiaryAdded(this.beneficiary);

  @override
  List<Object> get props => [beneficiary];
}

class BeneficiaryError extends AddBeneficiaryState {
  final String message;

  const BeneficiaryError(this.message);

  @override
  List<Object> get props => [message];
}
