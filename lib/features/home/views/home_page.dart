import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflex/core/router/route_constants.dart';
import 'package:payflex/core/utils/helper.dart';
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
        body: BlocConsumer<BeneficiariesCubit, BeneficiariesState>(
          listener: (BuildContext context, BeneficiariesState state) {
            if (state is BeneficiariesSnackBarError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, beneficiariesState) {
            if (beneficiariesState is BeneficiariesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (beneficiariesState is BeneficiariesLoaded ||
                beneficiariesState is BeneficiariesSnackBarError) {
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
                            return const AddBeneficiaryScreen();
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
                                  .toggleBeneficiaryStatus(beneficiary);
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

  BlocBuilder<BeneficiariesCubit, BeneficiariesState> list2() {
    return BlocBuilder<BeneficiariesCubit, BeneficiariesState>(
      builder: (context, beneficiariesState) {
        final beneficiaries =
            beneficiariesState is BeneficiariesSnackBarError &&
                    beneficiariesState.cachedBeneficiaries != null
                ? beneficiariesState.cachedBeneficiaries
                : beneficiariesState is BeneficiariesLoaded
                    ? beneficiariesState.beneficiaries
                    : null;
        return beneficiaries == null
            ? Container()
            : ListView.builder(
                shrinkWrap: true,
                // scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: beneficiaries.length,
                itemBuilder: (context, index) {
                  final beneficiary = beneficiaries[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(Helper()
                          .getImagePathForMobileNumber(
                              beneficiary.phoneNumber)),
                    ),
                    title: Text(beneficiary.name),
                    subtitle:
                        Text(beneficiary.isActive ? 'Active' : 'Inactive'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.attach_money),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteConstants.beneDetail,
                              arguments: beneficiary.phoneNumber,
                            );
                            // Implement top-up action
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context
                                .read<BeneficiariesCubit>()
                                .deleteBeneficiary(beneficiary);
                          },
                        ),
                        Switch(
                          value: beneficiary.isActive,
                          onChanged: (value) {
                            context
                                .read<BeneficiariesCubit>()
                                .toggleBeneficiaryStatus(beneficiary);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
      },
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
