import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflex/core/router/route_constants.dart';
import 'package:payflex/core/utils/style/color.dart';
import 'package:payflex/core/utils/style/typo.dart';
import 'package:payflex/features/home/views/add_beneficiary_screen.dart';
import 'package:payflex/features/home/views/widgets/beneficiary_list.dart';
import 'package:payflex/features/home/views/widgets/balance_display.dart';
import 'package:payflex/features/home/views/widgets/user_widget.dart';
import 'package:payflex/features/home/cubit/beneficiaries_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: softBlue,
        body: BlocBuilder<BeneficiariesCubit, BeneficiariesState>(
          builder: (context, beneficiariesState) {
            if (beneficiariesState is BeneficiariesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (beneficiariesState is BeneficiariesLoaded) {
              return const Body();
            } else if (beneficiariesState is BeneficiariesError) {
              return Center(child: Text(beneficiariesState.message));
            }
            return Container();
          },
        ));
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          headerSection(context),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Beneficiaries',
                      style: subHeader,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        showModalBottomSheet(
                          useSafeArea: true,
                          context: context,
                          builder: (context) {
                            return AddBeneficiaryScreen();
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 170,
                  child: Center(
                    child: BlocConsumer<BeneficiariesCubit, BeneficiariesState>(
                      listener:
                          (BuildContext context, BeneficiariesState state) {
                        if (state is BeneficiariesError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is BeneficiariesLoaded) {
                          return BeneficiaryList(
                            beneficiaries: state.beneficiaries,
                            onTopUp: (beneficiary) {
                              Navigator.pushNamed(
                                context,
                                RouteConstants.beneDetail,
                                arguments: beneficiary.phoneNumber,
                              );
                            },
                            onToggleActive: (beneficiary) {
                              context
                                  .read<BeneficiariesCubit>()
                                  .toggleBeneficiaryStatus(
                                      context, beneficiary);
                            },
                          );
                        } else if (state is BeneficiariesError) {
                          return Center(
                            child: Text(state.message),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget headerSection(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 245,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.only(
          top: 60,
          left: 24,
          right: 24,
        ),
        child: Column(
          children: [
            UserWidget(),
            SizedBox(height: 30),
            BalanceDisplay(),
          ],
        ),
      ),
    );
  }
}
