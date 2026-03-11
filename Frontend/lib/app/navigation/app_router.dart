import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/models/word_model.dart';
import 'package:flutter_application_1/features/dictionary/screens/word_detail_screen.dart';
import 'package:flutter_application_1/features/settings/screens/edit_profile_screen.dart';
import 'package:flutter_application_1/features/splash/splash_screen.dart';
import 'app_routes.dart';
import 'bottom_shell.dart';

// Screens
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case AppRoutes.forgot:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case AppRoutes.shell:
        return MaterialPageRoute(builder: (_) => const BottomShell());
      case AppRoutes.wordDetail:
        final word = settings.arguments as WordModel;
        return MaterialPageRoute(builder: (_) => WordDetailScreen(word: word));
      case AppRoutes.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
