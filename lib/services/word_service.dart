import 'dart:io';
import 'package:hive/hive.dart';
import 'package:word_learner/models/word.dart';
import 'package:word_learner/models/category.dart';

class WordService {
  final _wordBox = Hive.box<Word>('words');
  final _categoryBox = Hive.box<Category>('categories');

  Future<void> addWord(Word word) async {
    await _wordBox.add(word);
  }

  Future<List<Word>> getWords({int? categoryId}) async {
    var words = _wordBox.values.toList();
    if (categoryId != null) {
      words = words.where((w) => w.categoryId == categoryId).toList();
    }
    words.sort((a, b) => a.original.compareTo(b.original)); // Сортировка по алфавиту
    return words;
  }

  Future<void> deleteWord(Word word) async {
    await word.delete();
  }

  Future<void> importWordsFromTxt(File file, {int? categoryId}) async {
    final lines = await file.readAsLines();
    for (var line in lines) {
      final parts = line.split(';');
      if (parts.length >= 2) {
        final word = Word(
          original: parts[0].trim(),
          translation: parts[1].trim(),
          example: parts.length > 2 ? parts[2].trim() : null,
          addedDate: DateTime.now(),
          categoryId: categoryId,
        );
        await addWord(word);
      }
    }
  }

  Future<void> updateWordStats(Word word, bool isCorrect) async {
    word.correctAnswers += isCorrect ? 1 : 0;
    word.incorrectAnswers += isCorrect ? 0 : 1;
    word.status = word.correctAnswers >= 3 ? 'Learned' : 'In Progress';
    await word.save();
  }

  Future<void> addCategory(String name) async {
    final category = Category(
      name: name,
      createdDate: DateTime.now(),
    );
    await _categoryBox.add(category);
  }

  Future<List<Category>> getCategories() async {
    return _categoryBox.values.toList();
  }

  Future<void> deleteCategory(Category category) async {
    final wordsToDelete = _wordBox.values.where((w) => w.categoryId == category.key).toList();
    for (var word in wordsToDelete) {
      await word.delete();
    }
    await category.delete();
  }
}