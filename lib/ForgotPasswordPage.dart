// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import '../tolist_model.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  bool userFound = false;
  bool passwordUpdated = false;

  void _checkEmail() {
    final realm = Realm(Configuration.local([UserProfile.schema]));
    final user =
        realm.all<UserProfile>().query('email == \$0', [
          emailController.text,
        ]).firstOrNull;

    if (user != null) {
      setState(() {
        userFound = true;
        passwordUpdated = false;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email not found!')));
    }
  }

  void _resetPassword() {
    final realm = Realm(Configuration.local([UserProfile.schema]));
    final user =
        realm.all<UserProfile>().query('email == \$0', [
          emailController.text,
        ]).firstOrNull;

    if (user != null) {
      realm.write(() {
        user.password = newPasswordController.text;
      });
      setState(() {
        passwordUpdated = true;
      });

      // ✅ Tự động quay lại sau 2 giây
      Future.delayed(const Duration(seconds: 2), () {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      });
    }
  }

  InputDecoration inputStyle(String label) => InputDecoration(
    labelText: label,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.deepPurple),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recover Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Enter your email to reset password:'),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: inputStyle('Email'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkEmail,
              child: const Text('Check Email'),
            ),
            const SizedBox(height: 20),

            if (userFound) ...[
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: inputStyle('New Password'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _resetPassword,
                child: const Text('Reset Password'),
              ),
            ],

            if (passwordUpdated)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  '✅ Password reset successfully! Redirecting...',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
