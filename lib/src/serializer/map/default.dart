import 'dart:convert';

import 'package:flutter_mvc/flutter_mvc.dart';
import 'package:flutter_mvc_router/src/route_map/map_data/base.dart';

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
      final data = jsonDecode((serializedData as String).substring("MvcDefaultRouteMap:".length));
      if (data is! List) {
        return null;
      }
      List<MvcRouterMapPathBase> paths = [];
      for (var element in data) {
        final path = MvcRouteUriMapDataSerializer().deserialization(element);
        if (path != null) {
          paths.add(path);
        }
      }
      final result = MvcRouterBasicMap(paths);
      return result;
    } catch (e) {
      return null;
    }
  }

  @override
  dynamic serialization(MvcRouterBasicMap routeMap) {
    return "MvcDefaultRouteMap:${jsonEncode(routeMap.paths.map((e) => e.serialization()).toList())}";
  }
}
