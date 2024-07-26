import 'dart:convert';

import '../../route_map/map_data/uri.dart';
import '../serializer.dart';

class MvcRouteUriMapDataSerializer extends RouteMapDataSerializer<MvcRouterUriPath> {
  @override
  bool canDeserialization(dynamic serializedData) {
    return serializedData is String && serializedData.startsWith("MvcRouteUriMapData:");
  }

  @override
  MvcRouterUriPath? deserialization(dynamic serializedData) {
    try {
      final data = jsonDecode((serializedData as String).substring("MvcRouteUriMapData:".length + 1));
      return MvcRouterUriPath(
        matchedPath: data["matchedPath"],
        remainingLocation: data["remainingLocation"],
        matchedLocation: data["matchedLocation"],
        pathParameters: Map<String, String>.from(data["pathParameters"]),
        uri: Uri.parse(data["uri"]),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  dynamic serialization(MvcRouterUriPath routeMapData) {
    Map data = {
      "matchedPath": routeMapData.matchedPath,
      "remainingLocation": routeMapData.remainingLocation,
      "matchedLocation": routeMapData.matchedLocation,
      "pathParameters": routeMapData.pathParameters,
      "uri": routeMapData.uri.toString(),
    };
    return "MvcRouteUriMapData:${jsonEncode(data)}";
  }
}
