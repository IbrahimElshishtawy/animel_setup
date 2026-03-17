import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = _buildTheme(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF4B1A45),
    scaffoldBackgroundColor: Colors.white,
    inputFillColor: const Color(0xFFF4F2F6),
    appBarBackgroundColor: Colors.white,
    appBarForegroundColor: Colors.black,
  );

  static ThemeData darkTheme = _buildTheme(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF8C3A7B),
    scaffoldBackgroundColor: const Color(0xFF121212),
    inputFillColor: const Color(0xFF1E1E1E),
    appBarBackgroundColor: const Color(0xFF121212),
    appBarForegroundColor: Colors.white,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primaryColor,
    required Color scaffoldBackgroundColor,
    required Color inputFillColor,
    required Color appBarBackgroundColor,
    required Color appBarForegroundColor,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      fontFamily: 'Poppins',
      visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: const Color(0xFFB191C5),
        brightness: brightness,
      ),
    );

    return base.copyWith(
      textTheme: _scaledTextTheme(base.textTheme),
      primaryTextTheme: _scaledTextTheme(base.primaryTextTheme),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 14,
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: appBarBackgroundColor,
        foregroundColor: appBarForegroundColor,
        titleTextStyle: TextStyle(
          color: appBarForegroundColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static TextTheme _scaledTextTheme(TextTheme textTheme) {
    return textTheme.copyWith(
      displayLarge: _scale(textTheme.displayLarge),
      displayMedium: _scale(textTheme.displayMedium),
      displaySmall: _scale(textTheme.displaySmall),
      headlineLarge: _scale(textTheme.headlineLarge),
      headlineMedium: _scale(textTheme.headlineMedium),
      headlineSmall: _scale(textTheme.headlineSmall),
      titleLarge: _scale(textTheme.titleLarge),
      titleMedium: _scale(textTheme.titleMedium),
      titleSmall: _scale(textTheme.titleSmall),
      bodyLarge: _scale(textTheme.bodyLarge),
      bodyMedium: _scale(textTheme.bodyMedium),
      bodySmall: _scale(textTheme.bodySmall),
      labelLarge: _scale(textTheme.labelLarge),
      labelMedium: _scale(textTheme.labelMedium),
      labelSmall: _scale(textTheme.labelSmall),
    );
  }

  static TextStyle? _scale(TextStyle? style) {
    if (style == null || style.fontSize == null) return style;
    return style.copyWith(fontSize: style.fontSize! * 0.92);
  }
}
