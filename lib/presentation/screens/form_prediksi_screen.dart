// File: form_prediksi_screen.dart
// Screen form untuk input data prediksi nasabah

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/prediction_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_button.dart';

class FormPrediksiScreen extends StatelessWidget {
  const FormPrediksiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PredictionController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundGreen,
      appBar: const CustomAppBar(
        title: 'MULAI PREDIKSI',
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormSection(controller, constraints),
                    const SizedBox(height: 16),
                    _buildTempList(controller),
                    const SizedBox(height: 16),
                    _buildSubmitButton(controller),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildFormSection(PredictionController controller, BoxConstraints constraints) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data Nasabah',
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'ID Nasabah',
            hint: 'Masukkan ID Nasabah',
            controller: controller.idNasabahController,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Usia',
            hint: 'Masukkan usia',
            controller: controller.usiaController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 16),
          Obx(() => CustomDropdown<String>(
                label: 'Jenis Kelamin',
                value: controller.jenisKelamin.value,
                items: const ['Laki-laki', 'Perempuan'],
                itemLabel: (item) => item,
                onChanged: (value) {
                  if (value != null) {
                    controller.jenisKelamin.value = value;
                  }
                },
              )),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Pekerjaan',
            hint: 'Masukkan pekerjaan',
            controller: controller.pekerjaanController,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Pendapatan Bulanan',
            hint: 'Masukkan pendapatan bulanan',
            controller: controller.pendapatanController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            suffixIcon: IconButton(
              icon: const Icon(Icons.info_outline, color: AppColors.primary),
              onPressed: () => _showInfoDialog('Pendapatan Bulanan', 
                  'Masukkan pendapatan bulanan nasabah dalam Rupiah.'),
            ),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Frekuensi Transaksi',
            hint: 'Masukkan frekuensi transaksi per bulan',
            controller: controller.frekuensiController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            suffixIcon: IconButton(
              icon: const Icon(Icons.info_outline, color: AppColors.primary),
              onPressed: () => _showInfoDialog('Frekuensi Transaksi', 
                  'Jumlah transaksi yang dilakukan nasabah per bulan.'),
            ),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Saldo Rata-Rata',
            hint: 'Masukkan saldo rata-rata',
            controller: controller.saldoController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            suffixIcon: IconButton(
              icon: const Icon(Icons.info_outline, color: AppColors.primary),
              onPressed: () => _showInfoDialog('Saldo Rata-Rata', 
                  'Rata-rata saldo rekening nasabah dalam Rupiah.'),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Lama Menjadi Nasabah',
            hint: 'Masukkan lama menjadi nasabah (tahun)',
            controller: controller.lamaController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 16),
          Obx(() => CustomDropdown<String>(
                label: 'Status Nasabah',
                value: controller.statusNasabah.value,
                items: const ['Aktif', 'Tidak Aktif'],
                itemLabel: (item) => item,
                onChanged: (value) {
                  if (value != null) {
                    controller.statusNasabah.value = value;
                  }
                },
              )),
          const SizedBox(height: 24),
          _buildActionButtons(controller),
        ],
      ),
    );
  }

  Widget _buildActionButtons(PredictionController controller) {
    return Obx(() => Row(
          children: [
            Expanded(
              child: SmallButton(
                text: controller.isEditMode.value ? 'Update' : 'Tambah',
                backgroundColor: AppColors.secondary,
                onPressed: () {
                  if (controller.isEditMode.value) {
                    controller.updateNasabahInTemp();
                  } else {
                    controller.addNasabahToTemp();
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SmallButton(
                text: controller.isEditMode.value ? 'Cancel' : 'Clear',
                backgroundColor: AppColors.textSecondary,
                onPressed: () {
                  controller.clearForm();
                },
              ),
            ),
          ],
        ));
  }

  Widget _buildTempList(PredictionController controller) {
    return Obx(() {
      if (controller.tempNasabahList.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Nasabah (${controller.tempNasabahList.length})',
                  style: AppTextStyles.h4,
                ),
                TextButton(
                  onPressed: () => controller.clearAllTemp(),
                  child: Text(
                    'Hapus Semua',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...controller.tempNasabahList.asMap().entries.map((entry) {
              final index = entry.key;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.getTempIdNasabah(index),
                            style: AppTextStyles.labelLarge,
                          ),
                          Text(
                            controller.getTempNasabahInfo(index),
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.primary),
                      onPressed: () => controller.setEditModeFromTemp(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: AppColors.error),
                      onPressed: () => controller.removeNasabahFromTemp(index),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildSubmitButton(PredictionController controller) {
    return Obx(() => CustomButton(
          text: 'SUBMIT PREDIKSI',
          type: ButtonType.primary,
          onPressed: controller.tempNasabahList.isEmpty
              ? null
              : () => controller.submitPrediction(),
        ));
  }

  void _showInfoDialog(String title, String message) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
