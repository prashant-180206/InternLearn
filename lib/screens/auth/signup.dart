import 'package:flutter/material.dart';
import 'package:interactive_learn/screens/auth/widgets/signup_form.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/app_logo.png',
                height: 100,
                width: 180,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              const SignupForm(),
            ],
          ),
        ),
      ),
    );
  }
}
