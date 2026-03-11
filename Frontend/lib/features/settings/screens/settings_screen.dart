import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/widgets/gradient_app_bar.dart';
import 'package:provider/provider.dart';
import '../../../app/navigation/app_routes.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/services/auth_service.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await AuthService.clearTokens();
              context.read<UserProvider>().clear();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (_) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final displayName = user?.fullName.isNotEmpty == true ? user!.fullName : 'User';
    final displayEmail = user?.email ?? 'Not logged in';

    return Scaffold(
      appBar: const GradientAppBar(title: 'Settings'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile card
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 22,
                    child: Text(
                      displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  title: Text(displayName),
                  subtitle: Text(displayEmail),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.editProfile);
                  },
                ),
              ),

              const SizedBox(height: 14),

              SettingsTile(
                icon: Icons.volume_up_outlined,
                title: 'Voice Settings',
                subtitle: 'Urdu voice, speed, pitch',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Voice settings (coming soon)')),
                  );
                },
              ),

              SettingsTile(
                icon: Icons.language_outlined,
                title: 'Language',
                subtitle: 'Urdu / English',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Language settings (coming soon)')),
                  );
                },
              ),

              SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {},
              ),

              const SizedBox(height: 8),

              SettingsTile(
                icon: Icons.logout,
                iconColor: Colors.red,
                title: 'Logout',
                onTap: () => _logout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (_) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'settings'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile card
              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    radius: 22,
                    child: Icon(Icons.person_outline),
                  ),
                  title: const Text('User Name'),
                  subtitle: const Text('example@gmail.com'),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.editProfile);
                  },
                ),
              ),

              const SizedBox(height: 14),

              SettingsTile(
                icon: Icons.volume_up_outlined,
                title: 'Voice Settings',
                subtitle: 'Urdu voice, speed, pitch',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Voice settings (later)')),
                  );
                },
              ),

              SettingsTile(
                icon: Icons.language_outlined,
                title: 'Language',
                subtitle: 'Urdu / English',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Language settings (later)')),
                  );
                },
              ),

              SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {},
              ),

              const SizedBox(height: 8),

              SettingsTile(
                icon: Icons.logout,
                iconColor: Colors.red,
                title: 'Logout',
                onTap: () => _logout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
