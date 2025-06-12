class Ayah {
  final int numberInSurah;
  final String text;
  final String translationFR;
  final String audioURL;
  final dynamic sajda; // Can be bool or String, dynamic for now

  Ayah({
    required this.numberInSurah,
    required this.text,
    required this.translationFR,
    required this.audioURL,
    this.sajda,
  });

  factory Ayah.fromJson(
      Map<String, dynamic> arabicAyahJson,
      Map<String, dynamic> frenchAyahJson,
      Map<String, dynamic> audioAyahJson) {
    // It's assumed all ayah JSONs here correspond to the same Ayah number
    return Ayah(
      numberInSurah: arabicAyahJson['numberInSurah'],
      text: arabicAyahJson['text'],
      translationFR: frenchAyahJson['text'], // 'text' field for translation
      audioURL: audioAyahJson['audio'],     // 'audio' field for audio URL
      sajda: arabicAyahJson['sajda'],       // Sajda info typically in the primary quran text edition
    );
  }
}
