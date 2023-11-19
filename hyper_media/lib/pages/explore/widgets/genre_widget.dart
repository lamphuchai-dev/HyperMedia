import 'package:flutter/material.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:hyper_media/app/route/routes_name.dart';
import 'package:hyper_media/data/models/models.dart';
import 'package:hyper_media/pages/genre/genre.dart';
import 'package:hyper_media/widgets/widget.dart';

typedef OnFetch = Future<List<Genre>> Function();

class GenreWidget extends StatefulWidget {
  const GenreWidget(
      {super.key, required this.onFetch, required this.extension});
  final OnFetch onFetch;

  final Extension extension;

  @override
  State<GenreWidget> createState() => _GenreWidgetState();
}

class _GenreWidgetState extends State<GenreWidget> {
  bool load = false;
  List<Genre> _listMap = [];
  void _onFetch() async {
    setState(() {
      load = true;
    });
    final tmp = await widget.onFetch.call();
    setState(() {
      _listMap = tmp;
    });

    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    _onFetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (load) {
      return const LoadingWidget();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.horizontalPadding),
      child: Wrap(
        children: _listMap
            .map((genre) => GenreCard(
                  genre: genre,
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.genre,
                        arguments:
                            GenreBookArg(genre: genre, extension: widget.extension));
                  },
                ))
            .toList(),
      ),
    );
  }
}
