// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hyper_media/app/constants/index.dart';

import 'package:hyper_media/app/extensions/index.dart';
import 'package:hyper_media/pages/reader/watch_movie/cubit/watch_movie_cubit.dart';

class SelectServerBottomSheet extends StatelessWidget {
  const SelectServerBottomSheet(
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
    return SizedBox(
      height: context.height * 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gaps.hGap16,
          const Text("Thay đổi sv khác nếu xem lỗi"),
          Gaps.hGap16,
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
            mainAxisSize: MainAxisSize.min,
            children: servers
                .map((e) => ListTile(
                      tileColor: e.name == current.name
                          ? context.colorScheme.primary
                          : null,
                      title: Text(e.name),
                      onTap: () {
                        onChange.call(e);
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
          )))
        ],
      ),
    );
  }
}
