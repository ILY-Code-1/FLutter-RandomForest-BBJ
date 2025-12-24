// File: detail_prediksi_screen.dart
// Screen untuk menampilkan detail lengkap hasil prediksi dengan fitur download

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../controllers/prediction_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/stat_card.dart';
import '../widgets/nasabah_detail_card.dart';

class DetailPrediksiScreen extends StatelessWidget {
  const DetailPrediksiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PredictionController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'DETAIL PREDIKSI',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Obx(() {
          final session = controller.currentSession.value;

          if (session == null) {
            return const Center(
              child: Text('Data tidak ditemukan'),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailHeaderCard(
                      jumlahData: session.jumlahData,
                      akurasi: session.akurasi,
                    ),
                    const SizedBox(height: 12),
                    _buildDownloadButton(context, session),
                    const SizedBox(height: 16),
                    Text(
                      'Detail Nasabah',
                      style: AppTextStyles.h3,
                    ),
                    const SizedBox(height: 12),
                    ...session.nasabahList.map((nasabah) =>
                        NasabahDetailCard(nasabah: nasabah)),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context, dynamic session) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _downloadReport(context, session),
        icon: const Icon(Icons.download, color: Colors.white),
        label: const Text(
          'Download Laporan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Future<void> _downloadReport(BuildContext context, dynamic session) async {
    try {
      final content = session.toDetailString();
      final directory = await getApplicationDocumentsDirectory();
      final fileName = '${session.flag.replaceAll(':', '-')}.txt';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(content);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Laporan Prediksi Random Forest - ${session.flag}',
      );

      Get.snackbar(
        'Berhasil',
        'Laporan siap dibagikan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal membuat laporan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
