import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:multi_video_player_test/src/config/router/router.dart';

void main() {
  MediaKit.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, child) {
          final router = ref.watch(routerProvider);
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
