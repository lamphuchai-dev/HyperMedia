// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'extensions_cubit.dart';

class ExtensionsState extends Equatable {
  const ExtensionsState({required this.allExtension, required this.installed});
  final StateModel<Extension> installed;
  final StateModel<Metadata> allExtension;

  @override
  List<Object> get props => [installed, allExtension];

  ExtensionsState copyWith({
    StateModel<Extension>? installed,
    StateModel<Metadata>? allExtension,
  }) {
    return ExtensionsState(
      installed: installed ?? this.installed,
      allExtension: allExtension ?? this.allExtension,
    );
  }
}

class StateModel<T> extends Equatable {
  final List<T> data;
  final StatusType status;
  const StateModel({
    required this.data,
    required this.status,
  });

  factory StateModel.init() =>
      const StateModel(data: [], status: StatusType.init);

  @override
  List<Object?> get props => [data, status];

  StateModel<T> copyWith({
    List<T>? data,
    StatusType? status,
  }) {
    return StateModel(
      data: data ?? this.data,
      status: status ?? this.status,
    );
  }
}
