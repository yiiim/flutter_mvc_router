import 'dart:convert';

import 'package:flutter_mvc/flutter_mvc.dart';

import '../../route_map/basic.dart';
import '../map_data/uri.dart';
import '../serializer.dart';

class DefaultMvcRouteMapSerializer extends RouteMapSerializer<MvcRouterBasicMap> with DependencyInjectionService {
  @override
  bool canDeserialization(dynamic serializedData) {
    return serializedData is String && serializedData.startsWith("MvcDefaultRouteMap:");
  }

  @override
  MvcRouterBasicMap? deserialization(dynamic serializedData) {
    try {
      final data = jsonDecode((serializedData as String).substring("MvcDefaultRouteMap:".length + 1));
      return MvcRouterBasicMap(data.map((e) => MvcRouteUriMapDataSerializer().deserialization(jsonEncode(e))).toList());
    } catch (e) {
      return null;
    }
  }

  @override
  dynamic serialization(MvcRouterBasicMap routeMap) {
    return "MvcDefaultRouteMap:${jsonEncode(routeMap.paths.map((e) => e.serialization()).toList())}";
  }
}
