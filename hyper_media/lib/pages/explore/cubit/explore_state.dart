// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'explore_cubit.dart';

class ExploreState extends Equatable {
  const ExploreState();
  @override
  List<Object> get props => [];
}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {}

class ExploreLoaded extends ExploreState {
  final Extension extension;
  final List<ItemTabExplore> tabs;
  final StatusType status;
  const ExploreLoaded(
      {required this.extension, required this.tabs, required this.status});
  @override
  List<Object> get props => [extension, tabs, status];

  ExploreLoaded copyWith(
      {Extension? extension, List<ItemTabExplore>? tabs, StatusType? status}) {
    return ExploreLoaded(
        extension: extension ?? this.extension,
        tabs: tabs ?? this.tabs,
        status: status ?? this.status);
  }
}

class ExploreNotExtension extends ExploreState {
  const ExploreNotExtension();
}

class ExploreError extends ExploreState {
  final String message;
  const ExploreError(this.message);
  @override
  List<Object> get props => [message];
}

class ItemTabExplore {
  final String title;
  final String url;
  ItemTabExplore({
    required this.title,
    required this.url,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'url': url,
    };
  }

  factory ItemTabExplore.fromMap(Map<String, dynamic> map) {
    return ItemTabExplore(
      title: map['title'] as String,
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemTabExplore.fromJson(String source) =>
      ItemTabExplore.fromMap(json.decode(source) as Map<String, dynamic>);
}
