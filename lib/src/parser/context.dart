import 'package:flutter_mvc_router/src/route/route.dart';
import 'package:flutter_mvc_router/src/route_map/base.dart';

import '../route_map/map_data/base.dart';

class MvcRouterParseContext {
  MvcRouterParseContext({
    required this.map,
    required this.mapData,
    this.userInfo = const {},
  });
  final MvcRouterMapBase map;
  final MvcRouterMapPathBase mapData;
  final Map userInfo;

  MvcRouterParseContext change({
    MvcRouterMapPathBase? mapData,
    List<MvcRouteBase>? routes,
    Map? userInfo,
  }) {
    MvcRouterParseContext newContext = MvcRouterParseContext(
      map: map,
      mapData: mapData ?? this.mapData,
      userInfo: userInfo ?? this.userInfo,
    );
    return newContext;
  }
}
