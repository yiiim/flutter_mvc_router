import '../../parser/context.dart';
import '../../route_map/map_data/uri.dart';
import 'match_location.dart';

class RoutePathMatchLocation extends MvcRouteMatchedLocation {
  RoutePathMatchLocation({required this.location, this.pathParameters = const {}});
  final String location;
  final Map<String, String> pathParameters;

  @override
  MvcRouterParseContext consumeMatchedLocationInContext(MvcRouterParseContext context) {
    assert(context.mapData is MvcRouteUriMapData);
    return context.change(
      mapData: (context.mapData as MvcRouteUriMapData).removeLocation(location)
        ..copyWith(
          pathParameters: pathParameters,
        ),
    );
  }
}
