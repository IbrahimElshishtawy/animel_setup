// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'app_tokens.dart';

class AppTheme {
  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    seedColor: AppPalette.plum,
    primaryColor: AppPalette.plum,
    secondaryColor: AppPalette.sunset,
    tertiaryColor: AppPalette.indigo,
    scaffoldColor: AppPalette.shell,
    surfaceColor: AppPalette.surface,
    surfaceTintColor: AppPalette.blush,
    inputFillColor: const Color(0xFFF3F8F9),
    borderColor: AppPalette.border,
    textColor: AppPalette.text,
    mutedTextColor: AppPalette.muted,
  );

  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    seedColor: AppPalette.plum,
    primaryColor: AppPalette.magenta,
    secondaryColor: AppPalette.sunset,
    tertiaryColor: AppPalette.indigo,
    scaffoldColor: AppPalette.ink,
    surfaceColor: AppPalette.darkSurface,
    surfaceTintColor: const Color(0xFF11242E),
    inputFillColor: const Color(0xFF162C36),
    borderColor: AppPalette.darkBorder,
    textColor: AppPalette.darkText,
    mutedTextColor: AppPalette.darkMuted,
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
            fontSize: 34,
            fontWeight: FontWeight.w800,
            height: 1.04,
            letterSpacing: -0.8,
          ),
          headlineMedium: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.08,
            letterSpacing: -0.6,
          ),
          headlineSmall: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 1.15,
            letterSpacing: -0.4,
          ),
          titleLarge: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 1.24,
          ),
          titleMedium: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
          titleSmall: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
          bodyLarge: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            height: 1.55,
          ),
          bodyMedium: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
          bodySmall: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.45,
          ),
          labelLarge: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
          labelMedium: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
          labelSmall: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        )
        .apply(bodyColor: textColor, displayColor: textColor);

    return baseTheme.copyWith(
      primaryColor: primaryColor,
      cardColor: surfaceColor.withOpacity(
        brightness == Brightness.dark ? 0.8 : 0.88,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
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
          side: BorderSide(color: borderColor.withOpacity(0.72)),
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
        color: borderColor.withOpacity(
          brightness == Brightness.dark ? 0.72 : 1,
        ),
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
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: inputFillColor.withOpacity(
          brightness == Brightness.dark ? 0.9 : 0.82,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: mutedTextColor),
        prefixIconColor: mutedTextColor,
        suffixIconColor: mutedTextColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: borderColor.withOpacity(0.72)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: borderColor.withOpacity(0.72)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(
            color: primaryColor.withOpacity(0.9),
            width: 1.2,
          ),
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
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor,
          side: BorderSide(color: borderColor.withOpacity(0.78)),
          minimumSize: const Size.fromHeight(50),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          textStyle: textTheme.labelLarge,
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
        backgroundColor: inputFillColor.withOpacity(0.86),
        selectedColor: primaryColor,
        disabledColor: inputFillColor,
        side: BorderSide(color: borderColor.withOpacity(0.76)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        labelStyle: textTheme.labelMedium,
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: mutedTextColor,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          color: primaryColor.withOpacity(
            brightness == Brightness.dark ? 0.22 : 0.12,
          ),
        ),
        dividerColor: Colors.transparent,
        labelStyle: textTheme.labelLarge,
        unselectedLabelStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryColor;
          return brightness == Brightness.dark
              ? const Color(0xFFCCE1E6)
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
