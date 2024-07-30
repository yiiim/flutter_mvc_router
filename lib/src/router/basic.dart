import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';
import 'package:flutter_mvc_router/src/delegate.dart';
import 'package:flutter_mvc_router/src/parser/map_parser.dart';
import 'package:flutter_mvc_router/src/route/route.dart';
import 'package:flutter_mvc_router/src/route_map/map_data/base.dart';
import 'package:flutter_mvc_router/src/route_operate.dart';
import 'package:flutter_mvc_router/src/route_stack.dart';

mixin MvcBasicRouter on DependencyInjectionService {
  MvcRouterDelegate get delegate;
  MvcRouteStack? get routeStack;
  MvcRouteStack get _currentRouteStack => routeStack ?? delegate.navigatorController!.routeStack!;
  GlobalKey<NavigatorState> get navigatorKey => _currentRouteStack.key;
  GlobalKey<NavigatorState> get topNavigatorKey => _currentRouteStack.topStack.key;

  MvcRouteBase get currentRoute => _currentRouteStack.currentRoute.route;
  bool get isCurrent {
    return _currentRouteStack.isCurrent;
  }

  bool canPop() => _currentRouteStack.canPop();
  bool canForward() => _currentRouteStack.canForward();

  Future<T?> _operate<T>(MvcRouteOperate operate) => _currentRouteStack.operate(operate);

  Future<T?> pushRoute<T>(MvcRouterMapPathBase route) {
    return _operate(MvcRouteOperatePush(route, router: getService<MvcRouterMapParser>()));
  }

  Future<bool> popRoute([dynamic result]) async {
    return await _operate(MvcRouteOperatePop(result)) ?? false;
  }

  void forwardRoute() {
    _operate(MvcRouteOperateForward());
  }

  Future<T?> pushRouteReplacement<T>(MvcRouterMapPathBase route, [dynamic result]) {
    return _operate(MvcRouteOperatePushReplacement(route, result: result, router: getService<MvcRouterMapParser>()));
  }

  Future<T?> pushRouteAndRemoveUntil<T>(MvcRouterMapPathBase route, bool Function(MvcRouterMapPathBase) predicate, [dynamic result]) {
    return _operate(MvcRouteOperatePushAndRemoveUntil(route, predicate, result: result, router: getService<MvcRouterMapParser>()));
  }

  void popRouteUntil(bool Function(MvcRouterMapPathBase) predicate) {
    _operate(MvcRouteOperatePopUntil(predicate));
  }

  void redirectRoute(MvcRouterMapPathBase route) {
    _operate(MvcRouteOperateRedirect(route, router: getService<MvcRouterMapParser>()));
  }
}
