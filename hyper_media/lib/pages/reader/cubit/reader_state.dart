// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'reader_cubit.dart';

enum ExtensionStatus { init, ready, unknown, error }

enum ControlStatus { none, init, start, pause, complete, stop, error }

enum MenuType { base, audio, autoScroll }

class ReaderState extends Equatable {
  const ReaderState(
      {required this.extensionStatus,
      required this.readerType,
      required this.chapters,
      required this.book,
      this.readChapter});
  final ExtensionStatus extensionStatus;
  final ReaderType readerType;
  final ReadChapter? readChapter;
  final List<Chapter> chapters;
  final Book book;
  @override
  List<Object?> get props =>
      [extensionStatus, readChapter, readerType, chapters, book];

  ReaderState copyWith({
    ExtensionStatus? extensionStatus,
    ReaderType? readerType,
    ReadChapter? readChapter,
    List<Chapter>? chapters,
    Book? book,
  }) {
    return ReaderState(
        extensionStatus: extensionStatus ?? this.extensionStatus,
        readerType: readerType ?? this.readerType,
        readChapter: readChapter ?? this.readChapter,
        chapters: chapters ?? this.chapters,
        book: book ?? this.book);
  }
}

class ReadChapter extends Equatable {
  final Chapter chapter;
  final StatusType status;
  final Chapter? previousChapter;
  final Chapter? nextChapter;
  const ReadChapter(
      {required this.chapter,
      required this.status,
      this.nextChapter,
      this.previousChapter});

  factory ReadChapter.init(
      {required int initIndex, required List<Chapter> chapters}) {
    Chapter? previousChapter;
    Chapter? nextChapter;

    if (initIndex > 0) {
      previousChapter = chapters[initIndex - 1];
    }

    if (initIndex + 1 < chapters.length) {
      nextChapter = chapters[initIndex + 1];
    }

    return ReadChapter(
        previousChapter: previousChapter,
        nextChapter: nextChapter,
        chapter: chapters[initIndex],
        status: StatusType.init);
  }

  ReadChapter copyWith({
    Chapter? chapter,
    StatusType? status,
    Chapter? previousChapter,
    Chapter? nextChapter,
  }) {
    return ReadChapter(
        chapter: chapter ?? this.chapter,
        status: status ?? this.status,
        previousChapter: previousChapter ?? this.previousChapter,
        nextChapter: nextChapter ?? this.nextChapter);
  }

  ReadChapter next({required List<Chapter> chapters}) {
    if (nextChapter == null) return this;
    if (nextChapter!.index + 1 >= chapters.length) {
      return ReadChapter(
          previousChapter: chapter,
          chapter: nextChapter!,
          nextChapter: null,
          status: StatusType.init);
    }
    return ReadChapter(
        previousChapter: chapter,
        chapter: nextChapter!,
        nextChapter: chapters[nextChapter!.index + 1],
        status: StatusType.init);
  }

  ReadChapter previous({required List<Chapter> chapters}) {
    if (previousChapter == null) return this;
    if (previousChapter!.index <= 0) {
      return ReadChapter(
          previousChapter: null,
          chapter: previousChapter!,
          nextChapter: chapter,
          status: StatusType.init);
    }
    return ReadChapter(
        previousChapter: chapters[previousChapter!.index - 1],
        chapter: previousChapter!,
        nextChapter: chapter,
        status: StatusType.init);
  }

  @override
  List<Object?> get props => [chapter, status, previousChapter, nextChapter];
}
