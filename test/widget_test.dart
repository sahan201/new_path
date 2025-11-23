import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_path/main.dart';

void main() {
  testWidgets('App launches and shows welcome screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LoongaoApp());

    // Verify that welcome screen elements are present
    expect(find.text('WELCOME TO'), findsOneWidget);
    expect(find.text('LOONGAO'), findsOneWidget);
    expect(find.text('Search Destination'), findsOneWidget);
  });
}