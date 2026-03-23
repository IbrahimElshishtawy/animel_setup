// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppPalette {
  static const Color ink = Color(0xFF09141A);
  static const Color plum = Color.fromARGB(255, 126, 69, 42);
  static const Color plumDeep = Color.fromARGB(255, 70, 35, 19);
  static const Color magenta = Color.fromARGB(255, 94, 66, 52);
  static const Color sunset = Color.fromARGB(255, 246, 146, 39);
  static const Color blush = Color(0xFFF1F7F8);
  static const Color shell = Color(0xFFF4F8FA);
  static const Color surface = Color(0xFFFDFEFE);
  static const Color border = Color(0xFFD5E2E7);
  static const Color muted = Color(0xFF6B8087);
  static const Color text = Color(0xFF173039);
  static const Color indigo = Color(0xFF708B96);
  static const Color darkSurface = Color(0xFF14222C);
  static const Color darkBorder = Color(0xFF2A414C);
  static const Color darkMuted = Color(0xFF9CB0B8);
  static const Color darkText = Color(0xFFE8F2F4);

  static const List<Color> brandGradient = [plumDeep, plum, sunset];
}

class AppSpacing {
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 28;
  static const double xxl = 36;
  static const double xxxl = 48;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );
}

class AppRadius {
  static const double sm = 16;
  static const double md = 22;
  static const double lg = 30;
  static const double xl = 36;
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
        blurRadius: 32,
        offset: const Offset(0, 18),
      ),
    ];
  }

  static List<BoxShadow> layered(Color color, {double opacity = 0.12}) {
    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        blurRadius: 42,
        offset: const Offset(0, 24),
      ),
      BoxShadow(
        color: Colors.white.withOpacity(0.08),
        blurRadius: 12,
        offset: const Offset(0, -6),
      ),
    ];
  }
}
