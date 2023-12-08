part of '../view/watch_movie_view.dart';


class WatchMovieByVideo extends StatefulWidget {
  const WatchMovieByVideo({super.key, required this.server});
  final MovieServer server;

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
    _player!.open(Media(Uri.parse(widget.server.data).toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialVideoControlsTheme(
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
    );
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }
}
