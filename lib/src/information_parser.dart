import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';

import 'delegate.dart';
import 'route_map/base.dart';
import 'serializer/manager.dart';
import 'route_stack.dart';
import 'parser/parser.dart';

class MvcRouteInformationParser extends RouteInformationParser<MvcRouterMapBase> with DependencyInjectionService {
  late final MvcRouterParser parser = getService<MvcRouterParser>();
  @override
  Future<MvcRouterMapBase> parseRouteInformationWithDependencies(RouteInformation routeInformation, BuildContext context) async {
    MvcRouterMapBase? result;
    bool restore = false;
    if (routeInformation.state is String) {
      final informationStringState = routeInformation.state as String;
      if (informationStringState.startsWith("MvcRouteInformationParser")) {
        final serializedData = informationStringState.substring("MvcRouteInformationParser".length + 1);
        result = getService<MvcRouterSerializerManager>().deserializationRouteMap(serializedData);
        if (result != null) {
          restore = true;
        }
      }
    }
    if (result == null) {
      if (routeInformation.state is MvcRouterMapBase) {
        result = routeInformation.state as MvcRouterMapBase;
      } else {
        result ??= getService<MvcRouterDelegate>().rootRouteMap;
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
  RouteInformation? restoreRouteInformation(MvcRouterMapBase configuration) {
    return RouteInformation(
      uri: configuration.uri,
      state: "MvcRouteInformationParser${configuration.serialization()}",
    );
  }
}
