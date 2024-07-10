import '../route_map/base.dart';
import '../route_map/map_data/base.dart';

abstract class RouteSerializerBase {}

abstract class RouteMapSerializer<T extends MvcRouteMapBase> extends RouteSerializerBase {
  dynamic serialization(T routeMap);
  bool canDeserialization(dynamic serializedData);
  T? deserialization(dynamic serializedData);
}

abstract class RouteMapDataSerializer<T extends MvcRouteMapDataBase> extends RouteSerializerBase {
  dynamic serialization(T routeMapData);
  bool canDeserialization(dynamic serializedData);
  T? deserialization(dynamic serializedData);
}
