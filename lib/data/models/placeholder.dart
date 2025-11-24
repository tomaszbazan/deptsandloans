import 'package:isar_community/isar.dart';

part 'placeholder.g.dart';

@Collection()
class Placeholder {
  Id id = Isar.autoIncrement;

  String? data;
}
