import 'package:flutter_mvc/flutter_mvc.dart';

import '../route_map/base.dart';
import '../route_map/map_data/base.dart';
import 'serializer.dart';

class MvcRouterSerializerManager extends ServiceObserver<RouteSerializerBase> with DependencyInjectionService {
  List<RouteMapSerializer> routeMapSerializers = [];
  List<RouteMapDataSerializer> routeMapDataSerializers = [];
  @override
  void onServiceCreated(RouteSerializerBase? service) {
    if (service is RouteMapSerializer) {
      routeMapSerializers.add(service);
    }
    if (service is RouteMapDataSerializer) {
      routeMapDataSerializers.add(service);
    }
  }

  @override
  void onServiceDispose(RouteSerializerBase? service) {
    if (service is RouteMapSerializer) {
      routeMapSerializers.remove(service);
    }
    if (service is RouteMapDataSerializer) {
      routeMapDataSerializers.remove(service);
    }
  }

  @override
  void onServiceInitializeDone(RouteSerializerBase? service) {}

  String serializationRouteMap<T extends MvcRouteMapBase>(T routeMap) {
    RouteMapSerializer? serializer;
    for (var element in routeMapSerializers) {
      if (element is RouteMapSerializer<T>) {
        serializer = element;
        break;
      }
    }
    serializer ??= tryGetService<RouteMapSerializer<T>>();
    if (serializer != null) {
      return serializer.serialization(routeMap);
    }
    return "";
  }

  String serializationRouteMapData<T extends MvcRouteMapDataBase>(T routeMapData) {
    RouteMapDataSerializer? serializer;
    for (var element in routeMapDataSerializers) {
      if (element is RouteMapDataSerializer<T>) {
        serializer = element;
        break;
      }
    }
    serializer ??= tryGetService<RouteMapDataSerializer<T>>();
    if (serializer != null) {
      return serializer.serialization(routeMapData);
    }
    return "";
  }

  MvcRouteMapBase? deserializationRouteMap(String serializedData) {
    for (var element in routeMapSerializers) {
      if (element.canDeserialization(serializedData)) {
        final data = element.deserialization(serializedData);
        if (data != null) {
          return data;
        }
      }
    }
    return null;
  }

  MvcRouteMapDataBase? deserializationRouteMapData(String serializedData) {
    for (var element in routeMapDataSerializers) {
      if (element.canDeserialization(serializedData)) {
        final data = element.deserialization(serializedData);
        if (data != null) {
          return data;
        }
      }
    }
    return null;
  }
}
