import 'dart:async';

import 'package:flutter_mvc_router/src/route/match_location/match_location.dart';
import 'package:flutter_mvc_router/src/route/route.dart';
import 'package:flutter_mvc_router/src/route_map/base.dart';

import '../parser/context.dart';
import '../parser/result.dart';
import '../route_map/map_data/base.dart';

abstract class MvcRouterMapParseDelegate {
  FutureOr<MvcRouterParseContext> createParseContext(MvcRouterMapBase map, MvcRouterMapPathBase mapData, {bool restore = false});
  FutureOr<MvcRouterMapPathParseResult> parseRoute(MvcRouterParseContext context, {bool restore = false});
}

mixin MvcRouterMixinMapParseDelegate implements MvcRouterMapParseDelegate {
  List<MvcRouteBase> get routes;

  @override
  FutureOr<MvcRouterParseContext> createParseContext(
    MvcRouterMapBase map,
    MvcRouterMapPathBase mapData, {
    bool restore = false,
  }) {
    return MvcRouterParseContext(
      map: map,
      mapData: mapData,
      restore: restore,
    )..availableRoutes = routes;
  }

  @override
  FutureOr<MvcRouterMapPathParseResult> parseRoute(MvcRouterParseContext context, {bool restore = false}) async {
    for (var element in context.availableRoutes) {
      final result = await _parseRoute(context, element);
      if (result != null) {
        return result;
      }
    }
    return MvcRouterMapPathParseResult(
      route: context.notFoundRoute ?? MvcNotFoundRoute(),
      mapData: context.mapData,
      location: MvcRouteAllMatchLocation(),
    );
  }

  FutureOr<MvcRouterMapPathParseResult?> _parseRoute(MvcRouterParseContext context, MvcRouteBase route) async {
    final location = route.match(context);
    if (location != null) {
      return MvcRouterMapPathParseResult(
        mapData: context.mapData,
        route: route,
        location: location,
        remainingPath: location.consumeMatchedLocation(context.mapData),
        key: context.mapData.key,
      );
    }
    return null;
  }
}
