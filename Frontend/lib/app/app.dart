import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/navigation/app_routes.dart';
import 'theme/app_theme.dart';
import 'navigation/app_router.dart';

class PslApp extends StatelessWidget {
  const PslApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PSL Translator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRoutes.splash,
    );
  }
}
