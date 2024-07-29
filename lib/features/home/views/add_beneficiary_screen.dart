import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflex/core/utils/style/typo.dart';
import 'package:payflex/core/utils/validators.dart';
import 'package:payflex/features/home/cubit/add_beneficiary_cubit.dart';
import 'package:payflex/features/home/cubit/add_beneficiary_form_cubit.dart';
import 'package:payflex/features/home/cubit/beneficiaries_cubit.dart';

class AddBeneficiaryScreen extends StatelessWidget {
  AddBeneficiaryScreen({super.key});
  final addBeneCubit = AddBeneficiaryFormCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddBeneficiaryCubit>(
      create: (context) => AddBeneficiaryCubit(),
      child: Scaffold(
        bottomSheet: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<AddBeneficiaryCubit, AddBeneficiaryState>(
            listener: (context, state) {
              if (state is BeneficiaryAdded) {
                context
                    .read<BeneficiariesCubit>()
                    .addBeneficiary(context, state.beneficiary);

                Navigator.pop(context);
              } else if (state is BeneficiaryError) {
                // Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: BlocBuilder<AddBeneficiaryFormCubit, AddBeneficiaryFormData>(
              bloc: addBeneCubit,
              builder: (context, state) {
                return ListView(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: addBeneCubit.nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      maxLength: 20,
                      validator: (value) =>
                          Validators.minLengthValidator(value, 4),
                    ),
                    TextFormField(
                      controller: addBeneCubit.phoneNumberController,
                      maxLength: 14,
                      decoration:
                          const InputDecoration(labelText: 'Phone Number'),
                      keyboardType: TextInputType.phone,
                      validator: (value) => Validators.phoneValidator(value),
                    ),
                    SwitchListTile(
                      title: Text(
                        'Active Beneficiary',
                        style: labelBluePrimary,
                      ),
                      value: state.isActive,
                      onChanged: (value) {
                        addBeneCubit.toggleActiveStatus();
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AddBeneficiaryCubit>().addBeneficiary(
                              name: state.name,
                              phoneNumber: state.phoneNumber,
                              isActive: state.isActive,
                            );
                      },
                      child: const Text('Add Beneficiary'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
