// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

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
