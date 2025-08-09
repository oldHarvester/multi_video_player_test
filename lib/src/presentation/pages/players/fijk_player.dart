import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:multi_video_player_test/src/presentation/widgets/players_info_provider.dart';

class FijkPlayerPage extends StatefulWidget {
  const FijkPlayerPage({super.key});

  @override
  State<FijkPlayerPage> createState() => _FijkPlayerPageState();
}

class _FijkPlayerPageState extends State<FijkPlayerPage> {
  final FijkPlayer _player = FijkPlayer();

  @override
  void initState() {
    super.initState();
    super.initState();
    _player.setOption(FijkOption.hostCategory, "enable-snapshot", 1);
    _player.setOption(FijkOption.playerCategory, "mediacodec-all-videos", 1);
    startPlay();
  }

  Future<void> startPlay() async {
    final info = PlayersInfoProvider.of(context, createDependency: false);
    await _player.setOption(FijkOption.hostCategory, "request-screen-on", 1);
    await _player.setOption(FijkOption.hostCategory, "request-audio-focus", 1);
    await _player.setDataSource(info.url, autoPlay: true).catchError((e) {
      print("setDataSource error: $e");
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FijkView(
        player: _player,
        fit: FijkFit.fitWidth,
      ),
    );
  }
}
