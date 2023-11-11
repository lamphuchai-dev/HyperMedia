import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'test_ui_state.dart';

class TestUiCubit extends Cubit<TestUiState> {
  TestUiCubit() : super(TestUiInitial());

  void onInit() {}
}
