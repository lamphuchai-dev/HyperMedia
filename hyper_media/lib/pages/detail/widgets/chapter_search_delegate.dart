part of '../view/detail_view.dart';

class ChapterSearchDelegate extends SearchDelegate {
  final List<Chapter> chapters;
  ChapterSearchDelegate({required this.chapters});

  @override
  ThemeData appBarTheme(BuildContext context) {
    final tmp = super.appBarTheme(context).inputDecorationTheme;

    return context.appTheme.copyWith(inputDecorationTheme: tmp);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildWidget();

  @override
  Widget buildSuggestions(BuildContext context) => _buildWidget();
  Widget _buildWidget() {
    final search = _onSearch();
    if (search.isEmpty) {
      return const EmptyListDataWidget(svgType: SvgType.search);
    }
    return ThemeBuildWidget(
      builder: (context, themeData, textTheme, colorScheme) => ListView.builder(
        itemCount: search.length,
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            close(context, search[index]);
          },
          title: Text(
            search[index].name,
            style: textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }

  List<Chapter> _onSearch() {
    if (query.isEmpty) chapters;
    return chapters.where((el) => el.name.contains(query)).toList();
  }
}
