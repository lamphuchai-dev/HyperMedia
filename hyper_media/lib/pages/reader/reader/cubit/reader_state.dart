part of 'reader_cubit.dart';

class ReaderState extends Equatable {
  const ReaderState({
    required this.extensionStatus,
    required this.book,
    required this.chapters,
  });
  final ExtensionStatus extensionStatus;
  final Book book;
  final List<Chapter> chapters;

  @override
  List<Object> get props => [extensionStatus, book, chapters];

  ReaderState copyWith({
    ExtensionStatus? extensionStatus,
    Book? book,
    List<Chapter>? chapters,
  }) {
    return ReaderState(
      extensionStatus: extensionStatus ?? this.extensionStatus,
      book: book ?? this.book,
      chapters: chapters ?? this.chapters,
    );
  }
}
