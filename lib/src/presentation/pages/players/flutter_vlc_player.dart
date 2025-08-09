import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:multi_video_player_test/src/presentation/widgets/players_info_provider.dart';

class FlutterVlcPlayer extends StatefulWidget {
  const FlutterVlcPlayer({super.key});

  @override
  State<FlutterVlcPlayer> createState() => _FlutterVlcPlayerState();
}

class _FlutterVlcPlayerState extends State<FlutterVlcPlayer> {
  late final VlcPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future<void> _initialize() async {
    final info = PlayersInfoProvider.of(context, createDependency: false);
    final url = info.url;
    _controller = VlcPlayerController.network(
      url,
      hwAcc: HwAcc.full,
      options: VlcPlayerOptions(),
    );
    await _controller.initialize();
    await _controller.play();
  }

  @override
  void dispose() async {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VlcPlayer(
          virtualDisplay: true,
          aspectRatio: 16 / 9,
          controller: _controller,
          placeholder: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
