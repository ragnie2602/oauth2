import 'package:flutter/material.dart';
import 'package:my_flutter/di/di.dart';
import 'package:my_flutter/view/auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Đảm bảo các đối tượng global đã được khởi tạo
  await configureInjection(); // Khởi tạo và đăng ký với get_it
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginPage());
  }
}
