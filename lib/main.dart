import 'package:flutter/material.dart' hide Transform;
import 'package:genbi/pages/login_page.dart';
import 'package:genbi/pages/transform.dart';

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
      themeMode: ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,

        // Global default font
        fontFamily: 'HankenGrotesk',

        colorScheme: ColorScheme.fromSeed(
          seedColor: seedPurple,
          brightness: Brightness.light,
        ),

        scaffoldBackgroundColor: Colors.white,

        textTheme: const TextTheme().apply(
          bodyColor: Colors.black87,
          displayColor: Colors.black87,
        ),
      ),
      home: const Transform(companyName: "Halonir"),
      //home: const LoginPage(),
    );
  }
}
