// File: prediction_controller.dart
// Deskripsi: GetX Controller untuk mengelola state prediksi nasabah.
// Menangani CRUD operasi pada list prediksi dan form state.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/prediction_model.dart';

class PredictionController extends GetxController {
  // Observable list untuk menyimpan semua session prediksi
  final RxList<PredictionSessionModel> predictionSessions = <PredictionSessionModel>[].obs;

  // Temporary list untuk nasabah yang akan di-submit
  final RxList<NasabahModel> tempNasabahList = <NasabahModel>[].obs;

  // State untuk mode edit
  final Rx<NasabahModel?> editingNasabah = Rx<NasabahModel?>(null);
  final RxBool isEditMode = false.obs;
  final RxInt editingIndex = (-1).obs;

  // Form controllers
  final idNasabahController = TextEditingController();
  final usiaController = TextEditingController();
  final pekerjaanController = TextEditingController();
  final pendapatanController = TextEditingController();
  final frekuensiController = TextEditingController();
  final saldoController = TextEditingController();
  final lamaController = TextEditingController();

  // Form fields - menggunakan Rx untuk reactive updates
  final RxString jenisKelamin = 'Laki-laki'.obs;
  final RxString statusNasabah = 'Aktif'.obs;

  // Current session being viewed
  final Rx<PredictionSessionModel?> currentSession = Rx<PredictionSessionModel?>(null);

  // Statistik dashboard
  int get totalSessions => predictionSessions.length;

  int get totalNasabahAktif {
    int count = 0;
    for (var session in predictionSessions) {
      count += session.nasabahAktif;
    }
    return count;
  }

  int get totalNasabahTidakAktif {
    int count = 0;
    for (var session in predictionSessions) {
      count += session.nasabahTidakAktif;
    }
    return count;
  }

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  @override
  void onClose() {
    idNasabahController.dispose();
    usiaController.dispose();
    pekerjaanController.dispose();
    pendapatanController.dispose();
    frekuensiController.dispose();
    saldoController.dispose();
    lamaController.dispose();
    super.onClose();
  }

  // Load dummy data saat pertama kali
  void _loadDummyData() {
    final dummyNasabah1 = NasabahModel(
      id: '1',
      idNasabah: 'NSB001',
      usia: 35,
      jenisKelamin: 'Laki-laki',
      pekerjaan: 'Wiraswasta',
      pendapatanBulanan: 8000000,
      frekuensiTransaksi: 15,
      saldoRataRata: 5000000,
      lamaMenjadiNasabah: 3,
      statusNasabah: 'Aktif',
      prediksiAwal: 'Aktif',
      prediksiPohon: ['Aktif', 'Aktif', 'Tidak Aktif'],
      finalPrediksi: 'Aktif',
      evaluasi: 'Benar',
    );

    final dummyNasabah2 = NasabahModel(
      id: '2',
      idNasabah: 'NSB002',
      usia: 28,
      jenisKelamin: 'Perempuan',
      pekerjaan: 'Karyawan Swasta',
      pendapatanBulanan: 5000000,
      frekuensiTransaksi: 5,
      saldoRataRata: 2000000,
      lamaMenjadiNasabah: 1,
      statusNasabah: 'Tidak Aktif',
      prediksiAwal: 'Tidak Aktif',
      prediksiPohon: ['Tidak Aktif', 'Aktif', 'Tidak Aktif'],
      finalPrediksi: 'Tidak Aktif',
      evaluasi: 'Benar',
    );

    final dummyNasabah3 = NasabahModel(
      id: '3',
      idNasabah: 'NSB003',
      usia: 45,
      jenisKelamin: 'Laki-laki',
      pekerjaan: 'PNS',
      pendapatanBulanan: 10000000,
      frekuensiTransaksi: 20,
      saldoRataRata: 15000000,
      lamaMenjadiNasabah: 5,
      statusNasabah: 'Aktif',
      prediksiAwal: 'Aktif',
      prediksiPohon: ['Aktif', 'Aktif', 'Aktif'],
      finalPrediksi: 'Aktif',
      evaluasi: 'Benar',
    );

    predictionSessions.add(PredictionSessionModel(
      id: '1',
      tanggalPrediksi: DateTime.now().subtract(const Duration(days: 1)),
      nasabahList: [dummyNasabah1, dummyNasabah2, dummyNasabah3],
      akurasi: 66.67,
    ));

    predictionSessions.add(PredictionSessionModel(
      id: '2',
      tanggalPrediksi: DateTime.now().subtract(const Duration(hours: 5)),
      nasabahList: [dummyNasabah1, dummyNasabah2],
      akurasi: 50.0,
    ));
  }

