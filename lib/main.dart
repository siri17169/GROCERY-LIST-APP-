import 'package:flutter/material.dart';
import 'screens/login_page.dart';

void main() => runApp(const MeraDukhanApp());

class MeraDukhanApp extends StatelessWidget {
  const MeraDukhanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF1F4F1),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
    );
  }
}