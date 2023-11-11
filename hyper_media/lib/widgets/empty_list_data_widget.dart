import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/extensions/index.dart';


enum SvgType { defaultSvg, search, extension }

class EmptyListDataWidget extends StatefulWidget {
  const EmptyListDataWidget({super.key, required this.svgType});
  final SvgType svgType;

  @override
  State<EmptyListDataWidget> createState() => _EmptyListDataWidgetState();
}

class _EmptyListDataWidgetState extends State<EmptyListDataWidget> {
  late Future<String> _future;
  @override
  void initState() {
    switch (widget.svgType) {
      case SvgType.search:
        _future = rootBundle.loadString(AppAssets.searchSvg);
        break;
      case SvgType.extension:
        _future = rootBundle.loadString(AppAssets.extensionSvg);
        break;
      default:
        _future = rootBundle.loadString(AppAssets.defaultSvg);
        break;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.appTextTheme;

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: constraints.maxHeight * 0.3,
                width: constraints.maxWidth,
                child: FutureBuilder(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data is String) {
                        String svgString = snapshot.data!.replaceAll(
                            "#666AF6", _convertColor(colorScheme.primary));
                        switch (widget.svgType) {
                          case SvgType.search:
                            if (colorScheme.brightness == Brightness.light) {
                              svgString = svgString.replaceAll("#fff",
                                  _convertColor(colorScheme.background));
                            } else {
                              svgString = svgString.replaceAll("#E1E4E5",
                                  _convertColor(colorScheme.surface));
                              svgString = svgString.replaceAll("#fff",
                                  _convertColor(colorScheme.background));
                            }
                            break;
                          case SvgType.extension:
                            if (colorScheme.brightness == Brightness.light) {
                              svgString = svgString.replaceAll("#E1E4E5",
                                  _convertColor(colorScheme.surface));
                            } else {
                              svgString = svgString.replaceAll("#E1E4E5",
                                  _convertColor(colorScheme.surface));
                              svgString = svgString.replaceAll("#fff",
                                  _convertColor(colorScheme.background));
                              svgString = svgString.replaceAll("#FFF",
                                  _convertColor(colorScheme.background));
                            }
                            break;
                          default:
                            if (colorScheme.brightness == Brightness.light) {
                              svgString = svgString.replaceAll("#fff",
                                  _convertColor(colorScheme.background));
                              svgString = svgString.replaceAll(
                                  "#EEE", _convertColor(colorScheme.surface));
                            } else {
                              svgString = svgString.replaceAll("#E1E4E5",
                                  _convertColor(colorScheme.surface));
                              svgString = svgString.replaceAll("#fff",
                                  _convertColor(colorScheme.background));
                              svgString = svgString.replaceAll(
                                  "#EEE", _convertColor(colorScheme.surface));
                            }
                            break;
                        }

                        return SvgPicture.string(svgString);
                      }
                    }
                    return const SizedBox();
                  },
                ),
              ),
              Text(
                "Không có dữ liệu hiện thị",
                style: textTheme.bodyLarge,
              )
            ],
          ),
        ),
      ),
    );
  }

  String _convertColor(Color color) {
    return "#${color.value.toRadixString(16).substring(2)}";
  }
}
