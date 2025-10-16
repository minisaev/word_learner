part of 'category.dart';

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 1;

  @override
  Category read(BinaryReader reader) {
    return Category(
      name: reader.readString(),
      createdDate: DateTime.parse(reader.readString()),
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer.writeString(obj.name);
    writer.writeString(obj.createdDate.toIso8601String());
  }
}