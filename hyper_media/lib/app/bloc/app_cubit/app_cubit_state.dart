part of 'app_cubit_cubit.dart';


class AppCubitState extends Equatable {
  const AppCubitState({required this.themeMode});
  final ThemeMode themeMode;

  AppCubitState copyWith({
    ThemeMode? themeMode,
  }) {
    return AppCubitState(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object> get props => [themeMode];
}
