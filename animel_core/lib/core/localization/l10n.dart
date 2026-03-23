import 'package:flutter/material.dart';

class L10n {
  static final all = [const Locale('en'), const Locale('ar')];

  static String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'ar':
        return '\u0627\u0644\u0639\u0631\u0628\u064a\u0629';
      default:
        return 'English';
    }
  }
}
