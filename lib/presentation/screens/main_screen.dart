// File: main_screen.dart
// Deskripsi: Screen utama dengan bottom navigation bar.
// Mengelola navigasi antar tab (Dashboard, Riwayat, Form).

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/navigation_controller.dart';
import '../../controllers/prediction_controller.dart';
import '../../core/theme/app_colors.dart';
import 'dashboard_screen.dart';
import 'riwayat_prediksi_screen.dart';
import 'form_prediksi_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.find<NavigationController>();
    final predictionController = Get.find<PredictionController>();

    final List<Widget> screens = [
      const DashboardScreen(),
      const RiwayatPrediksiScreen(),
      const FormPrediksiScreen(),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: navigationController.currentIndex.value,
            children: screens,
          )),
      bottomNavigationBar: Obx(() => Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: navigationController.currentIndex.value,
              onTap: (index) {
                if (index == 2) {
                  predictionController.clearForm();
                }
                navigationController.changePage(index);
              },
              backgroundColor: Colors.white,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textSecondary,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_outlined),
                  activeIcon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history_outlined),
                  activeIcon: Icon(Icons.history),
                  label: 'Riwayat',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline),
                  activeIcon: Icon(Icons.add_circle),
                  label: 'Prediksi',
                ),
              ],
            ),
          )),
    );
  }
}
