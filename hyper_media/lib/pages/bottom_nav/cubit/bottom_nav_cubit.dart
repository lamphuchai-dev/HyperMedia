import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_nav_state.dart';

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(const BottomNavState(indexSelected: 0));

  void onChangeIndex(int index) {
    emit(BottomNavState(indexSelected: index));
  }
}
