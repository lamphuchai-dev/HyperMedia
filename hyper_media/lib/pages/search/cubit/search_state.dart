// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_cubit.dart';

class SearchState extends Equatable {
  const SearchState({required this.books,required this.status});
  final StatusType status;
  final List<Book> books;
  @override
  List<Object> get props => [status,books];

  SearchState copyWith({
    StatusType? status,
    List<Book>? books,
  }) {
    return SearchState(
      status: status ?? this.status,
      books: books ?? this.books,
    );
  }
}
