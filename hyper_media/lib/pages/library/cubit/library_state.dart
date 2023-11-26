// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'library_cubit.dart';

class LibraryState extends Equatable {
  const LibraryState({required this.bookmarks, required this.status});
  final List<Bookmark> bookmarks;
  final StatusType status;
  @override
  List<Object> get props => [bookmarks, status];

  LibraryState copyWith({
    List<Bookmark>? bookmarks,
    StatusType? status,
  }) {
    return LibraryState(
      bookmarks: bookmarks ?? this.bookmarks,
      status: status ?? this.status,
    );
  }
}
