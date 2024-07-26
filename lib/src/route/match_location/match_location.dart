import 'package:flutter_mvc_router/src/route_map/map_data/base.dart';
import 'package:flutter_mvc_router/src/route_map/map_data/empty.dart';

abstract class MvcRouteMatchedLocation {
  MvcRouterMapPathBase consumeMatchedLocation(MvcRouterMapPathBase path);
}

class MvcRouteAnyMatchLocation extends MvcRouteMatchedLocation {
  @override
  MvcRouterMapPathBase consumeMatchedLocation(MvcRouterMapPathBase path) {
    return path;
  }
}

class MvcRouteAllMatchLocation extends MvcRouteMatchedLocation {
  @override
  MvcRouterMapPathBase consumeMatchedLocation(MvcRouterMapPathBase path) {
    return MvcRouterEmptyPath();
  }
}
