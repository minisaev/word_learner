import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:word_learner/services/word_service.dart';
import 'package:word_learner/models/word.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback themeToggle;
  final ThemeMode themeMode;

  const HomeScreen({super.key, required this.themeToggle, required this.themeMode});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WordService _wordService = WordService();

  Future<void> _importWords() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );
    if (result != null) {
      final file = File(result.files.single.path!);
      await _wordService.importWordsFromTxt(file);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Learner'),
        actions: [
          IconButton(
            icon: Icon(
              widget.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: widget.themeToggle,
          ),
        ],
      ),
      body: FutureBuilder<List<Word>>(
        future: _wordService.getWords(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final words = snapshot.data!;
          return ListView.builder(
            itemCount: words.length,
            itemBuilder: (context, index) {
              final word = words[index];
              return ListTile(
                title: Text(word.original),
                subtitle: Text(word.translation),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await _wordService.deleteWord(word);
                    setState(() {});
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await Navigator.pushNamed(context, '/add');
              setState(() {});
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _importWords,
            child: const Icon(Icons.upload_file),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Study'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
        ],
        onTap: (index) {
          if (index == 1) Navigator.pushNamed(context, '/study');
          if (index == 2) Navigator.pushNamed(context, '/stats');
        },
      ),
    );
  }
}