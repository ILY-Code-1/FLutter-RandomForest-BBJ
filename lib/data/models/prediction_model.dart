// File: prediction_model.dart
// Deskripsi: Model data untuk prediksi Random Forest (dummy data).

class PredictionModel {
  final String id;
  final String namaBalita;
  final String tanggalLahir;
  final String jenisKelamin;
  final double beratBadan; // kg
  final double tinggiBadan; // cm
  final double lingkarLengan; // cm
  final double lingkarKepala; // cm
  final String hasilPrediksi; // Normal, Stunting Ringan, Stunting Berat
  final String statusGizi;
  final DateTime tanggalPrediksi;

  PredictionModel({
    required this.id,
    required this.namaBalita,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.beratBadan,
    required this.tinggiBadan,
    required this.lingkarLengan,
    required this.lingkarKepala,
    required this.hasilPrediksi,
    required this.statusGizi,
    required this.tanggalPrediksi,
  });

  PredictionModel copyWith({
    String? id,
    String? namaBalita,
    String? tanggalLahir,
    String? jenisKelamin,
    double? beratBadan,
    double? tinggiBadan,
    double? lingkarLengan,
    double? lingkarKepala,
    String? hasilPrediksi,
    String? statusGizi,
    DateTime? tanggalPrediksi,
  }) {
    return PredictionModel(
      id: id ?? this.id,
      namaBalita: namaBalita ?? this.namaBalita,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      beratBadan: beratBadan ?? this.beratBadan,
      tinggiBadan: tinggiBadan ?? this.tinggiBadan,
      lingkarLengan: lingkarLengan ?? this.lingkarLengan,
      lingkarKepala: lingkarKepala ?? this.lingkarKepala,
      hasilPrediksi: hasilPrediksi ?? this.hasilPrediksi,
      statusGizi: statusGizi ?? this.statusGizi,
      tanggalPrediksi: tanggalPrediksi ?? this.tanggalPrediksi,
    );
  }

  // Generate dummy result based on input (simulating Random Forest)
  static String generateDummyResult(double tinggi, double berat) {
    final bmi = berat / ((tinggi / 100) * (tinggi / 100));
    if (bmi < 14) return 'Stunting Berat';
    if (bmi < 16) return 'Stunting Ringan';
    return 'Normal';
  }

  static String generateStatusGizi(String hasil) {
    switch (hasil) {
      case 'Normal':
        return 'Gizi Baik';
      case 'Stunting Ringan':
        return 'Gizi Kurang';
      case 'Stunting Berat':
        return 'Gizi Buruk';
      default:
        return 'Tidak Diketahui';
    }
  }
}
