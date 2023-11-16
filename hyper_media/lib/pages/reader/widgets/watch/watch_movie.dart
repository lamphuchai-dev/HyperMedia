// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hyper_media/app/extensions/index.dart';

import 'package:hyper_media/data/models/models.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class WatchMovie extends StatefulWidget {
  const WatchMovie({
    Key? key,
    required this.chapter,
  }) : super(key: key);
  final Chapter chapter;

  @override
  State<WatchMovie> createState() => _WatchMovieState();
}

class _WatchMovieState extends State<WatchMovie> {
  List<MovieModel> _listMovie = [];
  MovieModel? _movieModel;
  @override
  void initState() {
    if (widget.chapter.contentVideo != null &&
        widget.chapter.contentVideo!.isNotEmpty) {
      _listMovie = widget.chapter.contentVideo!
          .map<MovieModel>((e) => MovieModel.fromMap(e))
          .toList();
      _movieModel = _listMovie.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_movieModel == null) {
      return Container(
        alignment: Alignment.center,
        color: Colors.transparent,
        child: const Text("Lỗi load nội dung"),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _listMovie
                  .mapIndexed((index, element) => MovieCard(
                        index: index,
                        model: element,
                        isSelected: _movieModel!.data == element.data,
                        onTap: () {
                          setState(() {
                            _movieModel = element;
                          });
                        },
                      ))
                  .toList(),
            )),
      ),
      body: Stack(
        children: [
          const Positioned.fill(
              child: ColoredBox(
            color: Colors.transparent,
          )),
          Align(
              alignment: Alignment.center,
              child: switch (_movieModel!.type) {
                "html" => WatchMovieByHtml(
                    html: _movieModel!.data,
                  ),
                "iframe" => WatchMovieByIframe(movieModel: _movieModel!),
                "video" => WatchMovieByVideo(movieModel: _movieModel!),
                _ => const SizedBox()
              }),
        ],
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard(
      {super.key,
      required this.model,
      required this.onTap,
      required this.index,
      this.isSelected = false});
  final MovieModel model;
  final int index;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : colorScheme.surface,
            borderRadius: BorderRadius.circular(4)),
        child: Text("SV $index"),
      ),
    );
  }
}

class WatchMovieByHtml extends StatefulWidget {
  const WatchMovieByHtml({super.key, required this.html});
  final String html;

  @override
  State<WatchMovieByHtml> createState() => _WatchMovieByHtmlState();
}

class _WatchMovieByHtmlState extends State<WatchMovieByHtml> {
  final GlobalKey _webViewKey = GlobalKey();

  InAppWebViewController? _webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      useShouldOverrideUrlLoading: true, supportZoom: false);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: InAppWebView(
        key: _webViewKey,
        initialData: InAppWebViewInitialData(data: widget.html),
        initialSettings: settings,
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
      ),
    );
  }

  @override
  void dispose() {
    _webViewController?.dispose();
    super.dispose();
  }
}

class WatchMovieByIframe extends StatefulWidget {
  const WatchMovieByIframe({super.key, required this.movieModel});
  final MovieModel movieModel;

  @override
  State<WatchMovieByIframe> createState() => _WatchMovieByIframeState();
}

class _WatchMovieByIframeState extends State<WatchMovieByIframe> {
  final GlobalKey _webViewKey = GlobalKey();

  InAppWebViewController? _webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      useShouldOverrideUrlLoading: true, supportZoom: false);

  @override
  Widget build(BuildContext context) {
    final data =
        '''<iframe style="position: absolute;top: 0;left: 0;width: 100%;height: 100%;" frameborder="0" src="${widget.movieModel.data}" frameborder="0" scrolling="0" allowfullscreen></iframe>''';
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: InAppWebView(
        key: _webViewKey,
        initialData: InAppWebViewInitialData(data: data),
        initialSettings: settings,
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          var uri = navigationAction.request.url!;
          if (["about"].contains(uri.scheme)) {
            return NavigationActionPolicy.ALLOW;
          }
          if (widget.movieModel.regex != "" &&
              uri.toString().checkByRegExp(widget.movieModel.regex)) {
            return NavigationActionPolicy.ALLOW;
          }
          return NavigationActionPolicy.CANCEL;
        },
      ),
    );
  }

  @override
  void dispose() {
    _webViewController?.dispose();
    super.dispose();
  }
}

class WatchMovieByVideo extends StatefulWidget {
  const WatchMovieByVideo({super.key, required this.movieModel});
  final MovieModel movieModel;

  @override
  State<WatchMovieByVideo> createState() => _WatchMovieByVideoState();
}

class _WatchMovieByVideoState extends State<WatchMovieByVideo> {
  Player? _player;
  VideoController? _videoController;
  @override
  void initState() {
    _player = Player();
    _videoController = VideoController(_player!);
    open();
    super.initState();
  }

  void open() async {
    try {
      await _player!.open(Media(widget.movieModel.data));
    } catch (error) {
      _player?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 16 / 9.3,
        child: MaterialVideoControlsTheme(
          normal: const MaterialVideoControlsThemeData(
            volumeGesture: true,
            brightnessGesture: true,
            buttonBarButtonSize: 24.0,
            buttonBarButtonColor: Colors.white,
            topButtonBarMargin: EdgeInsets.only(top: 30),
          ),
          fullscreen: const MaterialVideoControlsThemeData(
            seekBarMargin: EdgeInsets.only(bottom: 60, left: 16, right: 16),
          ),
          child: Video(
            aspectRatio: 16 / 9,
            controller: _videoController!,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }
}

class MovieModel {
  final String data;
  final String type;
  final String regex;
  MovieModel({
    required this.data,
    required this.type,
    required this.regex,
  });

  MovieModel copyWith({
    String? data,
    String? type,
    String? regex,
  }) {
    return MovieModel(
      data: data ?? this.data,
      type: type ?? this.type,
      regex: regex ?? this.regex,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data,
      'type': type,
      'regex': regex,
    };
  }

  factory MovieModel.fromMap(Map<String, dynamic> map) {
    return MovieModel(
      data: map['data'] ?? "",
      type: map['type'] ?? "",
      regex: map['regex'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieModel.fromJson(String source) =>
      MovieModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MovieModel(data: $data, type: $type, regex: $regex)';

  @override
  bool operator ==(covariant MovieModel other) {
    if (identical(this, other)) return true;

    return other.data == data && other.type == type && other.regex == regex;
  }

  @override
  int get hashCode => data.hashCode ^ type.hashCode ^ regex.hashCode;
}
