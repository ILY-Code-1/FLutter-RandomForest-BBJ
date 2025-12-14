// File: dashboard_screen.dart
// Deskripsi: Screen dashboard utama yang menampilkan statistik prediksi.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/prediction_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PredictionController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildStatisticsGrid(controller, constraints),
                  const SizedBox(height: 24),
                  _buildRecentPredictions(controller),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard',
          style: AppTextStyles.h1,
        ),
        const SizedBox(height: 4),
        Text(
          'Selamat datang di Sistem Prediksi Stunting',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsGrid(
      PredictionController controller, BoxConstraints constraints) {
    return Obx(() {
      final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
      final childAspectRatio = constraints.maxWidth > 600 ? 1.2 : 1.1;

      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: childAspectRatio,
        children: [
          StatCard(
            title: 'Total Prediksi',
            value: controller.totalPrediksi.toString(),
            icon: Icons.analytics_outlined,
            color: AppColors.chartBlue,
          ),
          StatCard(
            title: 'Normal',
            value: controller.totalNormal.toString(),
            icon: Icons.check_circle_outline,
            color: AppColors.success,
          ),
          StatCard(
            title: 'Stunting Ringan',
            value: controller.totalStuntingRingan.toString(),
            icon: Icons.warning_amber_outlined,
            color: AppColors.warning,
          ),
          StatCard(
            title: 'Stunting Berat',
            value: controller.totalStuntingBerat.toString(),
            icon: Icons.error_outline,
            color: AppColors.error,
          ),
        ],
      );
    });
  }

  Widget _buildRecentPredictions(PredictionController controller) {
    return Obx(() {
      final recentPredictions = controller.predictions.take(3).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Prediksi Terbaru', style: AppTextStyles.h3),
              TextButton(
                onPressed: () {
                  Get.find<NavigationController>().changePage(1);
                },
                child: Text(
                  'Lihat Semua',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (recentPredictions.isEmpty)
            _buildEmptyState()
          else
            ...recentPredictions.map((prediction) => _buildRecentItem(prediction)),
        ],
      );
    });
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 12),
            Text(
              'Belum ada data prediksi',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentItem(prediction) {
    Color statusColor;
    switch (prediction.hasilPrediksi) {
      case 'Normal':
        statusColor = AppColors.success;
        break;
      case 'Stunting Ringan':
        statusColor = AppColors.warning;
        break;
      case 'Stunting Berat':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = AppColors.textSecondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.person_outline,
              color: statusColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prediction.namaBalita,
                  style: AppTextStyles.labelLarge,
                ),
                Text(
                  prediction.hasilPrediksi,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}


