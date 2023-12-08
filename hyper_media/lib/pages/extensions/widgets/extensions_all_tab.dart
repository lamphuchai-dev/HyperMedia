part of '../view/extensions_view.dart';

class ExtensionsAllTab extends StatelessWidget {
  const ExtensionsAllTab({super.key, required this.extensionsCubit});
  final ExtensionsCubit extensionsCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExtensionsCubit, ExtensionsState>(
      buildWhen: (previous, current) =>
          previous.allExtension != current.allExtension,
      builder: (context, state) {
        return switch (state.allExtension.status) {
          StatusType.loading => const LoadingWidget(),
          StatusType.loaded => Builder(
              builder: (context) {
                final list =
                    extensionsCubit.removeExtInstalled(state.allExtension.data);
                return RefreshIndicator(
                    child: list.isEmpty
                        ? const EmptyListDataWidget(svgType: SvgType.extension)
                        : SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimens.horizontalPadding),
                            child: Column(
                                children: list
                                    .map((meta) => ExtensionCard(
                                        installed: false,
                                        metadataExt: meta,
                                        onTap: () => context
                                            .read<ExtensionsCubit>()
                                            .onInstallExt(meta.path!)))
                                    .toList()),
                          ),
                    onRefresh: () async {
                      extensionsCubit.getExtensions();
                    });
              },
            ),
          StatusType.error => const Center(
              child: Text("ERROR"),
            ),
          _ => const SizedBox(),
        };
      },
    );
  }
}
