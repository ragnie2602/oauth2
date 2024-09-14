import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter/view/auth/cubit/auth_cubit.dart';
import 'package:my_flutter/view/auth/login_page.dart';
import 'package:my_flutter/view/home/cubit/home_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authCubit = AuthCubit();
  final homeCubit = HomeCubit();

  @override
  void initState() {
    super.initState();
    homeCubit.getCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Đăng nhập được rồi đấy thím'),
          const SizedBox(height: 16),
          BlocProvider.value(
              value: homeCubit,
              child: BlocBuilder<HomeCubit, HomeState>(
                buildWhen: (previous, current) => true,
                builder: (context, state) => Column(
                  children: [
                    Text(state is HomeGetCountSuccessState
                        ? 'Số Unit trong công ty hiện giờ: ${state.count}'
                        : 'Lỗi rồi, bấm REFRESH TOKEN đi thím'),
                    const SizedBox(height: 16),
                    state is HomeGetCountFailedState
                        ? ElevatedButton(
                            onPressed: () {
                              homeCubit.getCount();
                            },
                            child: const Text('REFRESH TOKEN'))
                        : Container(),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: () {
                          onLogoutPressed();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              (route) => false);
                        },
                        child: const Text('Logout'))
                  ],
                ),
              ))
        ],
      )),
    );
  }

  onLogoutPressed() async {
    await authCubit.logout();
  }
}
