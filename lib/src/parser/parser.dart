import 'dart:async';

import 'package:flutter_mvc/flutter_mvc.dart';

import '../middleware/middleware.dart';
import '../route_map/base.dart';
import '../route_map/map_data/base.dart';
import 'map_parser.dart';
import 'result.dart';

class MvcRouterParser with DependencyInjectionService {
  final List<Type> middlewareTypes = [];
  late final MvcRouterMapParser _defaultMapParser = getService<MvcRouterMapParser>();

  FutureOr<MvcRouterMapParseResult> parseRouteMap(
    MvcRouterMapBase map, {
    bool restore = false,
    MvcRouterMapParser? mapParser,
  }) async {
    final list = <MvcRouterMapPathParseResult>[];
    for (var element in map.paths) {
      list.add(await _parseRouteMapData(map, element, mapParser ?? _defaultMapParser, restore: restore));
    }
    return MvcRouterMapParseResult(
      map: map,
      paths: list,
      key: map.key,
      id: map.id,
    );
  }

  FutureOr<MvcRouterMapPathParseResult> parseRouteMapData(MvcRouterMapBase map, MvcRouterMapPathBase mapData, {MvcRouterMapParser? mapParser, bool restore = false}) async {
    return _parseRouteMapData(map, mapData, mapParser ?? _defaultMapParser, restore: restore);
  }

  FutureOr<MvcRouterMapPathParseResult> _parseRouteMapData(MvcRouterMapBase map, MvcRouterMapPathBase mapData, MvcRouterMapParser mapParser, {bool restore = false}) async {
    final context = await mapParser.createParseContext(map, mapData, restore: restore);
    RouteHandler routerHander = mapParser.parseRoute;
    for (var element in middlewareTypes) {
      routerHander = (getServiceByType(element) as MvcRouterMiddleware).middleware(routerHander);
    }
    return await routerHander.call(context, restore: restore);
  }
}
