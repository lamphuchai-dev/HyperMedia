import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'browser_state.dart';

class BrowserCubit extends Cubit<BrowserState> {
  BrowserCubit() : super(BrowserInitial());

  void onInit() {}
}
