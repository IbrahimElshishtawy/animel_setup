import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    seedColor: const Color(0xFF1F6F68),
    primaryColor: const Color(0xFF1F6F68),
    secondaryColor: const Color(0xFFE0A458),
    scaffoldColor: const Color(0xFFF5F4EF),
    surfaceColor: Colors.white,
    inputFillColor: const Color(0xFFF1F3EE),
    borderColor: const Color(0xFFDCE4DE),
    textColor: const Color(0xFF18302E),
    mutedTextColor: const Color(0xFF667A77),
  );

  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    seedColor: const Color(0xFF6DCDC3),
    primaryColor: const Color(0xFF6DCDC3),
    secondaryColor: const Color(0xFFF0BF84),
    scaffoldColor: const Color(0xFF101514),
    surfaceColor: const Color(0xFF17201F),
    inputFillColor: const Color(0xFF1D2827),
    borderColor: const Color(0xFF243432),
    textColor: const Color(0xFFF2F6F5),
    mutedTextColor: const Color(0xFF9BB0AC),
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color seedColor,
    required Color primaryColor,
    required Color secondaryColor,
    required Color scaffoldColor,
    required Color surfaceColor,
    required Color inputFillColor,
    required Color borderColor,
    required Color textColor,
    required Color mutedTextColor,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      primary: primaryColor,
      secondary: secondaryColor,
      brightness: brightness,
      surface: surfaceColor,
    );

    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldColor,
      fontFamily: 'Poppins',
    );

    final textTheme = baseTheme.textTheme
        .copyWith(
          headlineLarge: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
          headlineMedium: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          headlineSmall: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          titleLarge: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          titleMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          titleSmall: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          bodyLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          bodyMedium: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
          bodySmall: const TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
          labelLarge: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          labelMedium: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          labelSmall: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        )
        .apply(
          bodyColor: textColor,
          displayColor: textColor,
        );

    return baseTheme.copyWith(
      primaryColor: primaryColor,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scaffoldColor,
        surfaceTintColor: Colors.transparent,
        foregroundColor: textColor,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: textColor),
      ),
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
          side: BorderSide(color: borderColor),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: borderColor.withOpacity(brightness == Brightness.dark ? 0.7 : 1),
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: mutedTextColor,
        selectedLabelStyle: textTheme.labelMedium,
        unselectedLabelStyle: textTheme.labelMedium,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: inputFillColor,
        hintStyle: textTheme.bodyMedium?.copyWith(color: mutedTextColor),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: primaryColor, width: 1.2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(46),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor,
          side: BorderSide(color: borderColor),
          minimumSize: const Size.fromHeight(44),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: baseTheme.chipTheme.copyWith(
        backgroundColor: inputFillColor,
        selectedColor: primaryColor,
        disabledColor: inputFillColor,
        side: BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        labelStyle: textTheme.labelMedium,
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
    );
  }
}
