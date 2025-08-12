// ignore_for_file: constant_identifier_names

abstract final class PlayerConstants {
  static const amazingSpiderMan2012Hls =
      'https://vod02.splay.uz/hls13/The%20Amazing%20Spider-Man%202012/_tmp_/master.m3u8';

  static const amazingSpiderMan2014Hls =
      'https://vod02.splay.uz/hls13/The%20Amazing%20Spider-Man%202%202014/_tmp_/master.m3u8';

  static const bigBuckBunnyMp4 =
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

  static const bitmovinLicense = '768b6c13-2b4a-4347-a573-677fc07be71e	';
}

enum Players {
  video_player('video_player'),
  media_kit('media_kit'),
  appinio_video_player('appinio_video_player'),
  awesome_video_player('awesome_video_player'),
  bitmovin_player('bitmovin_player'),
  fijkplayer('fijkplayer'),
  flick_video_player('flick_video_player'),
  flutter_hls_video_player('flutter_hls_video_player'),
  flutter_playout('flutter_playout'),
  flutter_vlc_player('flutter_vlc_player'),
  lecle_yoyo_player('lecle_yoyo_player'),
  native_video_player('native_video_player'),
  omni_video_player('omni_video_player'),
  pod_player('pod_player'),
  video_js_player('video_js_player'),
  video_player_pip('video_player_pip'),
  video_view('video_view'),
  chewie('chewie'),
  ;

  const Players(this.packageName);
  final String packageName;
}
