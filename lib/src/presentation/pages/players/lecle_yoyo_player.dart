import 'package:flutter/material.dart';
import 'package:lecle_yoyo_player/lecle_yoyo_player.dart';

import '../../widgets/players_info_provider.dart';

class LecleYoyoPlayerPage extends StatefulWidget {
  const LecleYoyoPlayerPage({super.key});

  @override
  State<LecleYoyoPlayerPage> createState() => _LecleYoyoPlayerPageState();
}

class _LecleYoyoPlayerPageState extends State<LecleYoyoPlayerPage> {
  @override
  Widget build(BuildContext context) {
    final info = PlayersInfoProvider.of(context);
    return YoYoPlayer(
      url: info.url,
      aspectRatio: 16 / 9,
      autoPlayVideoAfterInit: true,
    );
  }
}
