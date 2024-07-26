import 'package:flutter_mvc_router/src/route_map/map_data/base.dart';
import 'package:flutter_mvc_router/src/route_map/map_data/uri.dart';

import 'match_location.dart';

class RoutePathMatchLocation extends MvcRouteMatchedLocation {
  RoutePathMatchLocation({required this.location, this.pathParameters = const {}});
  final String location;
  final Map<String, String> pathParameters;

  @override
  MvcRouterMapPathBase consumeMatchedLocation(MvcRouterMapPathBase path) {
    assert(path is MvcRouterUriPath);
    return (path as MvcRouterUriPath).removeLocation(location)
      ..copyWith(
        pathParameters: pathParameters,
      );
  }
}
