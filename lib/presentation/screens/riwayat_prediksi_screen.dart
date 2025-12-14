// File: riwayat_prediksi_screen.dart
// Deskripsi: Screen untuk menampilkan daftar riwayat prediksi.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/prediction_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../widgets/prediction_list_item.dart';

class RiwayatPrediksiScreen extends StatelessWidget {
  const RiwayatPrediksiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PredictionController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Riwayat Prediksi', style: AppTextStyles.h1),
                  const SizedBox(height: 4),
                  Text(
                    'Daftar semua hasil prediksi stunting',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.predictions.isEmpty) {
                  return _buildEmptyState();
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.predictions.length,
                      itemBuilder: (context, index) {
                        final prediction = controller.predictions[index];
                        return PredictionListItem(
                          prediction: prediction,
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.detail,
                              arguments: prediction,
                            );
                          },
                          onEdit: () {
                            controller.setEditMode(prediction);
                            Get.toNamed(AppRoutes.form);
                          },
                          onDelete: () {
                            _showDeleteDialog(context, controller, prediction.id);
                          },
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
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
      BuildContext context, PredictionController controller, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Prediksi'),
        content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deletePrediction(id);
            },
            child: Text(
              'Hapus',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
