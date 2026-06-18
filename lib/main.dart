import 'package:flutter/material.dart';
import 'package:genbi/pages/transform_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GenInSight',
      debugShowCheckedModeBanner: false,
      // Setting the theme mode strictly to dark
      themeMode: ThemeMode.dark,
      // Configuring the dark theme properties
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor:
            Colors.transparent, // Allows the gradient to show through
      ),
      home: const TransformPage(),
    );
  }
}
