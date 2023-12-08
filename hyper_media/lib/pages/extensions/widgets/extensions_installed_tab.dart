part of '../view/extensions_view.dart';

class ExtensionsInstalledTab extends StatelessWidget {
  const ExtensionsInstalledTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExtensionsCubit, ExtensionsState>(
      buildWhen: (previous, current) => previous.installed != current.installed,
      builder: (context, state) {
        return switch (state.installed.status) {
          StatusType.loading => const LoadingWidget(),
          StatusType.loaded => state.installed.data.isEmpty
              ? const EmptyListDataWidget(
                  svgType: SvgType.extension,
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.horizontalPadding),
                  child: Column(
                      children: state.installed.data
                          .map((ext) => ExtensionCard(
                              installed: true,
                              metadataExt: ext.metadata,
                              onTap: () => context
                                  .read<ExtensionsCubit>()
                                  .onUninstallExt(ext)))
                          .toList()),
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
