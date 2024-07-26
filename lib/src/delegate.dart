import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_mvc/flutter_mvc.dart';

import 'navigator.dart';
import 'parser/map_parser.dart';
import 'parser/parser.dart';
import 'route_map/base.dart';
import 'route_map/basic.dart';
import 'route_map/map_data/uri.dart';
import 'route_operate.dart';
import 'router/basic.dart';
import 'router/page.dart';
import 'router/path.dart';
import 'router/router.dart';

class MvcRouterDelegate extends RouterDelegate<MvcRouterMapBase> with DependencyInjectionService, MvcRouterMixinMapParser, MvcBasicRouter, MvcPathRouter, MvcPageRouter, MvcRouter, ChangeNotifier {
  late final MvcRouterParser parser = getService<MvcRouterParser>();
  late MvcRouterMapBase rootRouteMap = MvcRouterBasicMap(
    [
      MvcRouterUriPath.fromUri(
        Uri.parse(
          WidgetsBinding.instance.platformDispatcher.defaultRouteName,
        ),
      ),
    ],
  );
  MvcNavigatorController? _rootNavigatorController;
  MvcNavigatorController? get navigatorController => _rootNavigatorController;

  @override
  Widget build(BuildContext context) {
    return Mvc<MvcNavigatorController, MvcRouterMapBase>(
      create: () {
        final controller = MvcNavigatorController();
        _rootNavigatorController = controller;
        return controller;
      },
      model: rootRouteMap,
    );
  }

  Future<T?> operate<T>(MvcRouteOperate operate) async {
    var result = await navigatorController?.operate<T>(operate);
    notifyListeners();
    return result;
  }

  @override
  get currentConfiguration => navigatorController?.routeStack;

  @override
  Future<void> setNewRoutePath(MvcRouterMapBase configuration) async {
    rootRouteMap = configuration;
    notifyListeners();
  }
}
