import 'reader_cubit.dart';

abstract class ReaderType {
  MenuType get getMenuType;
}

class ReaderBase extends ReaderType {
  ReaderBase();
  @override
  MenuType get getMenuType => MenuType.base;
}

class ReaderTypeAutoScroll extends ReaderType {
  @override
  MenuType get getMenuType => MenuType.autoScroll;
}

class ReaderTypeAudio extends ReaderType {
  @override
  MenuType get getMenuType => MenuType.audio;
}
