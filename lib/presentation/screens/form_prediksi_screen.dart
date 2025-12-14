// File: form_prediksi_screen.dart
// Deskripsi: Screen form untuk input data prediksi baru atau edit data existing.
// Form 1 dan Form 2 digabung dalam satu screen dengan scroll.

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

class FormPrediksiScreen extends StatefulWidget {
  const FormPrediksiScreen({super.key});

  @override
  State<FormPrediksiScreen> createState() => _FormPrediksiScreenState();
}

class _FormPrediksiScreenState extends State<FormPrediksiScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<PredictionController>();

  // Text editing controllers
  late TextEditingController _namaController;
  late TextEditingController _tanggalLahirController;
  late TextEditingController _beratController;
  late TextEditingController _tinggiController;
  late TextEditingController _lingkarLenganController;
  late TextEditingController _lingkarKepalaController;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _namaController = TextEditingController(text: controller.namaBalita.value);
    _tanggalLahirController = TextEditingController(text: controller.tanggalLahir.value);
    _beratController = TextEditingController(
      text: controller.beratBadan.value > 0 ? controller.beratBadan.value.toString() : '',
    );
    _tinggiController = TextEditingController(
      text: controller.tinggiBadan.value > 0 ? controller.tinggiBadan.value.toString() : '',
    );
    _lingkarLenganController = TextEditingController(
      text: controller.lingkarLengan.value > 0 ? controller.lingkarLengan.value.toString() : '',
    );
    _lingkarKepalaController = TextEditingController(
      text: controller.lingkarKepala.value > 0 ? controller.lingkarKepala.value.toString() : '',
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _tanggalLahirController.dispose();
    _beratController.dispose();
    _tinggiController.dispose();
    _lingkarLenganController.dispose();
    _lingkarKepalaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: controller.isEditMode.value ? 'Edit Prediksi' : 'Form Prediksi',
        showBackButton: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Data Balita', Icons.person_outline),
                    const SizedBox(height: 16),
                    _buildDataBalitaSection(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Data Antropometri', Icons.straighten),
                    const SizedBox(height: 16),
                    _buildAntropometriSection(constraints),
                    const SizedBox(height: 32),
                    _buildSubmitButton(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(title, style: AppTextStyles.h3),
      ],
    );
  }

  Widget _buildDataBalitaSection() {
    return Container(
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
      child: Column(
        children: [
          CustomTextField(
            label: 'Nama Balita',
            hint: 'Masukkan nama balita',
            controller: _namaController,
            onChanged: (value) => controller.namaBalita.value = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nama balita tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Tanggal Lahir',
            hint: 'YYYY-MM-DD',
            controller: _tanggalLahirController,
            readOnly: true,
            suffixIcon: const Icon(Icons.calendar_today_outlined),
            onTap: () => _selectDate(context),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tanggal lahir tidak boleh kosong';
              }
              return null;
            },
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
        ],
      ),
    );
  }

  Widget _buildAntropometriSection(BoxConstraints constraints) {
    final isWide = constraints.maxWidth > 400;

    return Container(
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
      child: Column(
        children: [
          if (isWide)
            Row(
              children: [
                Expanded(
                  child: _buildNumericField(
                    label: 'Berat Badan (kg)',
                    hint: 'Contoh: 12.5',
                    controller: _beratController,
                    onChanged: (value) {
                      controller.beratBadan.value = double.tryParse(value) ?? 0.0;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildNumericField(
                    label: 'Tinggi Badan (cm)',
                    hint: 'Contoh: 85.0',
                    controller: _tinggiController,
                    onChanged: (value) {
                      controller.tinggiBadan.value = double.tryParse(value) ?? 0.0;
                    },
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildNumericField(
                  label: 'Berat Badan (kg)',
                  hint: 'Contoh: 12.5',
                  controller: _beratController,
                  onChanged: (value) {
                    controller.beratBadan.value = double.tryParse(value) ?? 0.0;
                  },
                ),
                const SizedBox(height: 16),
                _buildNumericField(
                  label: 'Tinggi Badan (cm)',
                  hint: 'Contoh: 85.0',
                  controller: _tinggiController,
                  onChanged: (value) {
                    controller.tinggiBadan.value = double.tryParse(value) ?? 0.0;
                  },
                ),
              ],
            ),
          const SizedBox(height: 16),
          if (isWide)
            Row(
              children: [
                Expanded(
                  child: _buildNumericField(
                    label: 'Lingkar Lengan (cm)',
                    hint: 'Contoh: 14.5',
                    controller: _lingkarLenganController,
                    onChanged: (value) {
                      controller.lingkarLengan.value = double.tryParse(value) ?? 0.0;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildNumericField(
                    label: 'Lingkar Kepala (cm)',
                    hint: 'Contoh: 46.0',
                    controller: _lingkarKepalaController,
                    onChanged: (value) {
                      controller.lingkarKepala.value = double.tryParse(value) ?? 0.0;
                    },
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildNumericField(
                  label: 'Lingkar Lengan (cm)',
                  hint: 'Contoh: 14.5',
                  controller: _lingkarLenganController,
                  onChanged: (value) {
                    controller.lingkarLengan.value = double.tryParse(value) ?? 0.0;
                  },
                ),
                const SizedBox(height: 16),
                _buildNumericField(
                  label: 'Lingkar Kepala (cm)',
                  hint: 'Contoh: 46.0',
                  controller: _lingkarKepalaController,
                  onChanged: (value) {
                    controller.lingkarKepala.value = double.tryParse(value) ?? 0.0;
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildNumericField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) {
    return CustomTextField(
      label: label,
      hint: hint,
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Field ini tidak boleh kosong';
        }
        final num = double.tryParse(value);
        if (num == null || num <= 0) {
          return 'Masukkan angka yang valid';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => CustomButton(
          text: controller.isEditMode.value ? 'Update Data' : 'Simpan & Prediksi',
          icon: controller.isEditMode.value ? Icons.save : Icons.analytics,
          onPressed: _onSubmit,
        ));
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      controller.submitForm();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365)),
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formattedDate =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      _tanggalLahirController.text = formattedDate;
      controller.tanggalLahir.value = formattedDate;
    }
  }
}
