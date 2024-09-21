import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/sign_up.dart';
import 'pages/welcome_page.dart';

void main() {
  runApp(const EventraApp());
}

class EventraApp extends StatelessWidget {
  const EventraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blueGrey,
      ),
      home: const WelcomePage(), // Página inicial es WelcomePage
      routes: {
        '/login': (context) => const LoginPage(),
        '/welcome': (context) => const WelcomePage(), // Añadir ruta para WelcomePage
        '/signup': (context) => const SignUpPage(),
      },
    );
  }
}
