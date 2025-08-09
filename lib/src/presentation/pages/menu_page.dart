import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:multi_video_player_test/src/presentation/pages/players/media_kit.dart';
import 'package:multi_video_player_test/src/presentation/pages/players/video_player.dart';
import 'package:multi_video_player_test/src/presentation/widgets/players_info_provider.dart';
import 'package:multi_video_player_test/src/presentation/widgets/primary_overlay/primary_overlay.dart';

import '../../config/player_constants.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late final PageController _pageController;
  late final ValueNotifier<int> _page;
  final ValueNotifier<bool> _opened = ValueNotifier(true);
  final ValueNotifier<String> _playerUrl =
      ValueNotifier(PlayerConstants.amazingSpiderMan2012Hls);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );

    _page = ValueNotifier(_pageController.initialPage);
  }

  @override
  void dispose() {
    _page.dispose();
    _pageController.dispose();
    _opened.dispose();
    _playerUrl.dispose();
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
                          return PrimaryOverlay(
                            enable: true,
                            targetAnchor: Alignment.topRight,
                            followerAnchor: Alignment.topLeft,
                            targetBuilder: (context, data) {
                              return SafeArea(
                                child: GestureDetector(
                                  onTap: () {
                                    _opened.value = !_opened.value;
                                  },
                                  behavior: HitTestBehavior.translucent,
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      border: border,
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
                              return AnimatedSize(
                                duration: Duration(milliseconds: 600),
                                curve: Curves.ease,
                                child: SizedBox(
                                  width: opened ? barWidth : 0,
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
                                                    _pageController
                                                        .animateToPage(
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
                              );
                            },
                          );
                        },
                      ),
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(border: border),
                          child: SafeArea(
                            child: Column(
                              children: [
                                ValueListenableBuilder(
                                  valueListenable: _page,
                                  builder: (context, value, child) {
                                    final player = players[value];
                                    return Text(player.packageName);
                                  },
                                ),
                                const Gap(40),
                                Expanded(
                                  child: PageView.builder(
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
                                          _ => SizedBox(),
                                        },
                                      );
                                    },
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
          }),
    );
  }
}
