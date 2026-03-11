import 'package:flutter/material.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  // ---------- Gmail Email Validator ----------
  String? _emailValidator(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Email is required';

    final gmailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$', caseSensitive: false);

    if (!gmailRegex.hasMatch(v)) {
      return 'Please enter a valid Gmail address (example@gmail.com)';
    }

    return null;
  }
  // -----------------------------------------

  void _onSendPressed() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    // FRONTEND ONLY (no backend yet)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('If this email exists, a reset link will be sent.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
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
                  'Reset your password',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Enter your email address and we’ll send you instructions to reset your password.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                      ),
                ),
                const SizedBox(height: 20),

                AppTextField(
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: _emailValidator,
                ),

                const SizedBox(height: 20),

                AppPrimaryButton(
                  text: 'Send Reset Link',
                  onPressed: _onSendPressed,
                ),

                const SizedBox(height: 12),

                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to Login'),
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
