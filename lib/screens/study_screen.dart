import 'package:flutter/material.dart';
import 'package:word_learner/models/word.dart';
import 'package:word_learner/services/word_service.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  _StudyScreenState createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  final WordService _wordService = WordService();
  Word? currentWord;
  bool showAnswer = false;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadNextWord();
  }

  Future<void> _loadNextWord() async {
    final words = await _wordService.getWords();
    if (words.isNotEmpty) {
      setState(() {
        currentWord = words[DateTime.now().millisecondsSinceEpoch % words.length];
        showAnswer = false;
        progress = currentWord!.correctAnswers / 3;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentWord == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Study')),
        body: const Center(child: Text('No words to study')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Study')),
      body: Dismissible(
        key: Key(currentWord!.original),
        onDismissed: (direction) async {
          if (direction == DismissDirection.endToStart) {
            await _wordService.updateWordStats(currentWord!, true);
          } else {
            await _wordService.updateWordStats(currentWord!, false);
          }
          _loadNextWord();
        },
        background: const Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.check, color: Colors.green, size: 50),
        ),
        secondaryBackground: const Align(
          alignment: Alignment.centerRight,
          child: Icon(Icons.close, color: Colors.red, size: 50),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 300,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 10)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentWord!.original,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                if (showAnswer) ...[
                  Text(
                    currentWord!.translation,
                    style: const TextStyle(fontSize: 24, color: Colors.blue),
                  ),
                  if (currentWord!.example != null)
                    Text(
                      currentWord!.example!,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                ],
                const SizedBox(height: 20),
                LinearProgressIndicator(value: progress, color: Colors.green),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showAnswer = true;
                    });
                  },
                  child: const Text('Show Answer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}