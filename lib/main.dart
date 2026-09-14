import 'package:flutter/material.dart';

import 'screens/functional_fold_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FoldableMotionLabApp());
}

class FoldableMotionLabApp extends StatelessWidget {
  const FoldableMotionLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foldable Motion Lab',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F3EE),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF171717),
          brightness: Brightness.light,
        ),
      ),
      home: const FunctionalFoldScreen(),
    );
  }
}
