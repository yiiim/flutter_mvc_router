import 'dart:async';

import 'package:flutter_mvc/flutter_mvc.dart';
import 'package:flutter_mvc_router/src/route/match_location/match_location.dart';
import 'package:flutter_mvc_router/src/route/route.dart';
import 'package:flutter_mvc_router/src/route_map/base.dart';
import 'package:flutter_mvc_router/src/route_provider.dart';

import '../parser/context.dart';
import '../parser/result.dart';
import '../route_map/map_data/base.dart';

abstract class MvcRouterMapParser {
  FutureOr<MvcRouterParseContext> createParseContext(MvcRouterMapBase map, MvcRouterMapPathBase mapData, {bool restore = false});
  FutureOr<MvcRouterMapPathParseResult> parseRoute(MvcRouterParseContext context, {bool restore = false});
}

mixin MvcRouterMixinMapParser on DependencyInjectionService implements MvcRouterMapParser {
  @override
  FutureOr<MvcRouterParseContext> createParseContext(MvcRouterMapBase map, MvcRouterMapPathBase mapData, {bool restore = false}) {
    return MvcRouterParseContext(
      map: map,
      mapData: mapData,
    );
  }

  @override
  FutureOr<MvcRouterMapPathParseResult> parseRoute(MvcRouterParseContext context, {bool restore = false}) async {
    for (var element in getService<MvcRouteProvider>().routes()) {
      final result = await _parseRoute(context, element);
      if (result != null) {
        return result;
      }
    }
    return MvcRouterMapPathParseResult(
      route: getService<MvcNotFoundRoute>(),
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
