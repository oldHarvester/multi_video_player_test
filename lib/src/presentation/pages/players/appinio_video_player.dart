import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../widgets/players_info_provider.dart';

class AppinioVideoPlayerPage extends StatefulWidget {
  const AppinioVideoPlayerPage({super.key});

  @override
  State<AppinioVideoPlayerPage> createState() => _AppinioVideoPlayerPageState();
}

class _AppinioVideoPlayerPageState extends State<AppinioVideoPlayerPage> {
  late final VideoPlayerController _controller;
  late final CustomVideoPlayerController _customController;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final info = PlayersInfoProvider.of(context, createDependency: false);
    _controller = VideoPlayerController.networkUrl(Uri.parse(info.url));
    _customController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _controller,
    );
    await _controller.initialize();
    await _controller.play();
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder(
        valueListenable: _controller,
        builder: (context, videoValue, _) {
          return FittedBox(
            fit: BoxFit.fitWidth,
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              width: videoValue.size.width,
              height: videoValue.size.height,
              child: CustomVideoPlayer(
                customVideoPlayerController: _customController,
              ),
            ),
          );
        },
      ),
    );
  }
}
