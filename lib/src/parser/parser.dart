import 'dart:async';

import 'package:flutter_mvc/flutter_mvc.dart';

import '../middleware/middleware.dart';
import '../route_map/base.dart';
import '../route_map/map_data/base.dart';
import 'map_parse_delegate.dart';
import 'result.dart';

class MvcRouterParser with DependencyInjectionService {
  final List<Type> middlewareTypes = [];

  FutureOr<MvcRouterMapParseResult> parseRouteMap(
    MvcRouterMapBase map, {
    bool restore = false,
    required MvcRouterMapParseDelegate mapParseDelegate,
  }) async {
    final list = <MvcRouterMapPathParseResult>[];
    for (var element in map.paths) {
      list.add(
        await _parseRouteMapData(
          map,
          element,
          mapParseDelegate: mapParseDelegate,
          restore: restore,
        ),
      );
    }
    return MvcRouterMapParseResult(
      map: map,
      paths: list,
      key: map.key,
      id: map.id,
    );
  }

  FutureOr<MvcRouterMapPathParseResult> parseRouteMapData(
    MvcRouterMapBase map,
    MvcRouterMapPathBase mapData, {
    required MvcRouterMapParseDelegate mapParseDelegate,
    bool restore = false,
  }) async {
    return _parseRouteMapData(
      map,
      mapData,
      mapParseDelegate: mapParseDelegate,
      restore: restore,
    );
  }

  FutureOr<MvcRouterMapPathParseResult> _parseRouteMapData(
    MvcRouterMapBase map,
    MvcRouterMapPathBase mapData, {
    required MvcRouterMapParseDelegate mapParseDelegate,
    bool restore = false,
  }) async {
    final context = await mapParseDelegate.createParseContext(map, mapData, restore: restore);
    RouteHandler routerHander = mapParseDelegate.parseRoute;
    for (var element in middlewareTypes) {
      routerHander = (getServiceByType(element) as MvcRouterMiddleware).middleware(routerHander);
    }
    return await routerHander.call(context, restore: restore);
  }
}
