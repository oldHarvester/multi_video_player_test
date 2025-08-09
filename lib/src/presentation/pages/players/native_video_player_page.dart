import 'package:flutter/material.dart';
import 'package:multi_video_player_test/src/presentation/widgets/players_info_provider.dart';
import 'package:native_video_player/native_video_player.dart';

class NativeVideoPlayerPage extends StatefulWidget {
  const NativeVideoPlayerPage({super.key});

  @override
  State<NativeVideoPlayerPage> createState() => _NativeVideoPlayerPageState();
}

class _NativeVideoPlayerPageState extends State<NativeVideoPlayerPage> {
  @override
  Widget build(BuildContext context) {
    final info = PlayersInfoProvider.of(context);
    final url = info.url;
    return NativeVideoPlayerView(
      onViewReady: (controller) async {
        await controller.loadVideo(
          VideoSource(
            path: url,
            type: VideoSourceType.network,
          ),
        );
        await controller.play();
      },
    );
  }
}
