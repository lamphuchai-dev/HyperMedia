// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'detail_cubit.dart';

class DetailState extends Equatable {
  const DetailState({required this.bookState, required this.chaptersState});
  final StateRes<Book> bookState;
  final StateRes<List<Chapter>> chaptersState;

  @override
  List<Object> get props => [bookState, chaptersState];

  DetailState copyWith(
      {StateRes<Book>? bookState, StateRes<List<Chapter>>? chaptersState}) {
    return DetailState(
        bookState: bookState ?? this.bookState,
        chaptersState: chaptersState ?? this.chaptersState);
  }
}

// abstract class DetailStateRes extends Equatable {
//   const DetailStateRes();
//   @override
//   List<Object> get props => [];
// }

// class DetailInitial extends DetailStateRes {}

// class DetailLoading extends DetailStateRes {}

// class DetailLoaded extends DetailStateRes {
//   final Book book;
//   const DetailLoaded({
//     required this.book,
//   });

//   DetailLoaded copyWith({
//     Book? book,
//   }) {
//     return DetailLoaded(
//       book: book ?? this.book,
//     );
//   }

//   @override
//   List<Object> get props => [book];
// }

// class DetailError extends DetailStateRes {
//   final String message;
//   const DetailError({
//     required this.message,
//   });

//   DetailError copyWith({
//     String? message,
//   }) {
//     final tmp = Res<List<Book>>(status: StatusType.init, data: []);
//     return DetailError(
//       message: message ?? this.message,
//     );
//   }

//   @override
//   List<Object> get props => [message];
// }

class StateRes<T> extends Equatable {
  final StatusType status;
  final T? data;
  final String? message;
  const StateRes({required this.status, this.data, this.message});

  StateRes<T> copyWith({StatusType? status, T? data, String? message}) {
    return StateRes<T>(
        status: status ?? this.status,
        data: data ?? this.data,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => [status, data, message];
}
