// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'reader_cubit.dart';

enum ExtensionStatus { init, ready, unknown, error }

enum ControlStatus { init, start, pause, complete, stop, error }

enum MenuType { base, audio, autoScroll }

class ReaderState extends Equatable {
  const ReaderState(
      {required this.extensionStatus,
      required this.book,
      required this.menuType,
      required this.controlStatus,
      this.watchChapter});
  final ExtensionStatus extensionStatus;
  final MenuType menuType;
  final ControlStatus controlStatus;
  final Book book;
  final WatchChapter? watchChapter;
  @override
  List<Object?> get props =>
      [extensionStatus, watchChapter, menuType, book, controlStatus];

  ReaderState copyWith(
      {ExtensionStatus? extensionStatus,
      List<Chapter>? chapters,
      MenuType? menuType,
      Book? book,
      ControlStatus? controlStatus,
      WatchChapter? watchChapter}) {
    return ReaderState(
        extensionStatus: extensionStatus ?? this.extensionStatus,
        menuType: menuType ?? this.menuType,
        book: book ?? this.book,
        controlStatus: controlStatus ?? this.controlStatus,
        watchChapter: watchChapter ?? this.watchChapter);
  }
}

class WatchChapter extends Equatable {
  final Chapter chapter;
  final StatusType status;
  const WatchChapter({
    required this.chapter,
    required this.status,
  });

  WatchChapter copyWith({
    Chapter? chapter,
    StatusType? status,
  }) {
    return WatchChapter(
      chapter: chapter ?? this.chapter,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [chapter, status];
}
