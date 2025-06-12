import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah_data.dart';
import '../models/ayah.dart'; // Ensure Ayah model is imported if not implicitly via SurahData

class QuranApiService {
  final String _baseUrl = "http://api.alquran.cloud/v1";

  Future<SurahData> fetchSurah(int surahNumber) async {
    final String editions = "quran-uthmani,fr.hamidullah,ar.alafasy";
    final response = await http.get(Uri.parse('$_baseUrl/surah/$surahNumber/editions/$editions'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 'OK' && jsonResponse['data'] != null && jsonResponse['data'] is List) {
        List<dynamic> editionsData = jsonResponse['data'];

        // Find the specific editions by identifier
        Map<String, dynamic>? arabicEdition = editionsData.firstWhere((e) => e['identifier'] == 'quran-uthmani', orElse: () => null);
        Map<String, dynamic>? frenchEdition = editionsData.firstWhere((e) => e['identifier'] == 'fr.hamidullah', orElse: () => null);
        Map<String, dynamic>? audioEdition = editionsData.firstWhere((e) => e['identifier'] == 'ar.alafasy', orElse: () => null);

        if (arabicEdition != null && frenchEdition != null && audioEdition != null) {
          // Extract Ayahs from each edition
          List<Map<String, dynamic>> arabicAyahs = List<Map<String, dynamic>>.from(arabicEdition['ayahs']);
          List<Map<String, dynamic>> frenchAyahs = List<Map<String, dynamic>>.from(frenchEdition['ayahs']);
          List<Map<String, dynamic>> audioAyahs = List<Map<String, dynamic>>.from(audioEdition['ayahs']);

          // Assuming surah metadata is consistent, take from the first edition (arabicEdition)
          // The factory constructor for SurahData will handle Ayah list creation
          return SurahData.fromJson(arabicEdition, arabicAyahs, frenchAyahs, audioAyahs);
        } else {
          throw Exception('One or more required editions not found in API response.');
        }
      } else {
        throw Exception('Failed to parse Quran API response or data is not in expected format.');
      }
    } else {
      throw Exception('Failed to load Surah $surahNumber. Status code: ${response.statusCode}');
    }
  }
}
