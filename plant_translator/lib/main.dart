import 'package:flutter/material.dart';
import 'screens/loginpage.dart';
import 'screens/signuppage.dart';
import 'screens/introslider.dart';
import 'screens/main_wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plant Translator',
      initialRoute: '/intro',
      routes: {
        '/intro': (context) => const IntroSlider(),
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const MainWrapper(),
      },
    );
  }
}
