import 'dart:async';

import '../parser/context.dart';
import '../parser/result.dart';
import '../route_map/map_data/base.dart';

abstract class MvcRouterBase {
  FutureOr<MvcRouterParseContext> createRouteParseContext(MvcRouteMapDataBase mapData, {bool restore = false});
  FutureOr<MvcRouteMapDataParseResult> parseRoute(MvcRouterParseContext context, {bool restore = false});
}
