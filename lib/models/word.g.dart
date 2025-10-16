// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordAdapter extends TypeAdapter<Word> {
  @override
  final int typeId = 0;

  @override
  Word read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Word(
      original: fields[0] as String,
      translation: fields[1] as String,
      example: fields[2] as String?,
      status: fields[3] as String,
      addedDate: fields[4] as DateTime,
      correctAnswers: fields[5] as int,
      incorrectAnswers: fields[6] as int,
      categoryId: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Word obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.original)
      ..writeByte(1)
      ..write(obj.translation)
      ..writeByte(2)
      ..write(obj.example)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.addedDate)
      ..writeByte(5)
      ..write(obj.correctAnswers)
      ..writeByte(6)
      ..write(obj.incorrectAnswers)
      ..writeByte(7)
      ..write(obj.categoryId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
