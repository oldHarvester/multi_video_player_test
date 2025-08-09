import 'package:flutter/widgets.dart';

class PlayersInfoProvider extends InheritedWidget {
  const PlayersInfoProvider({
    super.key,
    required super.child,
    required this.url,
  });

  final String url;

  static PlayersInfoProvider of(
    BuildContext context, {
    bool createDependency = true,
  }) {
    if (createDependency) {
      return context.dependOnInheritedWidgetOfExactType()!;
    }
    return context.getInheritedWidgetOfExactType()!;
  }

  @override
  bool updateShouldNotify(covariant PlayersInfoProvider oldWidget) {
    return oldWidget.url != url;
  }
}
