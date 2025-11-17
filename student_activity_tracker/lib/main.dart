import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const StudentActivityTrackerApp());
}

class StudentActivityTrackerApp extends StatelessWidget {
  const StudentActivityTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Activity Tracker',
      // Menerapkan Material Design 3
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

