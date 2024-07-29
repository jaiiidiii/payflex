import 'package:flutter/material.dart';
import 'package:payflex/core/utils/helper.dart';
import 'package:payflex/core/utils/style/typo.dart';
import 'package:payflex/features/home/models/beneficiary.dart';

class BeneficiaryCard extends StatelessWidget {
  final Beneficiary beneficiary;
  final VoidCallback onTopUp;
  final VoidCallback onToggleActive;

  const BeneficiaryCard({
    super.key,
    required this.beneficiary,
    required this.onTopUp,
    required this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(Helper()
                  .getImagePathForMobileNumber(beneficiary.phoneNumber)),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              beneficiary.name,
              style: subHeader,
            ),
            Text(beneficiary.phoneNumber),
            ElevatedButton(
              onPressed: onTopUp,
              child: const Text('Recharge now'),
            ),
          ],
        ),
      ),
    );
  }
}
