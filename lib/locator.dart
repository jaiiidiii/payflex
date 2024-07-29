import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:payflex/core/network/api_client.dart';
import 'package:payflex/features/home/cubit/beneficiaries_cubit.dart';
import 'package:payflex/features/home/repositories/beneficiary_repository.dart';
import 'package:payflex/features/home/repositories/mock_beneficiary_repository.dart';
import 'package:payflex/features/user/cubit/user_cubit.dart';
import 'package:payflex/features/user/repositories/user_repository.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Register Dio
  // getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerSingleton<ApiClient>(ApiClient(dio: Dio()));

  // Register Repository
  getIt.registerLazySingleton<UserRepository>(() => MockUserRepository());
  getIt.registerLazySingleton<BeneficiariesRepository>(
      () => MockBeneficiariesRepository());

  // Register Cubits
  getIt.registerFactory(() => UserCubit(getIt()));
  getIt.registerFactory(() =>
      BeneficiariesCubit(getIt<BeneficiariesRepository>(), getIt<UserCubit>()));
}
