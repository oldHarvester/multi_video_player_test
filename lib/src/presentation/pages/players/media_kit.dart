import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:multi_video_player_test/src/presentation/widgets/players_info_provider.dart';

class MediakitPage extends StatefulWidget {
  const MediakitPage({super.key});

  @override
  State<MediakitPage> createState() => _MediakitPageState();
}

class _MediakitPageState extends State<MediakitPage> {
  final Player _player = Player(
    configuration: PlayerConfiguration(),
  );
  late final VideoController _videoController;

  @override
  void initState() {
    super.initState();
    final playerinfo = PlayersInfoProvider.of(
      context,
      createDependency: false,
    );
    _videoController = VideoController(_player);
    _player.open(Media(playerinfo.url));
  }

  @override
  Widget build(BuildContext context) {
    return Video(
      controller: _videoController,
      fit: BoxFit.fitWidth,
    );
  }
}
