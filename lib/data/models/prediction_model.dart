// File: prediction_model.dart
// Deskripsi: Model data untuk prediksi nasabah BPR Bogor Jabar.
// Menyimpan data nasabah dan hasil prediksi Random Forest (dummy).

class NasabahModel {
  final String id;
  final String idNasabah;
  final int usia;
  final String jenisKelamin;
  final String pekerjaan;
  final double pendapatanBulanan;
  final int frekuensiTransaksi;
  final double saldoRataRata;
  final int lamaMenjadiNasabah;
  final String statusNasabah;
  final String prediksiAwal;
  final List<String> prediksiPohon;
  final String finalPrediksi;
  final String evaluasi;

  NasabahModel({
    required this.id,
    required this.idNasabah,
    required this.usia,
    required this.jenisKelamin,
    required this.pekerjaan,
    required this.pendapatanBulanan,
    required this.frekuensiTransaksi,
    required this.saldoRataRata,
    required this.lamaMenjadiNasabah,
    required this.statusNasabah,
    required this.prediksiAwal,
    required this.prediksiPohon,
    required this.finalPrediksi,
    required this.evaluasi,
  });

  NasabahModel copyWith({
    String? id,
    String? idNasabah,
    int? usia,
    String? jenisKelamin,
    String? pekerjaan,
    double? pendapatanBulanan,
    int? frekuensiTransaksi,
    double? saldoRataRata,
    int? lamaMenjadiNasabah,
    String? statusNasabah,
    String? prediksiAwal,
    List<String>? prediksiPohon,
    String? finalPrediksi,
    String? evaluasi,
  }) {
    return NasabahModel(
      id: id ?? this.id,
      idNasabah: idNasabah ?? this.idNasabah,
      usia: usia ?? this.usia,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      pekerjaan: pekerjaan ?? this.pekerjaan,
      pendapatanBulanan: pendapatanBulanan ?? this.pendapatanBulanan,
      frekuensiTransaksi: frekuensiTransaksi ?? this.frekuensiTransaksi,
      saldoRataRata: saldoRataRata ?? this.saldoRataRata,
      lamaMenjadiNasabah: lamaMenjadiNasabah ?? this.lamaMenjadiNasabah,
      statusNasabah: statusNasabah ?? this.statusNasabah,
      prediksiAwal: prediksiAwal ?? this.prediksiAwal,
      prediksiPohon: prediksiPohon ?? this.prediksiPohon,
      finalPrediksi: finalPrediksi ?? this.finalPrediksi,
      evaluasi: evaluasi ?? this.evaluasi,
    );
  }

  // Generate dummy prediction result
  static String generateDummyPrediksi(String statusNasabah) {
    return statusNasabah == 'Aktif' ? 'Aktif' : 'Tidak Aktif';
  }

  // Generate dummy tree predictions
  static List<String> generateDummyPohonPrediksi() {
    return ['Aktif', 'Tidak Aktif', 'Aktif'];
  }
}

// Model untuk menyimpan satu session prediksi (bisa berisi banyak nasabah)
class PredictionSessionModel {
  final String id;
  final DateTime tanggalPrediksi;
  final List<NasabahModel> nasabahList;
  final double akurasi;

  PredictionSessionModel({
    required this.id,
    required this.tanggalPrediksi,
    required this.nasabahList,
    required this.akurasi,
  });

  String get formattedDate {
    final d = tanggalPrediksi;
    return 'PREDICT_${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}_${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}:${d.second.toString().padLeft(2, '0')}';
  }

  int get jumlahData => nasabahList.length;

  int get nasabahAktif => nasabahList.where((n) => n.finalPrediksi == 'Aktif').length;

  int get nasabahTidakAktif => nasabahList.where((n) => n.finalPrediksi == 'Tidak Aktif').length;
}
