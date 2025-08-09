import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_video_player_test/src/config/router/routes.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    final router = GoRouter(
      routes: $appRoutes,
    );
    ref.onDispose(
      () {
        return router.dispose();
      },
    );
    return router;
  },
);
