import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflex/core/utils/style/typo.dart';
import 'package:payflex/features/home/cubit/beneficiaries_cubit.dart';
import 'package:payflex/features/home/models/beneficiary.dart';

class BeneficiaryDetailPage extends StatelessWidget {
  final String phoneNumber;

  const BeneficiaryDetailPage({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final beneficiariesCubit = context.watch<BeneficiariesCubit>();
    final beneficiary = beneficiariesCubit.state is BeneficiariesLoaded
        ? (beneficiariesCubit.state as BeneficiariesLoaded)
            .beneficiaries
            .firstWhere((b) => b.phoneNumber == phoneNumber)
        : null;

    if (beneficiary == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Top Up $phoneNumber'),
        ),
        body: const Center(
          child: Text('Beneficiary not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(' ${beneficiary.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage User',
                style: header,
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () => context
                    .read<BeneficiariesCubit>()
                    .toggleBeneficiaryStatus(beneficiary),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Active Beneficiary',
                      style: labelBluePrimary,
                    ),
                    Switch(
                        value: beneficiary.isActive,
                        onChanged: (value) => context
                            .read<BeneficiariesCubit>()
                            .toggleBeneficiaryStatus(beneficiary))
                  ],
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () => context
                    .read<BeneficiariesCubit>()
                    .deleteBeneficiary(beneficiary)
                    .then((_) => Navigator.of(context).pop()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delete Beneficiary',
                      style: labelBluePrimary,
                    ),
                    const Icon(
                      Icons.delete,
                      size: 40,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Text(
                'Select Top-Up Amount',
                style: header,
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildTopUpButton(context, beneficiary, 5),
                  _buildTopUpButton(context, beneficiary, 10),
                  _buildTopUpButton(context, beneficiary, 20),
                  _buildTopUpButton(context, beneficiary, 30),
                  _buildTopUpButton(context, beneficiary, 50),
                  _buildTopUpButton(context, beneficiary, 75),
                  _buildTopUpButton(context, beneficiary, 100),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopUpButton(
      BuildContext context, Beneficiary beneficiary, int amount) {
    return ElevatedButton(
      onPressed: () async {
        try {
          context
              .read<BeneficiariesCubit>()
              .topupBeneficiary(beneficiary, amount.toDouble())
              .then((_) => Navigator.of(context).pop());
        } catch (e) {
          // Show error if top-up fails
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Top-up failed: ${e.toString()}')),
          );
        }
      },
      child: Text('\$$amount'),
    );
  }
}
