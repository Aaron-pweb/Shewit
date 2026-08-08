import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: Initialize Hive and Secure Storage here
  
  runApp(const ProviderScope(child: ShewitApp()));
}

class ShewitApp extends StatelessWidget {
  const ShewitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shewit',
      theme: AppTheme.lightTheme,
      home: const Scaffold(
        body: Center(
          child: Text('Shewit E-Commerce App initialized.'),
        ),
      ),
    );
  }
}
