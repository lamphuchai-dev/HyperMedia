part of 'tabs_cubit.dart';

class TabsState extends Equatable {
  const TabsState({required this.index});
  final int index;
  @override
  List<Object> get props => [index];
}
