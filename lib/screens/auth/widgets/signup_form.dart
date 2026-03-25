import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:interactive_learn/core/singleton.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupForm extends HookConsumerWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);
    final successMessage = useState<String?>(null);
    final obscurePassword = useState(true);

    Future<void> handleSignup() async {
      final email = emailController.text.trim();
      final password = passwordController.text;
      final confirm = confirmPasswordController.text;

      if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
        errorMessage.value = 'Please fill in all fields.';
        return;
      }
      if (password != confirm) {
        errorMessage.value = 'Passwords do not match.';
        return;
      }
      if (password.length < 6) {
        errorMessage.value = 'Password must be at least 6 characters.';
        return;
      }

      isLoading.value = true;
      errorMessage.value = null;
      successMessage.value = null;
      try {
        await supabase.auth.signUp(email: email, password: password);
        successMessage.value =
            'Account created! Please check your email to confirm, then log in.';
      } on AuthException catch (e) {
        errorMessage.value = e.message;
      } catch (e) {
        errorMessage.value = 'An unexpected error occurred. Please try again.';
        logger.e('Signup error', error: e);
      } finally {
        isLoading.value = false;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Create Account',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Start your learning journey today',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: passwordController,
          obscureText: obscurePassword.value,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: () => obscurePassword.value = !obscurePassword.value,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: confirmPasswordController,
          obscureText: obscurePassword.value,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => handleSignup(),
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            prefixIcon: const Icon(Icons.lock_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        if (errorMessage.value != null) ...[
          const SizedBox(height: 10),
          Text(
            errorMessage.value!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
        ],
        if (successMessage.value != null) ...[
          const SizedBox(height: 10),
          Text(
            successMessage.value!,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 20),
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: isLoading.value ? null : handleSignup,
            child: isLoading.value
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Sign Up', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already have an account? '),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text(
                'Login',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
