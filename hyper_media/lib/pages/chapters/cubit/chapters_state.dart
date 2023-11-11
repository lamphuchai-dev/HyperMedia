// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chapters_cubit.dart';

class ChaptersState extends Equatable {
  const ChaptersState(
      {required this.chapters,
      required this.statusType,
      required this.sortType});
  final List<Chapter> chapters;
  final StatusType statusType;
  final SortChapterType sortType;
  @override
  List<Object> get props => [chapters, statusType, sortType];

  ChaptersState copyWith(
      {List<Chapter>? chapters,
      StatusType? statusType,
      SortChapterType? sortType}) {
    return ChaptersState(
        chapters: chapters ?? this.chapters,
        statusType: statusType ?? this.statusType,
        sortType: sortType ?? this.sortType);
  }
}
