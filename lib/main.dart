import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflex/core/router/app_router.dart';
import 'package:payflex/core/utils/app_bloc_observer.dart';
import 'package:payflex/features/home/cubit/beneficiaries_cubit.dart';
import 'package:payflex/features/home/repositories/mock_beneficiary_repository.dart';
import 'package:payflex/features/user/cubit/user_cubit.dart';
import 'package:payflex/features/user/repositories/user_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // setupLocator();
  Bloc.observer = AppBlocObserver();

  runApp(PayflexApp());
}

class PayflexApp extends StatelessWidget {
  PayflexApp({super.key});

  final userCubit = UserCubit(MockUserRepository());
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(
          create: (_) => userCubit,
        ),
        BlocProvider<BeneficiariesCubit>(
          create: (_) =>
              BeneficiariesCubit(MockBeneficiariesRepository(), userCubit),
        ),
        // BlocProvider(create: (context) => getIt.get<UserCubit>()),
        // BlocProvider(create: (context) => getIt.get<BeneficiariesCubit>()),
      ],
      child: MaterialApp(
        title: 'PayFlex App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        onGenerateRoute: AppRouter().onGenerateRoute,
      ),
    );
  }
}
