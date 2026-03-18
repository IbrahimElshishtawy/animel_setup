import 'package:animel_core/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App starts and shows splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AnimalConnectApp());

    expect(find.text('Animal Connect'), findsAtLeast(1));

    // Allow timers to finish
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
