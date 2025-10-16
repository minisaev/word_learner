import 'package:flutter/material.dart';
import 'package:word_learner/models/word.dart';
import 'package:word_learner/services/word_service.dart';

class AddWordScreen extends StatefulWidget {
  const AddWordScreen({super.key});

  @override
  _AddWordScreenState createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _originalController = TextEditingController();
  final _translationController = TextEditingController();
  final _exampleController = TextEditingController();
  final _wordService = WordService();

  @override
  Widget build(BuildContext context) {
    final categoryId = ModalRoute.of(context)!.settings.arguments as int?;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Word')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _originalController,
                decoration: const InputDecoration(labelText: 'Word'),
                validator: (value) => value!.isEmpty ? 'Enter a word' : null,
              ),
              TextFormField(
                controller: _translationController,
                decoration: const InputDecoration(labelText: 'Translation'),
                validator: (value) => value!.isEmpty ? 'Enter a translation' : null,
              ),
              TextFormField(
                controller: _exampleController,
                decoration: const InputDecoration(labelText: 'Example (optional)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final word = Word(
                      original: _originalController.text,
                      translation: _translationController.text,
                      example: _exampleController.text.isEmpty ? null : _exampleController.text,
                      addedDate: DateTime.now(),
                      categoryId: categoryId,
                    );
                    await _wordService.addWord(word);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}