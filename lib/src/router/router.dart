import 'dart:async';

import 'package:flutter_mvc/flutter_mvc.dart';

import '../parser/parser.dart';
import '../parser/context.dart';
import '../route/route.dart';
import '../route_map/map_data/base.dart';
import '../parser/result.dart';
import '../route_provider.dart';
import 'navigation/basic.dart';
import 'navigation/page.dart';
import 'navigation/path.dart';
import 'base.dart';

class MvcRouter extends MvcRouterBase with DependencyInjectionService, MvcBasicRouter, MvcPathRouter, MvcPageRouter, MvcMixinRouter {}

mixin MvcMixinRouter on DependencyInjectionService, MvcBasicRouter, MvcPathRouter, MvcPageRouter implements MvcRouterBase {
  late final MvcRouteProvider _routerCollection = getService();
  late final MvcRouterParser _parser = getService();

  @override
  FutureOr<MvcRouterParseContext> createRouteParseContext(MvcRouteMapDataBase mapData, {bool restore = false}) {
    return MvcRouterParseContext(mapData: mapData);
  }

  @override
  FutureOr<MvcRouteMapDataParseResult> parseRoute(MvcRouterParseContext context, {bool restore = false}) async {
    for (var element in _routerCollection.routes()) {
      final result = await _parseRoute(context, element);
      if (result != null) {
        return result;
      }
    }
    return MvcRouteMapDataParseResult(
      route: getService<MvcNotFoundRoute>(),
      mapData: context.mapData,
    );
  }

  FutureOr<MvcRouteMapDataParseResult?> _parseRoute(MvcRouterParseContext context, MvcRouteBase route) async {
    final location = route.match(context);
    if (location != null) {
      final newContext = location.consumeMatchedLocationInContext(context);
      if (route is MvcContainerRouteMixin && route.children.isNotEmpty) {
        if (!newContext.mapData.isEmpty) {
          for (var element in route.children) {
            final childResult = await _parseRoute(newContext, element);
            if (childResult != null) {
              return MvcRouteMapDataParseResult(
                mapData: context.mapData,
                route: route,
                location: location,
                child: childResult,
              );
            }
          }
        }
        return null;
      }
      return MvcRouteMapDataParseResult(
        mapData: context.mapData,
        route: route,
        location: location,
        branchCurrentIndex: context.mapData.branchCurrentIndex,
        branches: await _parseBranches(context),
        key: context.mapData.key,
      );
    }
    return null;
  }

  FutureOr<List<MvcRouteMapParseResult>?> _parseBranches(MvcRouterParseContext context) async {
    if (context.mapData.branches == null) {
      return null;
    }
    final list = <MvcRouteMapParseResult>[];
    for (var element in context.mapData.branches!) {
      list.add(await _parser.parseRouteMap(element));
    }
    return list;
  }
}
