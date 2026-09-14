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
    const ink = Color(0xFF121311);
    const canvas = Color(0xFFF3F1EA);
    const lime = Color(0xFFC8FF22);
    const soft = Color(0xFFEAE7DE);

    final scheme = ColorScheme.fromSeed(
      seedColor: lime,
      brightness: Brightness.light,
      surface: Colors.white,
    ).copyWith(
      primary: ink,
      onPrimary: Colors.white,
      secondary: lime,
      onSecondary: ink,
      tertiary: const Color(0xFF7E57C2),
      surfaceContainerLowest: const Color(0xFFFBFAF6),
      surfaceContainerLow: const Color(0xFFF6F4EE),
      surfaceContainer: soft,
      outlineVariant: const Color(0xFFE0DED6),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foldable Motion Lab',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: canvas,
        colorScheme: scheme,
        splashFactory: InkSparkle.splashFactory,
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: ink,
              displayColor: ink,
            ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: ink,
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.1,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF7F5EF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFE4E1D8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: ink, width: 1.4),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFE8E5DD),
          thickness: 1,
          space: 1,
        ),
      ),
      home: const FunctionalFoldScreen(),
    );
  }
}
