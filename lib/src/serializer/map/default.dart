import 'dart:convert';

import 'package:flutter_mvc/flutter_mvc.dart';

import '../../route_map/basic.dart';
import '../map_data/uri.dart';
import '../serializer.dart';

class DefaultMvcRouteMapSerializer extends RouteMapSerializer<MvcBasicRouteMap> with DependencyInjectionService {
  @override
  bool canDeserialization(dynamic serializedData) {
    return serializedData is String && serializedData.startsWith("MvcDefaultRouteMap:");
  }

  @override
  MvcBasicRouteMap? deserialization(dynamic serializedData) {
    try {
      final data = jsonDecode((serializedData as String).substring("MvcDefaultRouteMap:".length + 1));
      return MvcBasicRouteMap(data.map((e) => MvcRouteUriMapDataSerializer().deserialization(jsonEncode(e))).toList());
    } catch (e) {
      return null;
    }
  }

  @override
  dynamic serialization(MvcBasicRouteMap routeMap) {
    return "MvcDefaultRouteMap:${jsonEncode(routeMap.datas.map((e) => e.serialization()).toList())}";
  }
}
