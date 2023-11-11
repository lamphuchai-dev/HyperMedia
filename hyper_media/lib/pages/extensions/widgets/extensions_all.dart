import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/pages/extensions/cubit/extensions_cubit.dart';
import 'package:hyper_media/widgets/widget.dart';

import 'extension_card_widget.dart';

class ExtensionsAll extends StatelessWidget {
  const ExtensionsAll({super.key, required this.extensionsCubit});
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
                                    .map((meta) => ExtensionCardWidget(
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
