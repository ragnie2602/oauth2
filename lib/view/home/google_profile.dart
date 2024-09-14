import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_flutter/view/auth/cubit/auth_cubit.dart';
import 'package:my_flutter/view/auth/login_page.dart';

class GoogleProfile extends StatelessWidget {
  final authCubit = AuthCubit();
  final GoogleSignInAccount? user;

  GoogleProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Đăng nhập bằng Google thành công rồi thím ơi!'),
          const SizedBox(height: 16),
          CircleAvatar(
              radius: 40, backgroundImage: NetworkImage(user?.photoUrl ?? '')),
          const SizedBox(height: 16),
          Text('Email: ${user?.email}'),
          const SizedBox(height: 16),
          Text('Name: ${user?.displayName}'),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: () {
                onLogoutPressed();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false);
              },
              child: const Text('Logout'))
        ],
      )),
    );
  }

  onLogoutPressed() async {
    await authCubit.logout();
  }
}
