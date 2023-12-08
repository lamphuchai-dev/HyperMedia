// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'library_cubit.dart';

class LibraryState extends Equatable {
  const LibraryState({required this.books, required this.status});
  final List<Book> books;
  final StatusType status;
  @override
  List<Object> get props => [books, status];

  LibraryState copyWith({
    List<Book>? books,
    StatusType? status,
  }) {
    return LibraryState(
      books: books ?? this.books,
      status: status ?? this.status,
    );
  }
}
