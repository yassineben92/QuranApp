import 'package:flutter/material.dart';
import 'services/quran_api_service.dart'; // Import the service
import 'models/surah_data.dart'; // Import the model

void main() async { // Make main async
  // Temporary test for fetchSurah
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized for HTTP requests

  QuranApiService apiService = QuranApiService();
  try {
    print("Fetching Surah 1...");
    SurahData surah1 = await apiService.fetchSurah(1);
    print("Surah Name: ${surah1.englishName}");
    print("Number of Ayahs: ${surah1.ayahs.length}");
    if (surah1.ayahs.isNotEmpty) {
      print("First Ayah Text: ${surah1.ayahs[0].text}");
      print("First Ayah French Translation: ${surah1.ayahs[0].translationFR}");
      print("First Ayah Audio URL: ${surah1.ayahs[0].audioURL}");
      print("First Ayah Sajda: ${surah1.ayahs[0].sajda}");
    }

    // Example for Surah with Sajda (Surah 32, Ayah 15)
    // print("\nFetching Surah 32 (As-Sajdah)...");
    // SurahData surah32 = await apiService.fetchSurah(32);
    // print("Surah Name: ${surah32.englishName}");
    // Ayah ayah15 = surah32.ayahs.firstWhere((ayah) => ayah.numberInSurah == 15);
    // print("Ayah 15 Sajda: ${ayah15.sajda}");


  } catch (e) {
    print("Error fetching Surah: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _surahInfo = "Loading..."; // To display surah info

  @override
  void initState() {
    super.initState();
    _loadSurahData(); // Load data when widget is initialized
  }

  void _loadSurahData() async {
    QuranApiService apiService = QuranApiService();
    try {
      SurahData surah = await apiService.fetchSurah(1); // Fetch first surah
      if (mounted) { // Check if the widget is still in the tree
        setState(() {
          _surahInfo = "Surah: ${surah.name}\n";
          _surahInfo += "English Name: ${surah.englishName}\n";
          _surahInfo += "Ayahs: ${surah.ayahs.length}\n";
          if (surah.ayahs.isNotEmpty) {
            _surahInfo += "First Ayah (FR): ${surah.ayahs[0].translationFR}";
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _surahInfo = "Failed to load surah: $e";
        });
      }
      print(e); // Also print to console
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Padding( // Added padding for surah info
              padding: const EdgeInsets.all(16.0),
              child: Text(_surahInfo),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
