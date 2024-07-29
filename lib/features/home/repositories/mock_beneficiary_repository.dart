import 'package:payflex/features/home/models/beneficiary.dart';
import 'package:payflex/features/home/repositories/beneficiary_repository.dart';

class MockBeneficiariesRepository extends BeneficiariesRepository {
  final Map<String, List<Map<String, dynamic>>> _monthlyTopUps = {};
  final Map<String, List<Beneficiary>> _userBeneficiaries = {
    '1': [
      const Beneficiary(
          name: 'Alice',
          phoneNumber: '+971501234567',
          photo: 'assets/alice.png',
          isActive: true,
          balance: 0),
      const Beneficiary(
          name: 'Bob',
          phoneNumber: '+971529876543',
          photo: 'assets/bob.png',
          isActive: true,
          balance: 0),
      const Beneficiary(
          name: 'Charlie',
          phoneNumber: '+971563210987',
          photo: 'assets/charlie.png',
          isActive: true,
          balance: 0),
    ],
    '2': [
      const Beneficiary(
          name: 'Richard',
          phoneNumber: '+971527654321',
          photo: 'assets/charlie.png',
          isActive: true,
          balance: 0),
    ],
  };
  @override
  Future<List<Beneficiary>> getBeneficiaries(String userId) async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay
    return _userBeneficiaries[userId] ?? [];
  }

  @override
  Future<void> addBeneficiary(String userId, Beneficiary beneficiary) async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay
    _userBeneficiaries.putIfAbsent(userId, () => []);
    _userBeneficiaries[userId]!.add(beneficiary);
  }

  @override
  Future<void> deleteBeneficiary(String userId, Beneficiary beneficiary) async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay
    _userBeneficiaries[userId]?.removeWhere((b) => b == beneficiary);
  }

  @override
  Future<void> toggleBeneficiaryStatus(
      String userId, Beneficiary beneficiary) async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay
    final beneficiaries = _userBeneficiaries[userId];
    if (beneficiaries != null) {
      final bene = beneficiaries.firstWhere((b) => b == beneficiary);
      final updatedBeneficiary = bene.copyWith(isActive: !bene.isActive);
      beneficiaries[beneficiaries.indexOf(bene)] = updatedBeneficiary;
    }
  }

  @override
  Future<void> topupBeneficiary(
      String userId, Beneficiary beneficiary, double amount) async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay
    final beneficiaries = _userBeneficiaries[userId];
    if (beneficiaries != null) {
      final bene = beneficiaries.firstWhere((b) => b == beneficiary);
      final updatedBeneficiary = bene.copyWith(balance: bene.balance + amount);
      beneficiaries[beneficiaries.indexOf(bene)] = updatedBeneficiary;

      // Track monthly top-ups
      _monthlyTopUps.putIfAbsent(userId, () => []);
      _monthlyTopUps[userId]!.add({
        'beneficiary': beneficiary,
        'amount': amount,
        'date': DateTime.now(),
      });
    }
  }

  @override
  Future<double> getBeneficiaryMonthlyTopUp(
      String userId, Beneficiary beneficiary) async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay
    final now = DateTime.now();
    final topUps = _monthlyTopUps[userId]
        ?.where((topup) =>
            topup['beneficiary'] == beneficiary &&
            topup['date'].year == now.year &&
            topup['date'].month == now.month)
        .toList();

    double sum = 0.0;
    if (topUps != null) {
      for (var topup in topUps) {
        sum += topup['amount'] as double? ?? 0.0;
      }
    }

    return sum;
  }

  @override
  Future<double> getTotalMonthlyTopUp(String userId) async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay
    final now = DateTime.now();
    final topUps = _monthlyTopUps[userId]
        ?.where((topup) =>
            topup['date'].year == now.year && topup['date'].month == now.month)
        .toList();

    double sum = 0.0;
    if (topUps != null) {
      for (var topup in topUps) {
        sum += topup['amount'] as double? ?? 0.0;
      }
    }

    return sum;
  }
}
