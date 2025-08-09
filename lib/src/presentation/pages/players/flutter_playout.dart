import 'package:flutter/material.dart';
import 'package:flutter_playout/player_state.dart';
import 'package:flutter_playout/video.dart';
import 'package:multi_video_player_test/src/presentation/widgets/players_info_provider.dart';

class FlutterPlayoutPage extends StatefulWidget {
  const FlutterPlayoutPage({super.key});

  @override
  State<FlutterPlayoutPage> createState() => _FlutterPlayoutPageState();
}

class _FlutterPlayoutPageState extends State<FlutterPlayoutPage> {
  @override
  Widget build(BuildContext context) {
    final info = PlayersInfoProvider.of(context);
    return Center(
      child: Video(
        autoPlay: true,
        desiredState: PlayerState.PLAYING,
        onViewCreated: () {},
        showControls: true,
        url: info.url,
      ),
    );
  }
}
