import 'package:flutter/material.dart';

import 'route/route.dart';
import 'route_map/map_data/base.dart';

class MvcRouteInfo {
  const MvcRouteInfo({
    required this.route,
    required this.routeData,
    this.child,
  });
  final MvcRouteBase route;
  final MvcRouterMapPathBase routeData;
  final Widget? child;

  T? args<T>() => routeData.args<T>();
  T? argsForKey<T>(String key) => routeData.argsForKey<T>(key);
}
