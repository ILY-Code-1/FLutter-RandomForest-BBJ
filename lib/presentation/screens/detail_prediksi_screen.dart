// File: detail_prediksi_screen.dart
// Deskripsi: Screen untuk menampilkan detail lengkap hasil prediksi.
// Menampilkan statistik di header dan list card nasabah.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                    // Header Stats Card
                    DetailHeaderCard(
                      jumlahData: session.jumlahData,
                      akurasi: session.akurasi,
                    ),
                    const SizedBox(height: 16),
                    // Title
                    Text(
                      'Detail Nasabah',
                      style: AppTextStyles.h3,
                    ),
                    const SizedBox(height: 12),
                    // List of Nasabah Cards
                    ...session.nasabahList.map((nasabah) => 
                      NasabahDetailCard(nasabah: nasabah)
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
