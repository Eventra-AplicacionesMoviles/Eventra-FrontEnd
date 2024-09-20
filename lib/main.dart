import 'package:flutter/material.dart';
import 'pages/login.dart';  // Importa el archivo login.dart
import 'pages/sign_up.dart'; // Importa el archivo sign_up.dart

void main() {
  runApp(EventraApp());
}

class EventraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/logo.png',
                height: 100,
              ),
              SizedBox(height: 20),
              Text(
                'Eventra',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[900],
                  minimumSize: Size(200, 50),
                ),
                child: Text(
                  'Sign up',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  minimumSize: Size(200, 50),
                ),
                child: Text(
                  'Log in',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Acción para recuperar contraseña
                },
                child: Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}