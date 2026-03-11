import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/widgets/gradient_app_bar.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameCtrl;
  late final TextEditingController emailCtrl;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    nameCtrl = TextEditingController(text: user?.fullName ?? '');
    emailCtrl = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    super.dispose();
  }

  String? _nameValidator(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Name is required';
    if (value.length < 5) return 'Name must be at least 5 characters';
    return null;
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);

    final error = await AuthService.updateProfile(fullName: nameCtrl.text);

    if (!mounted) return;
    setState(() => _loading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    // Refresh profile in provider
    await context.read<UserProvider>().loadProfile();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Edit Profile'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  hint: 'Your email address',
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  // Email is read-only (used as username)
                  validator: null,
                ),
                const SizedBox(height: 6),
                Text(
                  'Email cannot be changed.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.black45),
                ),
                const SizedBox(height: 20),
                AppPrimaryButton(
                  text: _loading ? 'Saving...' : 'Save Changes',
                  onPressed: _loading ? null : _onSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
