import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_mvc/flutter_mvc.dart';
import 'package:flutter_mvc_router/flutter_mvc_router.dart';

class MvcRouterDelegate extends RouterDelegate<MvcRouteStack> with DependencyInjectionService, ChangeNotifier {
  late final MvcRouterParser parser = getService<MvcRouterParser>();
  late final MvcRouteMapBase initialRouteMap = getService<MvcRouteProvider>().initialRouteMap();
  MvcRouteStack? routeStack;

  bool canPop() => routeStack?.canPop() ?? false;
  bool canForward() => routeStack?.canForward() ?? false;

  void _setRouteStack(MvcRouteStack stack) {
    routeStack?.removeListener(notifyListeners);
    stack.addListener(notifyListeners);
    routeStack = stack;
  }

  @override
  Widget build(BuildContext context) {
    if (routeStack == null) {
      return const SizedBox.shrink();
    }
    return Mvc<MvcNavigatorController, MvcRouteStack>(
      model: routeStack!..isRoot = true,
    );
  }

  Future<T?> operate<T>(MvcRouteOperate operate) async {
    var result = await routeStack?.operate<T>(operate);
    notifyListeners();
    return result;
  }

  @override
  get currentConfiguration => routeStack;

  @override
  Future<bool> popRoute() async => routeStack!.pop();

  @override
  Future<void> setNewRoutePath(MvcRouteStack configuration) async {
    _setRouteStack(configuration);
    notifyListeners();
  }
}
