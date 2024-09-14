import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_flutter/data/repository/local/local_data_access.dart';
import 'package:my_flutter/data/repository/remote/auth_repository.dart';
import 'package:my_flutter/di/di.dart';
import 'package:my_flutter/services/auth_services.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository = getIt.get<AuthRepository>();
  LocalDataAccess localDataAccess = getIt.get<LocalDataAccess>();

  AuthCubit() : super(AuthInitialState());

  googleLogin() async {
    final account = await AuthService.login(); // Get account

    if (account != null) {
      emit(AuthLoginByGoogleSuccessState(account));
    } else {
      emit(AuthLoginByGoogleFailedState());
    }
  }

  login(String username, String password) async {
    final response = await _authRepository.login(username, password);

    if (response.statusCode == 200) {
      emit(AuthLoginSuccessState());
    } else {
      emit(AuthLoginFailedState());
    }
  }

  logout() async {
    await _authRepository.logout();

    emit(AuthLogoutState());
  }

  trueConnectLogin() async {
    final response = await _authRepository.trueConnectLogin();

    if (response.statusCode == 200) {
      emit(AuthLoginSuccessState());
    } else {
      emit(AuthLoginFailedState());
    }
  }
}
