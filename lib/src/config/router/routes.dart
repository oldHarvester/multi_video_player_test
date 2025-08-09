import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/pages/menu_page.dart';

part 'routes.g.dart';

@TypedGoRoute<MenuRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[],
)
class MenuRoute extends GoRouteData with _$MenuRoute {
  const MenuRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MenuPage();
  }
}
