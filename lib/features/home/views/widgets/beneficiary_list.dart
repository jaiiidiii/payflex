import 'package:flutter/material.dart';
import 'package:payflex/features/home/models/beneficiary.dart';
import 'package:payflex/features/home/views/widgets/beneficiary_card.dart';

class BeneficiaryList extends StatelessWidget {
  final List<Beneficiary> beneficiaries;
  final Function(Beneficiary) onTopUp;
  final Function(Beneficiary) onToggleActive;

  const BeneficiaryList({
    super.key,
    required this.beneficiaries,
    required this.onTopUp,
    required this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: beneficiaries.length,
      itemBuilder: (context, index) {
        return BeneficiaryCard(
          beneficiary: beneficiaries[index],
          onTopUp: () => onTopUp(beneficiaries[index]),
          onToggleActive: () => onToggleActive(beneficiaries[index]),
        );
      },
    );
  }
}
