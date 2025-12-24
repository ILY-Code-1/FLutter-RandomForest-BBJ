// File: riwayat_prediksi_screen.dart
// Screen untuk menampilkan daftar riwayat prediksi dari SQLite

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/prediction_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/riwayat_list_item.dart';

class RiwayatPrediksiScreen extends StatelessWidget {
  const RiwayatPrediksiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PredictionController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'RIWAYAT PREDIKSI',
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (controller.predictionSessions.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => controller.loadSessions(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.predictionSessions.length,
              itemBuilder: (context, index) {
                final session = controller.predictionSessions[index];
                return RiwayatListItem(
                  session: session,
                  onView: () {
                    controller.setCurrentSession(session);
                    Get.toNamed(AppRoutes.detail);
                  },
                  onDelete: () {
                    _showDeleteDialog(context, controller, session.id, session.flag);
                  },
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Riwayat',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mulai tambah prediksi baru',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, PredictionController controller, String id, String flag) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 28),
            const SizedBox(width: 8),
            const Text('Hapus Riwayat'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Apakah Anda yakin ingin menghapus riwayat prediksi ini?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                flag,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Data yang dihapus tidak dapat dikembalikan.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.error,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteSession(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
