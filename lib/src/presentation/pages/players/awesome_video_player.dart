// import 'package:awesome_video_player/awesome_video_player.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';

import '../../widgets/players_info_provider.dart';

class AwesomeVideoPlayerPage extends StatefulWidget {
  const AwesomeVideoPlayerPage({super.key});

  @override
  State<AwesomeVideoPlayerPage> createState() => _AwesomeVideoPlayerPageState();
}

class _AwesomeVideoPlayerPageState extends State<AwesomeVideoPlayerPage> {
  late final BetterPlayerController _controller;

  @override
  void initState() {
    super.initState();
    final info = PlayersInfoProvider.of(context, createDependency: false);
    final url = info.url;
    _controller = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        autoDispose: true,
      ),
      betterPlayerDataSource: BetterPlayerDataSource.network(
        url,
        useAsmsAudioTracks: true,
        useAsmsSubtitles: true,
        useAsmsTracks: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BetterPlayer(
      controller: _controller,
    );
  }
}
