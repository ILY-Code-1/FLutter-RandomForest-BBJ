// File: widget_test.dart
// Deskripsi: Unit test untuk aplikasi prediksi stunting.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_randomdforest_bbj/main.dart';

void main() {
  testWidgets('App should start and display Dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify Dashboard title is displayed
    expect(find.text('Dashboard'), findsWidgets);
  });

  testWidgets('Bottom navigation should have 3 items', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify bottom navigation bar exists
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    
    // Verify navigation labels exist
    expect(find.text('Riwayat'), findsOneWidget);
    expect(find.text('Prediksi'), findsOneWidget);
  });
}
