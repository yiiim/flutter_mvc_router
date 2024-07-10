import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';

import 'delegate.dart';
import 'route_map/base.dart';
import 'serializer/manager.dart';
import 'route_stack.dart';
import 'parser/parser.dart';

class MvcRouteInformationParser extends RouteInformationParser<MvcRouteMapBase> with DependencyInjectionService {
  late final MvcRouterParser parser = getService<MvcRouterParser>();
  @override
  Future<MvcRouteMapBase> parseRouteInformationWithDependencies(RouteInformation routeInformation, BuildContext context) async {
    MvcRouteMapBase? result;
    bool restore = false;
    if (routeInformation.state is String) {
      final informationStringState = routeInformation.state as String;
      if (informationStringState.startsWith("MvcRouteInformationParser")) {
        final serializedData = informationStringState.substring("MvcRouteInformationParser".length);
        result = getService<MvcRouterSerializerManager>().deserializationRouteMap(serializedData);
        if (result != null) {
          restore = true;
        }
      }
    }
    if (result == null) {
      if (routeInformation.state is MvcRouteMapBase) {
        result = routeInformation.state as MvcRouteMapBase;
      } else {
        result ??= getService<MvcRouterDelegate>().initialRouteMap;
      }
    }
    if (result is! MvcRouteStack) {
      result = MvcRouteStack.fromResult(
        await parser.parseRouteMap(result, restore: restore),
        parser,
      );
    }
    return result;
  }

  @override
  RouteInformation? restoreRouteInformation(MvcRouteMapBase configuration) {
    return RouteInformation(
      uri: configuration.uri,
      state: "MvcRouteInformationParser${configuration.serialization()}",
    );
  }
}
