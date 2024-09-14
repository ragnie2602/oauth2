part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoginSuccessState extends AuthState {}

class AuthLoginFailedState extends AuthState {}

class AuthLoginByGoogleSuccessState extends AuthState {
  final GoogleSignInAccount? account;

  const AuthLoginByGoogleSuccessState(this.account);
  @override
  List<Object?> get props => [account];
}

class AuthLoginByGoogleFailedState extends AuthState {}

class AuthLogoutState extends AuthState {}
