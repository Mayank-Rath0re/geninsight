import 'package:flutter/material.dart';
import 'package:genbi/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedPurple = Color(0xFF8B5CF6); // Soft modern purple

    return MaterialApp(
      title: 'GenInSight',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,

        // Global default font
        fontFamily: 'HankenGrotesk',

        colorScheme: ColorScheme.fromSeed(
          seedColor: seedPurple,
          brightness: Brightness.dark,
        ),

        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const LoginPage(),
    );
  }
}
