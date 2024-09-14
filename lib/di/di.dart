import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:my_flutter/data/repository/local/local_data_access.dart';
import 'package:my_flutter/data/repository/local/shared_pref_helper.dart';
import 'package:my_flutter/data/repository/remote/auth_repository.dart';
import 'package:my_flutter/data/repository/remote/unit_repository.dart';
import 'package:my_flutter/view/auth/cubit/auth_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

configureInjection() async {
  getIt.registerFactory<Dio>(() => Dio());

  getIt.registerFactory(() => AuthCubit());
  getIt.registerFactory(() => AuthRepository());
  getIt.registerFactory(() => UnitRepository());

  final sharedPref = await SharedPreferences.getInstance();

  getIt.registerLazySingleton<LocalDataAccess>(
      () => SharedPrefHelper(sharedPref));
}
