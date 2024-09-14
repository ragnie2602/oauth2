import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter/di/di.dart';

import 'package:my_flutter/view/auth/cubit/auth_cubit.dart';
import 'package:my_flutter/view/home/google_profile.dart';
import 'package:my_flutter/view/home/home_page.dart';

class LoginPage extends StatelessWidget {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final authCubit = getIt<AuthCubit>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider.value(
        value: authCubit,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            // Just a bit ... graphics
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                  controller: userController,
                  decoration: const InputDecoration(hintText: 'Username')),
              const SizedBox(height: 16),
              TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(hintText: 'Password'),
                  obscureText: true),
              const SizedBox(height: 16),
              BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLoginSuccessState) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                          (route) => false);
                    } // Navigate to the successfully loged in screen
                    if (state is AuthLoginByGoogleSuccessState &&
                        state.account != null) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  GoogleProfile(user: state.account)),
                          (route) => false);
                    } // Navigate to the Google information screen
                  },
                  buildWhen: (previous, current) =>
                      current is AuthLoginFailedState ||
                      current is AuthLoginByGoogleFailedState,
                  builder: (context, state) {
                    return state is AuthLoginFailedState
                        ? const Text('Mật khẩu sai',
                            style: TextStyle(color: Colors.red))
                        : state is AuthLoginByGoogleFailedState
                            ? const Text('Đăng nhập Google thất bại',
                                style: TextStyle(color: Colors.red))
                            : Container();
                  }),
              const SizedBox(height: 16),
              Container(
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width / 3),
                  child: ElevatedButton(
                      onPressed: onLoginPressed, child: const Text('SIGN IN'))),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: onGoogleLoginPressed,
                  child: const Text('SIGN IN WITH GOOGLE')),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: onTrueConnectLoginPressed,
                  child: const Text('SIGN IN WITH TRUECONNECT'))
            ],
          ),
        ),
      ),
    );
  }

  onGoogleLoginPressed() async {
    await authCubit.googleLogin(); // Call to login by Google method of cubit
  }

  onLoginPressed() async {
    await authCubit.login(
        userController.text, passwordController.text); // Similar to the above
  }

  onTrueConnectLoginPressed() async {
    await authCubit.trueConnectLogin(); // Similar to the above
  }
}
