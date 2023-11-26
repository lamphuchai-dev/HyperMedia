// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:isar/isar.dart';

import 'package:hyper_media/data/models/models.dart';

part 'bookmark.g.dart';

@collection
class Bookmark {
  Id? id;
  final book = IsarLink<Book>();
  final chapters = IsarLinks<Chapter>();
  final reader = IsarLink<Reader>();
}
