// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppPalette {
  static const Color ink = Color(0xFF191823);
  static const Color plum = Color(0xFF4B1A45);
  static const Color plumDeep = Color(0xFF2A1E3F);
  static const Color magenta = Color(0xFF8B2E6F);
  static const Color sunset = Color(0xFFE59A5A);
  static const Color blush = Color(0xFFF6ECF3);
  static const Color shell = Color(0xFFF7F2F7);
  static const Color surface = Color(0xFFFFFBFD);
  static const Color border = Color(0xFFE3D5E6);
  static const Color muted = Color(0xFF7E6A80);
  static const Color text = Color(0xFF2A2030);
  static const Color indigo = Color(0xFF4C5D97);
  static const Color darkSurface = Color(0xFF211C2B);
  static const Color darkBorder = Color(0xFF342A3B);
  static const Color darkMuted = Color(0xFFA99AAE);
  static const Color darkText = Color(0xFFF8F2FA);

  static const List<Color> brandGradient = [plumDeep, magenta, sunset];
}

class AppSpacing {
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 28;
  static const double xxl = 36;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );
}

class AppRadius {
  static const double sm = 16;
  static const double md = 22;
  static const double lg = 30;
  static const double pill = 999;
}

class AppMotion {
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration medium = Duration(milliseconds: 260);
  static const Duration slow = Duration(milliseconds: 420);
  static const Curve emphasized = Curves.easeOutCubic;
}

class AppShadows {
  static List<BoxShadow> soft(Color color, {double opacity = 0.08}) {
    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        blurRadius: 28,
        offset: const Offset(0, 16),
      ),
    ];
  }
}
