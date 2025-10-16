import 'package:flutter/material.dart';
import 'package:word_learner/models/word.dart';
import 'package:word_learner/services/word_service.dart';

class CategoryScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const CategoryScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final WordService _wordService = WordService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: FutureBuilder<List<Word>>(
        future: _wordService.getWords(categoryId: widget.categoryId),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add', arguments: widget.categoryId);
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}