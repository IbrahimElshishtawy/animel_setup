// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'app_tokens.dart';

class AppTheme {
  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    seedColor: const Color(0xFF1B6F67),
    primaryColor: const Color(0xFF1B6F67),
    secondaryColor: const Color(0xFFE6A04B),
    tertiaryColor: const Color(0xFF6B84C7),
    scaffoldColor: const Color(0xFFF4F6F2),
    surfaceColor: const Color(0xFFFFFEFB),
    surfaceTintColor: const Color(0xFFE9F1EE),
    inputFillColor: const Color(0xFFF0F3EF),
    borderColor: const Color(0xFFD9E2DB),
    textColor: const Color(0xFF16302D),
    mutedTextColor: const Color(0xFF657A76),
  );

  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    seedColor: const Color(0xFF72D1C8),
    primaryColor: const Color(0xFF72D1C8),
    secondaryColor: const Color(0xFFF2BA77),
    tertiaryColor: const Color(0xFF9AAEFF),
    scaffoldColor: const Color(0xFF091111),
    surfaceColor: const Color(0xFF101A1A),
    surfaceTintColor: const Color(0xFF142220),
    inputFillColor: const Color(0xFF162323),
    borderColor: const Color(0xFF233433),
    textColor: const Color(0xFFF4F7F5),
    mutedTextColor: const Color(0xFF98AEAA),
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color seedColor,
    required Color primaryColor,
    required Color secondaryColor,
    required Color tertiaryColor,
    required Color scaffoldColor,
    required Color surfaceColor,
    required Color surfaceTintColor,
    required Color inputFillColor,
    required Color borderColor,
    required Color textColor,
    required Color mutedTextColor,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      brightness: brightness,
      surface: surfaceColor,
    );

    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldColor,
      fontFamily: 'Poppins',
      visualDensity: VisualDensity.standard,
    );

    final textTheme = baseTheme.textTheme
        .copyWith(
          headlineLarge: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
          headlineMedium: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
          headlineSmall: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
          titleLarge: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
          titleMedium: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
          titleSmall: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            height: 1.28,
          ),
          bodyLarge: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            height: 1.45,
          ),
          bodyMedium: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.45,
          ),
          bodySmall: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
          labelLarge: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          labelMedium: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          labelSmall: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        )
        .apply(bodyColor: textColor, displayColor: textColor);

    return baseTheme.copyWith(
      primaryColor: primaryColor,
      cardColor: surfaceColor,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scaffoldColor,
        surfaceTintColor: Colors.transparent,
        foregroundColor: textColor,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: textColor),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: borderColor),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: borderColor.withOpacity(brightness == Brightness.dark ? 0.7 : 1),
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: surfaceTintColor,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: textColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: primaryColor, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: colorScheme.error, width: 1.2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor,
          side: BorderSide(color: borderColor),
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      ),
      chipTheme: baseTheme.chipTheme.copyWith(
        backgroundColor: inputFillColor,
        selectedColor: primaryColor,
        disabledColor: inputFillColor,
        side: BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        labelStyle: textTheme.labelMedium,
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryColor;
          return brightness == Brightness.dark
              ? const Color(0xFFB7C7C4)
              : Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withOpacity(0.28);
          }
          return borderColor;
        }),
      ),
    );
  }
}
