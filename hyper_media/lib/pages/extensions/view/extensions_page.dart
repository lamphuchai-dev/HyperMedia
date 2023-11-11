import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/widgets/widget.dart';
import '../cubit/extensions_cubit.dart';
import '../widgets/widgets.dart';

class ExtensionsPage extends StatefulWidget {
  const ExtensionsPage({super.key});

  @override
  State<ExtensionsPage> createState() => _ExtensionsPageState();
}

class _ExtensionsPageState extends State<ExtensionsPage> {
  late ExtensionsCubit _extensionsCubit;
  @override
  void initState() {
    _extensionsCubit = context.read<ExtensionsCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Row(
            children: [
              Expanded(
                  child: TabBar(
                      dividerColor: Colors.transparent,
                      splashBorderRadius: BorderRadius.circular(40),
                      indicatorSize: TabBarIndicatorSize.label,
                      unselectedLabelColor: Colors.grey,
                      labelPadding: EdgeInsets.zero,
                      labelStyle: textTheme.titleMedium,
                      labelColor: textTheme.titleMedium?.color,
                      tabs: const [
                    Tab(
                      text: "Đã cài đặt",
                    ),
                    Tab(
                      text: "Tất cả",
                    )
                  ]))
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: TabBarView(children: [
            const KeepAliveWidget(child: ExtensionsInstalled()),
            KeepAliveWidget(
                child: ExtensionsAll(
              extensionsCubit: _extensionsCubit,
            ))
          ]),
        ),
      ),
    );
  }
}
