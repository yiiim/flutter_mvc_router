import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';
import 'package:flutter_mvc_router/src/route_entity.dart';

import '../../../flutter_mvc_router.dart';

mixin MvcBasicRouter on DependencyInjectionService {
  late final MvcNavigatorController? _navigator = tryGetService();
  late final MvcRouterDelegate _delegate = getService<MvcRouterDelegate>();
  MvcRouteStack get _currentRouteStack => _navigator?.model ?? _delegate.routeStack!;

  GlobalKey<NavigatorState> get navigatorKey => _navigator?.model.navigatorKey ?? _delegate.routeStack!.navigatorKey;

  bool get isCurrent {
    return _currentRouteStack.isCurrent && _currentRouteStack.currentRoute == getService<MvcRouteEntity>();
  }

  bool canPop() => _navigator?.canPop() ?? _delegate.canPop();
  bool canForward() => _navigator?.canForward() ?? _delegate.canForward();

  Future<T?> _operate<T>(MvcRouteOperate operate) {
    if (_navigator != null) {
      return _navigator!.operate(operate);
    }
    return _delegate.operate(operate);
  }

  Future<T?> pushRoute<T>(MvcRouteMapDataBase route) {
    return _operate(MvcRouteOperatePush(route, router: getService<MvcRouter>()));
  }

  void popRoute([dynamic result]) {
    _operate(MvcRouteOperatePop(result));
  }

  void forwardRoute() {
    _operate(MvcRouteOperateForward());
  }

  Future<T?> pushRouteReplacement<T>(MvcRouteMapDataBase route, [dynamic result]) {
    return _operate(MvcRouteOperatePushReplacement(route, result: result, router: getService<MvcRouter>()));
  }

  Future<T?> pushRouteAndRemoveUntil<T>(MvcRouteMapDataBase route, bool Function(MvcRouteMapDataBase) predicate, [dynamic result]) {
    return _operate(MvcRouteOperatePushAndRemoveUntil(route, predicate, result: result, router: getService<MvcRouter>()));
  }

  void popRouteUntil(bool Function(MvcRouteMapDataBase) predicate) {
    _operate(MvcRouteOperatePopUntil(predicate));
  }

  void redirectRoute(MvcRouteMapDataBase route) {
    _operate(MvcRouteOperateRedirect(route, router: getService<MvcRouter>()));
  }
}
