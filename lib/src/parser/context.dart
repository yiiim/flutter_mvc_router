import 'package:flutter_mvc_router/src/route/route.dart';
import 'package:flutter_mvc_router/src/route_map/base.dart';

import '../route_map/map_data/base.dart';

class MvcRouterParseContext {
  MvcRouterParseContext({
    required this.map,
    required this.mapData,
    this.restore = false,
  });
  final MvcRouterMapBase map;
  final MvcRouterMapPathBase mapData;
  final bool restore;
  List<MvcRouteBase> availableRoutes = [];
  MvcRouteBase? notFoundRoute;
  Map userInfo = {};
}
