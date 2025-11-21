import 'package:isar/isar.dart';

part 'placeholder.g.dart';

@collection
class Placeholder {
  Id id = Isar.autoIncrement;

  String? data;
}
