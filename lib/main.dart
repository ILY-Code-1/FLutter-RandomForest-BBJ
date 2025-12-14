// File: main.dart
// Deskripsi: Entry point aplikasi BPR Bogor Jabar Random Forest.
// Menggunakan GetX untuk state management dan routing.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'routes/app_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BPR Bogor Jabar Random Forest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.main,
      getPages: AppPages.pages,
    );
  }
}
