import 'package:hive/hive.dart';

part 'word.g.dart';

@HiveType(typeId: 0)
class Word extends HiveObject {
  @HiveField(0)
  String original;

  @HiveField(1)
  String translation;

  @HiveField(2)
  String? example;

  @HiveField(3)
  String status;

  @HiveField(4)
  DateTime addedDate;

  @HiveField(5)
  int correctAnswers;

  @HiveField(6)
  int incorrectAnswers;

  @HiveField(7)
  int? categoryId;

  Word({
    required this.original,
    required this.translation,
    this.example,
    this.status = 'New',
    required this.addedDate,
    this.correctAnswers = 0,
    this.incorrectAnswers = 0,
    this.categoryId,
  });
}