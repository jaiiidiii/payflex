import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflex/core/router/route_constants.dart';
import 'package:payflex/core/utils/style/typo.dart';
import 'package:payflex/features/home/cubit/beneficiaries_cubit.dart';
import 'package:payflex/features/user/cubit/user_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserLoaded) {
            context.read<BeneficiariesCubit>().loadBeneficiaries();
            Navigator.pushNamed(
              context,
              RouteConstants.home,
            );
          } else if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/app_logo.png', height: 200),
                  const SizedBox(
                    height: 120,
                  ),
                  Text(
                    'Select User',
                    style: largePrimaryDark,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserCubit>().loginUser('1');
                    },
                    child: const Text('Login as John Doe Verified User'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserCubit>().loginUser('2');
                    },
                    child: const Text('Login as Jane Smith Unverified User'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
