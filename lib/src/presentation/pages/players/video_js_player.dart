import 'package:flutter/material.dart';
import 'package:video_js_player/video_js_player.dart';

import '../../widgets/players_info_provider.dart';

class VideoJsPlayerPage extends StatefulWidget {
  const VideoJsPlayerPage({super.key});

  @override
  State<VideoJsPlayerPage> createState() => _VideoJsPlayerPageState();
}

class _VideoJsPlayerPageState extends State<VideoJsPlayerPage> {
  late final WebVideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future<void> _initialize() async {
    final info = PlayersInfoProvider.of(context, createDependency: false);
    final url = info.url;
    _controller = WebVideoPlayerController();
    _controller.load(
      WebPlayerSource.video(
        url,
        WebPlayerVideoSourceType.iframe,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebPlayerBuilder(
      player: WebPlayer(
        controlsBuilder: (context, controller) {
          return SizedBox();
        },
        controller: _controller,
      ),
      builder: (context, player) {
        return Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: player,
          ),
        );
      },
    );
  }
}
