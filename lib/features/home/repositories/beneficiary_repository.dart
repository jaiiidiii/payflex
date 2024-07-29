import 'package:payflex/features/home/models/beneficiary.dart';

abstract class BeneficiariesRepository {
  Future<List<Beneficiary>> getBeneficiaries(String userId);
  Future<void> addBeneficiary(String userId, Beneficiary beneficiary);
  Future<void> deleteBeneficiary(String userId, Beneficiary beneficiary);
  Future<void> topupBeneficiary(
      String userId, Beneficiary beneficiary, double amount);
  Future<void> toggleBeneficiaryStatus(String userId, Beneficiary beneficiary);

  // Methods for tracking top-ups
  Future<double> getBeneficiaryMonthlyTopUp(
      String userId, Beneficiary beneficiary);
  Future<double> getTotalMonthlyTopUp(String userId);
}
