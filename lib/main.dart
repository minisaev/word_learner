import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/word.dart';
import 'models/category.dart';
import 'screens/home_screen.dart';
import 'screens/add_word_screen.dart';
import 'screens/study_screen.dart';
import 'screens/stats_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(WordAdapter());
  Hive.registerAdapter(CategoryAdapter());
  await Hive.openBox<Word>('words');
  await Hive.openBox<Category>('categories');
  runApp(const WordLearnerApp());
}

class WordLearnerApp extends StatefulWidget {
  const WordLearnerApp({super.key});

  @override
  _WordLearnerAppState createState() => _WordLearnerAppState();
}

class _WordLearnerAppState extends State<WordLearnerApp> {
  ThemeMode _themeMode = ThemeMode.system; // По умолчанию система

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Learner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(themeToggle: _toggleTheme, themeMode: _themeMode),
        '/add': (context) => const AddWordScreen(),
        '/study': (context) => const StudyScreen(),
        '/stats': (context) => const StatsScreen(),
      },
    );
  }
}