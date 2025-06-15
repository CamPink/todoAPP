import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'login_page.dart';
import 'register_page.dart';

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: {
        '/': (context) => const LoginPage(), // ✅ KHÔNG còn onLoginSuccess
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
