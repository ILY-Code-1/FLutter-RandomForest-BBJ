// File: riwayat_prediksi_screen.dart
// Deskripsi: Screen untuk menampilkan daftar riwayat prediksi.
// Setiap item berupa card hijau dengan format tanggal dan tombol aksi.

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
          if (controller.predictionSessions.isEmpty) {
            return _buildEmptyState();
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return ListView.builder(
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
                      _showDeleteDialog(context, controller, session.id);
                    },
                  );
                },
              );
            },
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
      BuildContext context, PredictionController controller, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Riwayat'),
        content: const Text('Apakah Anda yakin ingin menghapus riwayat ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteSession(id);
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
