import 'package:flutter_mvc_router/src/route_map/base.dart';

import 'route/route.dart';

abstract class MvcRouteProvider {
  List<MvcRouteBase> routes();
  MvcRouteMapBase initialRouteMap();
}
