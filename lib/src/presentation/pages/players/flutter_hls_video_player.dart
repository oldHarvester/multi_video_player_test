import 'package:flutter/material.dart';
import 'package:flutter_hls_video_player/flutter_hls_video_player/controller/flutter_hls_video_controls.dart';
import 'package:flutter_hls_video_player/flutter_hls_video_player/controller/flutter_hls_video_player_controller.dart';
import 'package:flutter_hls_video_player/flutter_hls_video_player/view/flutter_hls_video_player.dart';
import 'package:multi_video_player_test/src/presentation/widgets/players_info_provider.dart';

class FlutterHlsVideoPlayerPage extends StatefulWidget {
  const FlutterHlsVideoPlayerPage({super.key});

  @override
  State<FlutterHlsVideoPlayerPage> createState() =>
      _FlutterHlsVideoPlayerPageState();
}

class _FlutterHlsVideoPlayerPageState extends State<FlutterHlsVideoPlayerPage> {
  late final FlutterHLSVideoPlayerController _videoController;
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    final info = PlayersInfoProvider.of(context, createDependency: false);
    final url = info.url;
    _videoController = FlutterHLSVideoPlayerController();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        if (isDisposed) return;
        await _videoController.loadHlsVideo(url);
        await _videoController.play();
      },
    );
  }

  @override
  void dispose() {
    isDisposed = true;
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _videoController.stateStream,
      builder: (context, snapshot) {
        return FlutterHLSVideoPlayer(
          controller: _videoController,
          controls: FlutterHLSVideoPlayerControls(
            hideBackArrowWidget: true,
            onTapArrowBack: () {},
            onTapSetting: () {},
          ),
        );
      },
    );
  }
}
