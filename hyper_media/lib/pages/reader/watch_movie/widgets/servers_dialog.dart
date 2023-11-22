import 'package:flutter/material.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/extensions/index.dart';

import '../cubit/watch_movie_cubit.dart';

class ServersDialog extends StatelessWidget {
  const ServersDialog(
      {Key? key,
      required this.servers,
      required this.current,
      required this.onChange})
      : super(key: key);
  final List<MovieServer> servers;
  final MovieServer current;
  final ValueChanged<MovieServer> onChange;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final texTheme = context.appTextTheme;
    return Dialog(
        backgroundColor: colorScheme.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.hardEdge,
        child: Container(
            constraints: BoxConstraints(
              maxHeight: context.height * 0.4,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: colorScheme.background,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.hGap12,
                Center(
                  child: Text(
                    "Thay đổi server khi xem lỗi",
                    style: texTheme.titleMedium,
                  ),
                ),
                Gaps.hGap16,
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: servers
                      .map((e) => ServerCard(
                          server: e,
                          onTap: () {
                            if (current.data != e.data) {
                              onChange.call(e);
                            }
                            Navigator.pop(context);
                          },
                          isSelected: current.data == e.data))
                      .toList(),
                ),
                Gaps.hGap16,
              ],
            )));
  }
}

class ServerCard extends StatelessWidget {
  const ServerCard(
      {super.key,
      required this.server,
      required this.onTap,
      required this.isSelected});
  final MovieServer server;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: colorScheme.surface),
            color: isSelected ? colorScheme.primary : null),
        child: Text(server.name),
      ),
    );
  }
}
