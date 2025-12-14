// File: detail_prediksi_screen.dart
// Deskripsi: Screen untuk menampilkan detail lengkap hasil prediksi.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/prediction_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/prediction_model.dart';
import '../../routes/app_routes.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/detail_info_card.dart';
import '../widgets/custom_button.dart';

class DetailPrediksiScreen extends StatelessWidget {
  const DetailPrediksiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PredictionModel prediction = Get.arguments as PredictionModel;
    final controller = Get.find<PredictionController>();
    final dateFormat = DateFormat('dd MMMM yyyy', 'id');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Detail Prediksi',
        showBackButton: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildResultCard(prediction),
                  const SizedBox(height: 16),
                  DetailInfoCard(
                    title: 'Data Balita',
                    items: [
                      DetailInfoItem(
                        icon: Icons.person_outline,
                        label: 'Nama Balita',
                        value: prediction.namaBalita,
                      ),
                      DetailInfoItem(
                        icon: Icons.cake_outlined,
                        label: 'Tanggal Lahir',
                        value: prediction.tanggalLahir,
                      ),
                      DetailInfoItem(
                        icon: Icons.wc_outlined,
                        label: 'Jenis Kelamin',
                        value: prediction.jenisKelamin,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DetailInfoCard(
                    title: 'Data Antropometri',
                    items: [
                      DetailInfoItem(
                        icon: Icons.monitor_weight_outlined,
                        label: 'Berat Badan',
                        value: '${prediction.beratBadan} kg',
                      ),
                      DetailInfoItem(
                        icon: Icons.height,
                        label: 'Tinggi Badan',
                        value: '${prediction.tinggiBadan} cm',
                      ),
                      DetailInfoItem(
                        icon: Icons.circle_outlined,
                        label: 'Lingkar Lengan',
                        value: '${prediction.lingkarLengan} cm',
                      ),
                      DetailInfoItem(
                        icon: Icons.face_outlined,
                        label: 'Lingkar Kepala',
                        value: '${prediction.lingkarKepala} cm',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DetailInfoCard(
                    title: 'Informasi Prediksi',
                    items: [
                      DetailInfoItem(
                        icon: Icons.calendar_today_outlined,
                        label: 'Tanggal Prediksi',
                        value: dateFormat.format(prediction.tanggalPrediksi),
                      ),
                      DetailInfoItem(
                        icon: Icons.restaurant_outlined,
                        label: 'Status Gizi',
                        value: prediction.statusGizi,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Edit Data',
                          type: ButtonType.outline,
                          icon: Icons.edit_outlined,
                          onPressed: () {
                            controller.setEditMode(prediction);
                            Get.offNamed(AppRoutes.form);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          text: 'Hapus',
                          type: ButtonType.primary,
                          icon: Icons.delete_outline,
                          onPressed: () {
                            _showDeleteDialog(context, controller, prediction.id);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildResultCard(PredictionModel prediction) {
    Color statusColor;
    IconData statusIcon;
    
    switch (prediction.hasilPrediksi) {
      case 'Normal':
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle;
        break;
      case 'Stunting Ringan':
        statusColor = AppColors.warning;
        statusIcon = Icons.warning;
        break;
      case 'Stunting Berat':
        statusColor = AppColors.error;
        statusIcon = Icons.error;
        break;
      default:
        statusColor = AppColors.textSecondary;
        statusIcon = Icons.help_outline;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor,
            statusColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            statusIcon,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          Text(
            'Hasil Prediksi',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            prediction.hasilPrediksi,
            style: AppTextStyles.h2.copyWith(
              color: Colors.white,
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
              Get.back();
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
