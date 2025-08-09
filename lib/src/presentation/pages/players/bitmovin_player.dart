import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:bitmovin_player/bitmovin_player.dart';
import 'package:flutter/material.dart';
import 'package:multi_video_player_test/src/config/player_constants.dart';
import 'package:multi_video_player_test/src/presentation/widgets/players_info_provider.dart';

class BitmovinPlayerPage extends StatefulWidget {
  const BitmovinPlayerPage({super.key});

  @override
  State<BitmovinPlayerPage> createState() => _BitmovinPlayerPageState();
}

class _BitmovinPlayerPageState extends State<BitmovinPlayerPage> {
  final _playerViewKey = GlobalKey<PlayerViewState>();
  late final _sourceConfig = SourceConfig(
    url: PlayersInfoProvider.of(context, createDependency: false).url,
    type: SourceType.hls,
  );
  final _player = Player(
    config: const PlayerConfig(
      key: PlayerConstants.bitmovinLicense,
      remoteControlConfig: RemoteControlConfig(isCastEnabled: false),
    ),
  );
  final _playerViewConfig = const PlayerViewConfig(
    pictureInPictureConfig: PictureInPictureConfig(
      isEnabled: true,
      shouldEnterOnBackground: true,
    ),
  );
  bool _isInPictureInPicture = false;

  void _onPictureInPictureEnterEvent(Event event) {
    setState(() {
      _isInPictureInPicture = true;
    });
  }

  void _onPictureInPictureExitEvent(Event event) {
    setState(() {
      _isInPictureInPicture = false;
    });
  }

  @override
  void initState() {
    setupAudioSession();
    _player.loadSourceConfig(_sourceConfig);
    super.initState();
  }

  Future<void> setupAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  // Since PiP on Android is basically just the whole activity fitted in a small
  // floating window, we don't want to display the whole scaffold
  bool get renderOnlyPlayerView => Platform.isAndroid && _isInPictureInPicture;

  @override
  Widget build(BuildContext context) {
    final playerView = PlayerView(
      player: _player,
      key: _playerViewKey,
      playerViewConfig: _playerViewConfig,
      onPictureInPictureEnter: _onPictureInPictureEnterEvent,
      onPictureInPictureEntered: (p0) {
        print('enter pip');
      },
      onPictureInPictureExit: _onPictureInPictureExitEvent,
      onPictureInPictureExited: (p0) {
        print('on pip exited');
      },
    );
    if (renderOnlyPlayerView) {
      return playerView;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture-in-Picture'),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: playerView,
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10, right: 5),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                  ),
                  onPressed: () {
                    _playerViewKey.currentState?.pictureInPicture
                        .enterPictureInPicture();
                  },
                  child: const Text('Enter PiP'),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                  ),
                  onPressed: () {
                    _playerViewKey.currentState?.pictureInPicture
                        .exitPictureInPicture();
                  },
                  child: const Text('Exit PiP'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
