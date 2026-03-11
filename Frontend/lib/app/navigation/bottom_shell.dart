import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/widgets/gradient_bottom_nav.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/camera/screens/camera_screen.dart';
import '../../features/dictionary/screens/dictionary_screen.dart';
import '../../features/settings/screens/settings_screen.dart';

class BottomShell extends StatefulWidget {
  const BottomShell({super.key});

  @override
  State<BottomShell> createState() => _BottomShellState();
}

class _BottomShellState extends State<BottomShell> {
  int index = 0;

  final pages = const [
    HomeScreen(),
    CameraScreen(),
    DictionaryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: GradientBottomNav(
  currentIndex: index,
  onTap: (v) => setState(() => index = v),
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.videocam_outlined), label: 'Camera'),
    BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Dictionary'),
    BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
  ],
),
    );
  }
}
