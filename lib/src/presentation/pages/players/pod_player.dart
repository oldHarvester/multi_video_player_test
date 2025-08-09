import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

import '../../widgets/players_info_provider.dart';

class PodPlayerPage extends StatefulWidget {
  const PodPlayerPage({super.key});

  @override
  State<PodPlayerPage> createState() => _PodPlayerPageState();
}

class _PodPlayerPageState extends State<PodPlayerPage> {
  late final PodPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    final info = PlayersInfoProvider.of(context, createDependency: false);
    _controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.network(info.url),
    );
    await _controller.initialise();
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return PodVideoPlayer(
      controller: _controller,
    );
  }
}
