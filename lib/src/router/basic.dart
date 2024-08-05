import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mvc_router/src/delegate.dart';
import 'package:flutter_mvc_router/src/navigator.dart';
import 'package:flutter_mvc_router/src/route/route.dart';
import 'package:flutter_mvc_router/src/route_map/map_data/base.dart';
import 'package:flutter_mvc_router/src/route_operate.dart';
import 'package:flutter_mvc_router/src/route_stack.dart';

mixin MvcBasicRouter {
  MvcRouterDelegate get delegate;
  MvcNavigatorController? get navigatorController;
  MvcRouteStack get _currentRouteStack => navigatorController?.routeStack ?? delegate.navigatorController.routeStack!;
  GlobalKey<NavigatorState> get navigatorKey => _currentRouteStack.key;
  GlobalKey<NavigatorState> get topNavigatorKey => _currentRouteStack.topStack.key;

  MvcRouteBase get currentRoute => _currentRouteStack.currentRoute.route;
  bool get isCurrent {
    return _currentRouteStack.isCurrent;
  }

  bool canPop() => _currentRouteStack.canPop();
  bool canForward() => _currentRouteStack.canForward();

  Future<T?> _operate<T>(MvcRouteOperate operate) => (navigatorController ?? delegate.navigatorController).operate(operate);

  Future<T?> pushRoute<T>(MvcRouterMapPathBase route) {
    return _operate(MvcRouteOperatePush(route));
  }

  Future<bool> pop([dynamic result]) async {
    return await _operate(MvcRouteOperatePop(result)) ?? false;
  }

  void forwardRoute() {
    _operate(MvcRouteOperateForward());
  }

  Future<T?> pushRouteReplacement<T>(MvcRouterMapPathBase route, [dynamic result]) {
    return _operate(MvcRouteOperatePushReplacement(route, result: result));
  }

  Future<T?> pushRouteAndRemoveUntil<T>(MvcRouterMapPathBase route, bool Function(MvcRouterMapPathBase) predicate, [dynamic result]) {
    return _operate(MvcRouteOperatePushAndRemoveUntil(route, predicate, result: result));
  }

  void popRouteUntil(bool Function(MvcRouterMapPathBase) predicate) {
    _operate(MvcRouteOperatePopUntil(predicate));
  }

  void redirectRoute(MvcRouterMapPathBase route) {
    _operate(MvcRouteOperateRedirect(route));
  }
}
