// File: widget_test.dart
// Deskripsi: Unit test untuk aplikasi BPR Bogor Jabar Random Forest.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_randomdforest_bbj/main.dart';

void main() {
  testWidgets('App should start and display Home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify AppBar title is displayed
    expect(find.text('BPR BOGOR JABAR RANDOM FOREST APP'), findsOneWidget);
  });

  testWidgets('Bottom navigation should have 3 items', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify navigation labels exist
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Riwayat'), findsOneWidget);
    
    // Verify add button icon exists
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Dashboard should display Random Forest info card', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify Random Forest card is displayed
    expect(find.text('APA ITU RANDOM FOREST?'), findsOneWidget);
    expect(find.text('Hasil Prediksi'), findsOneWidget);
    expect(find.text('Cara Kerja Random Forest'), findsOneWidget);
  });
}
