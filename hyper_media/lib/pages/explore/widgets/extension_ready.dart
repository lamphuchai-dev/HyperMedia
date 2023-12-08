part of '../view/explore_view.dart';

class ExtensionReady extends StatelessWidget {
  const ExtensionReady(
      {super.key, required this.extension, required this.exploreCubit});
  final Extension extension;
  final ExploreCubit exploreCubit;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      mobileWidget: Scaffold(
        appBar: AppBar(
            title: GestureDetector(
              onTap: () async {
                exploreCubit.getExtensions
                    .then((extensions) => showModalBottomSheet(
                          elevation: 0,
                          context: context,
                          backgroundColor: Colors.transparent,
                          clipBehavior: Clip.hardEdge,
                          isScrollControlled: true,
                          builder: (context) => SelectExtensionBottomSheet(
                            extensions: extensions,
                            exceptionPrimary:
                                (exploreCubit.state as ExploreLoaded).extension,
                            onSelected: exploreCubit.onChangeExtension,
                          ),
                        ));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 40,
                      alignment: Alignment.center,
                      child: IconExtension(
                        icon: extension.metadata.icon,
                      )),
                  Gaps.wGap8,
                  Flexible(child: Text(extension.metadata.name ?? "")),
                  Gaps.wGap8,
                  const Icon(
                    Icons.expand_more_rounded,
                    size: 26,
                  )
                ],
              ),
            ),
            actions: [
              if (extension.script.search != null)
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesName.search,
                          arguments: extension);
                    },
                    icon: const Icon(Icons.search_rounded))
            ]),
        body: BlocBuilder<ExploreCubit, ExploreState>(
          buildWhen: (previous, current) {
            if (previous is ExploreLoaded && current is ExploreLoaded) {
              return previous.status != current.status;
            }
            return false;
          },
          builder: (context, state) {
            if (state is ExploreLoaded) {
              return switch (state.status) {
                StatusType.loading => const LoadingWidget(),
                StatusType.loaded =>
                  _extReady(context, state.extension, state.tabs),
                StatusType.error => const Text("error"),
                _ => const SizedBox()
              };
            }
            return const SizedBox();
          },
        ),
      ),
      macosWidget: MacosScaffold(
        toolBar: ToolBar(
          titleWidth: 300,
          title: GestureDetector(
            onTap: () async {
              exploreCubit.getExtensions
                  .then((extensions) => showModalBottomSheet(
                        elevation: 0,
                        context: context,
                        backgroundColor: Colors.transparent,
                        clipBehavior: Clip.hardEdge,
                        enableDrag: false,
                        isScrollControlled: true,
                        builder: (context) => SelectExtensionBottomSheet(
                          extensions: extensions,
                          exceptionPrimary:
                              (exploreCubit.state as ExploreLoaded).extension,
                          onSelected: exploreCubit.onChangeExtension,
                        ),
                      ));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: 40,
                    alignment: Alignment.center,
                    child: IconExtension(
                      icon: extension.metadata.icon,
                    )),
                Gaps.wGap8,
                Flexible(child: Text(extension.metadata.name ?? "")),
                Gaps.wGap8,
                const Icon(
                  Icons.expand_more_rounded,
                  size: 26,
                )
              ],
            ),
          ),
          actions: [
            ToolBarIconButton(
              label: 'Toggle Sidebar',
              icon: const MacosIcon(
                CupertinoIcons.sidebar_left,
              ),
              onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
              showLabel: false,
            ),
          ],
        ),
        children: [
          ContentArea(
            builder: (context, scrollController) {
              return BlocBuilder<ExploreCubit, ExploreState>(
                buildWhen: (previous, current) {
                  if (previous is ExploreLoaded && current is ExploreLoaded) {
                    return previous.status != current.status;
                  }
                  return false;
                },
                builder: (context, state) {
                  if (state is ExploreLoaded) {
                    return switch (state.status) {
                      StatusType.loading => const LoadingWidget(),
                      StatusType.loaded =>
                        _extReady(context, state.extension, state.tabs),
                      StatusType.error => const Text("error"),
                      _ => const SizedBox()
                    };
                  }
                  return const SizedBox();
                },
              );
            },
          )
        ],
      ),
    );
  }

  Widget _extReady(
      BuildContext context, Extension extension, List<ItemTabExplore> tabs) {
    List<Tab> tabItems = tabs
        .map(
          (e) => Tab(
            text: e.title,
          ),
        )
        .toList();
    List<Widget> tabChildren = tabs
        .map(
          (tabHome) => KeepAliveWidget(
            child: BooksGridWidget(
              key: ValueKey(tabHome.title),
              onFetchListBook: (page) =>
                  exploreCubit.onGetListBook(tabHome.url, page),
              onTap: (book) {
                Navigator.pushNamed(context, RoutesName.detail,
                    arguments: book.bookUrl);
              },
            ),
          ),
        )
        .toList();
    if (extension.script.genre != null) {
      tabItems.add(Tab(
        text: "common.genre".tr(),
      ));
      tabChildren.add(KeepAliveWidget(
          child: ExtensionGenreTab(
        onFetch: () async => exploreCubit.onGetListGenre(),
        extension: extension,
      )));
    }
    return DefaultTabController(
      length: tabItems.length,
      child: Material(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                  isScrollable: true,
                  dividerColor: Colors.transparent,
                  tabs: tabItems),
              Expanded(child: TabBarView(children: tabChildren))
            ],
          ),
        ),
      ),
    );
  }
}
