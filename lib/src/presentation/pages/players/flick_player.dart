import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../widgets/players_info_provider.dart';

class FlickPlayerPage extends StatefulWidget {
  const FlickPlayerPage({super.key});

  @override
  State<FlickPlayerPage> createState() => _FlickPlayerPageState();
}

class _FlickPlayerPageState extends State<FlickPlayerPage> {
  late final VideoPlayerController _controller;
  late final FlickManager _flickManager;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final info = PlayersInfoProvider.of(context, createDependency: false);
    _controller = VideoPlayerController.networkUrl(Uri.parse(info.url));
    _flickManager = FlickManager(videoPlayerController: _controller);
    await _controller.initialize();
    await _controller.play();
  }

  @override
  void dispose() {
    _flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder(
        valueListenable: _controller,
        builder: (context, videoValue, _) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              FittedBox(
                fit: BoxFit.fitWidth,
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  width: videoValue.size.width,
                  height: videoValue.size.height,
                  child: FlickVideoPlayer(
                    flickManager: _flickManager,

                  ),
                ),
              ),
              SizedBox(
                height: 10,
                child: VideoScrubber(
                  controller: _controller,
                  child: VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
