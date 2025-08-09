import 'package:flutter/material.dart';
import 'package:multi_video_player_test/src/presentation/pages/players/appinio_video_player.dart';
import 'package:multi_video_player_test/src/presentation/pages/players/media_kit.dart';
import 'package:multi_video_player_test/src/presentation/pages/players/video_player.dart';
import 'package:multi_video_player_test/src/presentation/widgets/players_info_provider.dart';
import 'package:multi_video_player_test/src/presentation/widgets/primary_overlay/primary_overlay.dart';

import '../../config/player_constants.dart';
import 'players/awesome_video_player.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
  late final PageController _pageController;
  late final ValueNotifier<int> _page;
  final ValueNotifier<bool> _opened = ValueNotifier(true);
  final ValueNotifier<String> _playerUrl =
      ValueNotifier(PlayerConstants.amazingSpiderMan2012Hls);
  late final AnimationController _sizeController;
  late final Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
    _sizeController = AnimationController(
      vsync: this,
      value: _opened.value ? 1 : 0,
      duration: Duration(milliseconds: 600),
    );
    _sizeAnimation =
        CurvedAnimation(parent: _sizeController, curve: Curves.ease);
    _page = ValueNotifier(_pageController.initialPage);
  }

  void toggleBar() {
    _opened.value = !_opened.value;
    _sizeController.animateTo(_opened.value ? 1 : 0);
  }

  @override
  void dispose() {
    _page.dispose();
    _pageController.dispose();
    _opened.dispose();
    _playerUrl.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: _playerUrl,
        builder: (context, url, _) {
          return PlayersInfoProvider(
            url: url,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final players = Players.values;
                final maxWidth = constraints.maxWidth;
                final barWidth = maxWidth * 0.3;
                final border = Border.all(
                  width: 0.1,
                );
                return Row(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _opened,
                      builder: (context, opened, child) {
                        return ValueListenableBuilder(
                          valueListenable: _sizeController,
                          builder: (context, value, menuListView) {
                            return PrimaryOverlay(
                              key: ValueKey(value),
                              enable: true,
                              targetAnchor: Alignment.topRight,
                              followerAnchor: Alignment.topLeft,
                              targetBuilder: (context, data) {
                                return SafeArea(
                                  child: GestureDetector(
                                    onTap: () {
                                      toggleBar();
                                    },
                                    behavior: HitTestBehavior.translucent,
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: border,
                                        color: Colors.white,
                                      ),
                                      child: Icon(
                                        opened
                                            ? Icons.arrow_left
                                            : Icons.arrow_right,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              builder: (context, data) {
                                return menuListView!;
                              },
                            );
                          },
                          child: SizeTransition(
                            axis: Axis.horizontal,
                            sizeFactor: _sizeAnimation,
                            child: SizedBox(
                              width: barWidth,
                              child: CustomScrollView(
                                slivers: [
                                  SliverPadding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
                                    sliver: SliverSafeArea(
                                      sliver: SliverList.separated(
                                        itemCount: players.length,
                                        itemBuilder: (context, index) {
                                          final player = players[index];
                                          return Material(
                                            type: MaterialType.transparency,
                                            child: InkWell(
                                              onTap: () {
                                                _pageController.animateToPage(
                                                  index,
                                                  duration: Duration(
                                                    milliseconds: 400,
                                                  ),
                                                  curve: Curves.ease,
                                                );
                                              },
                                              child: Ink(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  player.packageName,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              border: border,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: border,
                          color: Colors.black87,
                        ),
                        child: SafeArea(
                          child: Column(
                            children: [
                              Expanded(
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    PageView.builder(
                                      onPageChanged: (value) {
                                        _page.value = value;
                                      },
                                      controller: _pageController,
                                      scrollDirection: Axis.vertical,
                                      itemCount: players.length,
                                      itemBuilder: (context, index) {
                                        final player = players[index];
                                        return KeyedSubtree(
                                          key: ValueKey(url),
                                          child: switch (player) {
                                            Players.video_player =>
                                              VideoPlayerPage(),
                                            Players.media_kit => MediakitPage(),
                                            Players.appinio_video_player =>
                                              AppinioVideoPlayerPage(),
                                            Players.awesome_video_player =>
                                              AwesomeVideoPlayerPage(),
                                            _ => SizedBox(),
                                          },
                                        );
                                      },
                                    ),
                                    Positioned(
                                      top: 50,
                                      left: 0,
                                      right: 0,
                                      child: ValueListenableBuilder(
                                        valueListenable: _playerUrl,
                                        builder: (context, url, _) {
                                          return ValueListenableBuilder(
                                            valueListenable: _page,
                                            builder: (context, value, child) {
                                              final player = players[value];
                                              return Column(
                                                children: [
                                                  Text(
                                                    player.packageName,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    url,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
