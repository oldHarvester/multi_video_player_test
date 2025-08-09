import 'package:flutter/material.dart';
import 'package:multi_video_player_test/src/presentation/widgets/players_info_provider.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({
    super.key,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final info = PlayersInfoProvider.of(context, createDependency: false);
    _controller = VideoPlayerController.networkUrl(Uri.parse(info.url));
    await _controller.initialize();
    await _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
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
                  child: VideoPlayer(_controller),
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
