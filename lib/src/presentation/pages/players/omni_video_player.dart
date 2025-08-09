import 'package:flutter/material.dart';
import 'package:omni_video_player/omni_video_player.dart';

import '../../widgets/players_info_provider.dart';

class OmniVideoPlayerPage extends StatefulWidget {
  const OmniVideoPlayerPage({super.key});

  @override
  State<OmniVideoPlayerPage> createState() => _OmniVideoPlayerPageState();
}

class _OmniVideoPlayerPageState extends State<OmniVideoPlayerPage> {
  @override
  Widget build(BuildContext context) {
    final info = PlayersInfoProvider.of(context);
    final url = info.url;

    return Stack(
      fit: StackFit.expand,
      children: [
        OmniVideoPlayer(
          callbacks: VideoPlayerCallbacks(
            onControllerCreated: (controller) {},
          ),

          // Minimal configuration: playing a YouTube video.
          options: VideoPlayerConfiguration(
            videoSourceConfiguration: VideoSourceConfiguration.network(
              videoUrl: Uri.parse(url),
              // preferredQualities: [
              //   OmniVideoQuality.high720,
              //   OmniVideoQuality.low144,
              // ],
              // availableQualities: [
              //   OmniVideoQuality.high1080,
              //   OmniVideoQuality.high720,
              //   OmniVideoQuality.low144,
              // ],
            ),
            playerTheme: OmniVideoPlayerThemeData().copyWith(
              icons: VideoPlayerIconTheme().copyWith(error: Icons.warning),
              overlays: VideoPlayerOverlayTheme().copyWith(
                backgroundColor: Colors.white,
                alpha: 25,
              ),
            ),
            playerUIVisibilityOptions: PlayerUIVisibilityOptions().copyWith(
              showMuteUnMuteButton: true,
              showFullScreenButton: true,
              useSafeAreaForBottomControls: true,
            ),
            customPlayerWidgets: CustomPlayerWidgets().copyWith(
              thumbnailFit: BoxFit.fitWidth,
            ),
          ),
        ),
      ],
    );
  }
}
