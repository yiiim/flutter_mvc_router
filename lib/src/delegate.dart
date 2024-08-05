import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_mvc/flutter_mvc.dart';
import 'package:flutter_mvc_router/src/parser/map_parse_delegate.dart';
import 'package:flutter_mvc_router/src/route/route.dart';
import 'package:flutter_mvc_router/src/route_provider.dart';

import 'navigator.dart';
import 'parser/parser.dart';
import 'route_map/base.dart';
import 'route_map/basic.dart';
import 'route_map/map_data/uri.dart';
import 'route_operate.dart';
import 'router/basic.dart';
import 'router/page.dart';
import 'router/path.dart';
import 'router/router.dart';

class MvcRouterDelegate extends RouterDelegate<MvcRouterMapBase> with DependencyInjectionService, MvcRouterMixinMapParseDelegate, MvcBasicRouter, MvcPathRouter, MvcPageRouter, MvcRouter, ChangeNotifier {
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
  @override
  MvcNavigatorController get navigatorController {
    assert(_rootNavigatorController != null, "Root navigator controller is null");
    return _rootNavigatorController!;
  }

  @override
  Widget build(BuildContext context) {
    return Mvc(
      create: () {
        final controller = MvcNavigatorController(initialMap: rootRouteMap);
        _rootNavigatorController?.removeListener(notifyListeners);
        _rootNavigatorController = controller;
        _rootNavigatorController?.addListener(notifyListeners);
        return controller;
      },
    );
  }

  @override
  get currentConfiguration => _rootNavigatorController?.routeStack;

  Future<T?> operate<T>(MvcRouteOperate operate) async => await navigatorController.operate<T>(operate);

  @override
  Future<void> setNewRoutePath(MvcRouterMapBase configuration) async {
    rootRouteMap = configuration;
    _rootNavigatorController?.replaceMap(configuration);
    notifyListeners();
  }

  @override
  List<MvcRouteBase> get routes => getService<MvcRouteProvider>().routes();

  @override
  Future<bool> popRoute() async {
    navigatorController.routeStack?.topStack.pop();
    return true;
  }
}
