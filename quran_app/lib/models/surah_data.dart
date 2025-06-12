import 'ayah.dart';

class SurahData {
  final int number;
  final String name; // Transliterated name
  final String englishName;
  final String englishNameTranslation;
  final String revelationType; // "Meccan" or "Medinan"
  final List<Ayah> ayahs;

  SurahData({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.ayahs,
  });

  factory SurahData.fromJson(Map<String, dynamic> json,
                             List<Map<String, dynamic>> arabicAyahsJson,
                             List<Map<String, dynamic>> frenchAyahsJson,
                             List<Map<String, dynamic>> audioAyahsJson) {
    List<Ayah> ayahsList = [];
    for (int i = 0; i < arabicAyahsJson.length; i++) {
      ayahsList.add(Ayah.fromJson(arabicAyahsJson[i], frenchAyahsJson[i], audioAyahsJson[i]));
    }

    return SurahData(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      revelationType: json['revelationType'],
      ayahs: ayahsList,
    );
  }
}
