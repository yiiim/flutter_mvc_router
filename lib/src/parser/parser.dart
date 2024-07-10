import 'dart:async';

import 'package:flutter_mvc/flutter_mvc.dart';

import '../middleware/middleware.dart';
import '../router/base.dart';
import '../route_map/base.dart';
import '../route_map/map_data/base.dart';
import 'result.dart';

class MvcRouterParser with DependencyInjectionService {
  final List<Type> middlewareTypes = [];
  late MvcRouterBase defaultRouter = getService<MvcRouterBase>();

  FutureOr<MvcRouteMapParseResult> parseRouteMap(MvcRouteMapBase map, {bool restore = false}) async {
    final list = <MvcRouteMapDataParseResult>[];
    for (var i = 0; i < map.length; i++) {
      list.add(await _parseRouteMapData(map.dataAtIndex(i), defaultRouter, restore: restore));
    }
    return MvcRouteMapParseResult(
      map: map,
      results: list,
      key: map.key,
      id: map.id,
    );
  }

  FutureOr<MvcRouteMapDataParseResult> parseRouteMapData(MvcRouteMapDataBase mapData, {MvcRouterBase? router, bool restore = false}) async {
    return _parseRouteMapData(mapData, router ?? defaultRouter, restore: restore);
  }

  FutureOr<MvcRouteMapDataParseResult> _parseRouteMapData(MvcRouteMapDataBase mapData, MvcRouterBase router, {bool restore = false}) async {
    final context = await router.createRouteParseContext(mapData, restore: restore);
    RouteHandler routerHander = router.parseRoute;
    for (var element in middlewareTypes) {
      routerHander = (getServiceByType(element) as MvcRouterMiddleware).middleware(routerHander);
    }
    return await routerHander.call(context, restore: restore);
  }
}
