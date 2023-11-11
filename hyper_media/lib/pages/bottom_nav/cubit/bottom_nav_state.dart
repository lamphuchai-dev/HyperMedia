part of 'bottom_nav_cubit.dart';

class BottomNavState extends Equatable {
  const BottomNavState({required this.indexSelected});
  final int indexSelected;
  @override
  List<Object> get props => [indexSelected];
}
