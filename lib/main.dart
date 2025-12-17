import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const SIAHealthApp());
}

class SIAHealthApp extends StatelessWidget {
  const SIAHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIA Health - Coach Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1a1f1a),
        primaryColor: const Color(0xFF7ed321),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7ed321),
          secondary: Color(0xFF7ed321),
          surface: Color(0xFF232823),
          background: Color(0xFF1a1f1a),
        ),
        useMaterial3: true,
        cardTheme: const CardThemeData(
          color: Color(0xFF232823),
          elevation: 0,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1a1f1a),
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
