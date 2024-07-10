import '../../parser/context.dart';
import '../../route_map/map_data/empty.dart';

abstract class MvcRouteMatchedLocation {
  MvcRouterParseContext consumeMatchedLocationInContext(MvcRouterParseContext context);
}

class MvcRouteAnyMatchLocation extends MvcRouteMatchedLocation {
  @override
  MvcRouterParseContext consumeMatchedLocationInContext(MvcRouterParseContext context) {
    return context.change();
  }
}

class MvcRouteAllMatchLocation extends MvcRouteMatchedLocation {
  @override
  MvcRouterParseContext consumeMatchedLocationInContext(MvcRouterParseContext context) {
    return context.change(
      mapData: MvcEmptyRouteMapData(),
    );
  }
}
