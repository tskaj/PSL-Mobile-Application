import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/navigation/app_routes.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  String? _nameValidator(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Full name is required';
    if (v.length < 5) return 'Name must be at least 5 characters';
    return null;
  }

  String? _emailValidator(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Email is required';
    final gmailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    if (!gmailRegex.hasMatch(v)) {
      return 'Please enter a valid Gmail address (example@gmail.com)';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Password must contain at least 1 uppercase letter';
    if (!RegExp(r'\d').hasMatch(v)) return 'Password must contain at least 1 digit';
    if (!RegExp(r'[^A-Za-z0-9]').hasMatch(v)) return 'Password must contain at least 1 special character';
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != passCtrl.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _onSignupPressed() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    setState(() => _loading = true);

    final error = await AuthService.signup(
      email: emailCtrl.text,
      password: passCtrl.text,
      fullName: nameCtrl.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    // Load profile into provider then navigate directly to app
    await context.read<UserProvider>().loadProfile();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.shell);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create your account',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'Sign up to save favorites, history, and settings.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 20),

                AppTextField(
                  label: 'Full Name',
                  hint: 'Enter your name',
                  controller: nameCtrl,
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: _nameValidator,
                ),
                const SizedBox(height: 14),

                AppTextField(
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: _emailValidator,
                ),
                const SizedBox(height: 14),

                AppTextField(
                  label: 'Password',
                  hint: 'Create a password',
                  controller: passCtrl,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                  validator: _passwordValidator,
                ),
                const SizedBox(height: 14),

                AppTextField(
                  label: 'Confirm Password',
                  hint: 'Re-enter password',
                  controller: confirmCtrl,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                  validator: _confirmPasswordValidator,
                ),
                const SizedBox(height: 20),

                AppPrimaryButton(
                  text: _loading ? 'Creating account...' : 'Create Account',
                  onPressed: _loading ? null : _onSignupPressed,
                ),

                const SizedBox(height: 14),

                Center(
                  child: TextButton(
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacementNamed(context, AppRoutes.login);
                      }
                    },
                    child: const Text('Already have an account? Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


