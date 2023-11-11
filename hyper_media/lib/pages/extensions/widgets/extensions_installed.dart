import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/types/app_type.dart';
import 'package:hyper_media/pages/extensions/cubit/extensions_cubit.dart';
import 'package:hyper_media/widgets/widget.dart';

import 'extension_card_widget.dart';

class ExtensionsInstalled extends StatelessWidget {
  const ExtensionsInstalled({super.key});

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
                          .map((ext) => ExtensionCardWidget(
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