  // Tambah nasabah ke temporary list
  void addNasabahToTemp() {
    if (!validateForm()) return;

    final newNasabah = _createNasabahFromForm();
    tempNasabahList.add(newNasabah);
    clearForm();
    
    Get.snackbar(
      'Berhasil',
      'Nasabah berhasil ditambahkan ke daftar',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Update nasabah di temporary list
  void updateNasabahInTemp() {
    if (!validateForm()) return;
    if (editingIndex.value < 0) return;

    final updatedNasabah = _createNasabahFromForm();
    tempNasabahList[editingIndex.value] = updatedNasabah;
    
    clearForm();
    isEditMode.value = false;
    editingIndex.value = -1;
    
    Get.snackbar(
      'Berhasil',
      'Data nasabah berhasil diperbarui',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Create NasabahModel from form
  NasabahModel _createNasabahFromForm() {
    final status = statusNasabah.value;
    final prediksiPohon = NasabahModel.generateDummyPohonPrediksi();
    final finalPred = NasabahModel.generateDummyPrediksi(status);
    
    return NasabahModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      idNasabah: idNasabahController.text,
      usia: int.tryParse(usiaController.text) ?? 0,
      jenisKelamin: jenisKelamin.value,
      pekerjaan: pekerjaanController.text,
      pendapatanBulanan: double.tryParse(pendapatanController.text) ?? 0,
      frekuensiTransaksi: int.tryParse(frekuensiController.text) ?? 0,
      saldoRataRata: double.tryParse(saldoController.text) ?? 0,
      lamaMenjadiNasabah: int.tryParse(lamaController.text) ?? 0,
      statusNasabah: status,
      prediksiAwal: status == 'Aktif' ? 'Aktif' : 'Tidak Aktif',
      prediksiPohon: prediksiPohon,
      finalPrediksi: finalPred,
      evaluasi: finalPred == status ? 'Benar' : 'Salah',
    );
  }

  // Set mode edit dengan data nasabah dari temp list
  void setEditModeFromTemp(int index) {
    if (index < 0 || index >= tempNasabahList.length) return;
    
    final nasabah = tempNasabahList[index];
    editingIndex.value = index;
    isEditMode.value = true;
    
    idNasabahController.text = nasabah.idNasabah;
    usiaController.text = nasabah.usia.toString();
    jenisKelamin.value = nasabah.jenisKelamin;
    pekerjaanController.text = nasabah.pekerjaan;
    pendapatanController.text = nasabah.pendapatanBulanan.toStringAsFixed(0);
    frekuensiController.text = nasabah.frekuensiTransaksi.toString();
    saldoController.text = nasabah.saldoRataRata.toStringAsFixed(0);
    lamaController.text = nasabah.lamaMenjadiNasabah.toString();
    statusNasabah.value = nasabah.statusNasabah;
  }

  // Submit semua data dan buat session baru
  void submitPrediction() {
    if (tempNasabahList.isEmpty) {
      Get.snackbar(
        'Error',
        'Tambahkan minimal 1 data nasabah terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Calculate dummy accuracy
    int benar = tempNasabahList.where((n) => n.evaluasi == 'Benar').length;
    double akurasi = (benar / tempNasabahList.length) * 100;

    final newSession = PredictionSessionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tanggalPrediksi: DateTime.now(),
      nasabahList: List.from(tempNasabahList),
      akurasi: akurasi,
    );

    predictionSessions.insert(0, newSession);
    tempNasabahList.clear();
    clearForm();

    Get.snackbar(
      'Berhasil',
      'Data prediksi berhasil disimpan',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Hapus session prediksi
  void deleteSession(String id) {
    predictionSessions.removeWhere((s) => s.id == id);
    Get.snackbar(
      'Berhasil',
      'Riwayat prediksi berhasil dihapus',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Set current session untuk detail view
  void setCurrentSession(PredictionSessionModel session) {
    currentSession.value = session;
  }

  // Clear form
  void clearForm() {
    idNasabahController.clear();
    usiaController.clear();
    pekerjaanController.clear();
    pendapatanController.clear();
    frekuensiController.clear();
    saldoController.clear();
    lamaController.clear();
    jenisKelamin.value = 'Laki-laki';
    statusNasabah.value = 'Aktif';
    isEditMode.value = false;
    editingIndex.value = -1;
    editingNasabah.value = null;
  }

  // Clear all temp data
  void clearAllTemp() {
    tempNasabahList.clear();
    clearForm();
  }

  // Validasi form
  bool validateForm() {
    if (idNasabahController.text.isEmpty) {
      Get.snackbar('Error', 'ID Nasabah tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return false;
    }
    if (usiaController.text.isEmpty) {
      Get.snackbar('Error', 'Usia tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return false;
    }
    if (pekerjaanController.text.isEmpty) {
      Get.snackbar('Error', 'Pekerjaan tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return false;
    }
    if (pendapatanController.text.isEmpty) {
      Get.snackbar('Error', 'Pendapatan bulanan tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return false;
    }
    if (frekuensiController.text.isEmpty) {
      Get.snackbar('Error', 'Frekuensi transaksi tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return false;
    }
    if (saldoController.text.isEmpty) {
      Get.snackbar('Error', 'Saldo rata-rata tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return false;
    }
    if (lamaController.text.isEmpty) {
      Get.snackbar('Error', 'Lama menjadi nasabah tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return false;
    }
    return true;
  }

  // Remove nasabah from temp list
  void removeNasabahFromTemp(int index) {
    if (index >= 0 && index < tempNasabahList.length) {
      tempNasabahList.removeAt(index);
    }
  }
}
