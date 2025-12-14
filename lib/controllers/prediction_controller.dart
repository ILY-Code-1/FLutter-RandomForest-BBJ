// File: prediction_controller.dart
// Deskripsi: GetX Controller untuk mengelola state prediksi.
// Menangani CRUD operasi pada list prediksi dan form state.

import 'package:get/get.dart';
import '../data/models/prediction_model.dart';

class PredictionController extends GetxController {
  // Observable list untuk menyimpan semua prediksi
  final RxList<PredictionModel> predictions = <PredictionModel>[].obs;

  // State untuk mode edit
  final Rx<PredictionModel?> editingPrediction = Rx<PredictionModel?>(null);
  final RxBool isEditMode = false.obs;

  // Form fields - menggunakan Rx untuk reactive updates
  final RxString namaBalita = ''.obs;
  final RxString tanggalLahir = ''.obs;
  final RxString jenisKelamin = 'Laki-laki'.obs;
  final RxDouble beratBadan = 0.0.obs;
  final RxDouble tinggiBadan = 0.0.obs;
  final RxDouble lingkarLengan = 0.0.obs;
  final RxDouble lingkarKepala = 0.0.obs;

  // Statistik dashboard
  int get totalPrediksi => predictions.length;

  int get totalNormal =>
      predictions.where((p) => p.hasilPrediksi == 'Normal').length;

  int get totalStuntingRingan =>
      predictions.where((p) => p.hasilPrediksi == 'Stunting Ringan').length;

  int get totalStuntingBerat =>
      predictions.where((p) => p.hasilPrediksi == 'Stunting Berat').length;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  // Load dummy data saat pertama kali
  void _loadDummyData() {
    predictions.addAll([
      PredictionModel(
        id: '1',
        namaBalita: 'Ahmad Fauzi',
        tanggalLahir: '2022-03-15',
        jenisKelamin: 'Laki-laki',
        beratBadan: 12.5,
        tinggiBadan: 85.0,
        lingkarLengan: 14.5,
        lingkarKepala: 46.0,
        hasilPrediksi: 'Normal',
        statusGizi: 'Gizi Baik',
        tanggalPrediksi: DateTime.now().subtract(const Duration(days: 5)),
      ),
      PredictionModel(
        id: '2',
        namaBalita: 'Siti Aisyah',
        tanggalLahir: '2021-08-20',
        jenisKelamin: 'Perempuan',
        beratBadan: 10.2,
        tinggiBadan: 80.0,
        lingkarLengan: 12.5,
        lingkarKepala: 44.0,
        hasilPrediksi: 'Stunting Ringan',
        statusGizi: 'Gizi Kurang',
        tanggalPrediksi: DateTime.now().subtract(const Duration(days: 3)),
      ),
      PredictionModel(
        id: '3',
        namaBalita: 'Budi Santoso',
        tanggalLahir: '2022-01-10',
        jenisKelamin: 'Laki-laki',
        beratBadan: 8.5,
        tinggiBadan: 75.0,
        lingkarLengan: 11.0,
        lingkarKepala: 42.0,
        hasilPrediksi: 'Stunting Berat',
        statusGizi: 'Gizi Buruk',
        tanggalPrediksi: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ]);
  }

  // Tambah prediksi baru
  void addPrediction() {
    final hasil = PredictionModel.generateDummyResult(
      tinggiBadan.value,
      beratBadan.value,
    );

    final newPrediction = PredictionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      namaBalita: namaBalita.value,
      tanggalLahir: tanggalLahir.value,
      jenisKelamin: jenisKelamin.value,
      beratBadan: beratBadan.value,
      tinggiBadan: tinggiBadan.value,
      lingkarLengan: lingkarLengan.value,
      lingkarKepala: lingkarKepala.value,
      hasilPrediksi: hasil,
      statusGizi: PredictionModel.generateStatusGizi(hasil),
      tanggalPrediksi: DateTime.now(),
    );

    predictions.add(newPrediction);
    clearForm();
    Get.back();
    Get.snackbar(
      'Berhasil',
      'Data prediksi berhasil ditambahkan',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Update prediksi existing
  void updatePrediction() {
    if (editingPrediction.value == null) return;

    final hasil = PredictionModel.generateDummyResult(
      tinggiBadan.value,
      beratBadan.value,
    );

    final index = predictions.indexWhere(
      (p) => p.id == editingPrediction.value!.id,
    );

    if (index != -1) {
      predictions[index] = editingPrediction.value!.copyWith(
        namaBalita: namaBalita.value,
        tanggalLahir: tanggalLahir.value,
        jenisKelamin: jenisKelamin.value,
        beratBadan: beratBadan.value,
        tinggiBadan: tinggiBadan.value,
        lingkarLengan: lingkarLengan.value,
        lingkarKepala: lingkarKepala.value,
        hasilPrediksi: hasil,
        statusGizi: PredictionModel.generateStatusGizi(hasil),
        tanggalPrediksi: DateTime.now(),
      );
    }

    clearForm();
    Get.back();
    Get.snackbar(
      'Berhasil',
      'Data prediksi berhasil diperbarui',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Set mode edit dan isi form dengan data existing
  void setEditMode(PredictionModel prediction) {
    editingPrediction.value = prediction;
    isEditMode.value = true;
    namaBalita.value = prediction.namaBalita;
    tanggalLahir.value = prediction.tanggalLahir;
    jenisKelamin.value = prediction.jenisKelamin;
    beratBadan.value = prediction.beratBadan;
    tinggiBadan.value = prediction.tinggiBadan;
    lingkarLengan.value = prediction.lingkarLengan;
    lingkarKepala.value = prediction.lingkarKepala;
  }

  // Hapus prediksi
  void deletePrediction(String id) {
    predictions.removeWhere((p) => p.id == id);
    Get.snackbar(
      'Berhasil',
      'Data prediksi berhasil dihapus',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Clear form dan reset edit mode
  void clearForm() {
    editingPrediction.value = null;
    isEditMode.value = false;
    namaBalita.value = '';
    tanggalLahir.value = '';
    jenisKelamin.value = 'Laki-laki';
    beratBadan.value = 0.0;
    tinggiBadan.value = 0.0;
    lingkarLengan.value = 0.0;
    lingkarKepala.value = 0.0;
  }

  // Validasi form sederhana
  bool validateForm() {
    if (namaBalita.value.isEmpty) {
      Get.snackbar('Error', 'Nama balita tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (tanggalLahir.value.isEmpty) {
      Get.snackbar('Error', 'Tanggal lahir tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (beratBadan.value <= 0) {
      Get.snackbar('Error', 'Berat badan harus lebih dari 0',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (tinggiBadan.value <= 0) {
      Get.snackbar('Error', 'Tinggi badan harus lebih dari 0',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  // Submit form (add atau update)
  void submitForm() {
    if (!validateForm()) return;

    if (isEditMode.value) {
      updatePrediction();
    } else {
      addPrediction();
    }
  }
}
