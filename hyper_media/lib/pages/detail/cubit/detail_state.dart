// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'detail_cubit.dart';

abstract class DetailState extends Equatable {
  const DetailState();
  @override
  List<Object> get props => [];
}

class DetailInitial extends DetailState {}

class DetailLoading extends DetailState {}

class DetailLoaded extends DetailState {
  final Book book;
  const DetailLoaded({
    required this.book,
  });

  DetailLoaded copyWith({
    Book? book,
  }) {
    return DetailLoaded(
      book: book ?? this.book,
    );
  }

  @override
  List<Object> get props => [book];
}

class DetailError extends DetailState {
  final String message;
  const DetailError({
    required this.message,
  });

  DetailError copyWith({
    String? message,
  }) {
    return DetailError(
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [message];
}
