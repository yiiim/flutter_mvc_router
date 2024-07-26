import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../route_operate.dart';
import '../serializer/map/default.dart';
import 'base.dart';
import 'map_data/base.dart';
import 'map_data/uri.dart';

class MvcRouterBasicMap extends MvcRouterMapBase {
  MvcRouterBasicMap(
    this.paths, {
    this.id,
    GlobalKey<NavigatorState>? key,
  }) : key = key ?? GlobalKey<NavigatorState>();
  @override
  final List<MvcRouterMapPathBase> paths;
  @override
  final GlobalKey<NavigatorState> key;
  @override
  final String? id;

  @override
  String serialization() {
    return DefaultMvcRouteMapSerializer().serialization(this);
  }

  @override
  Uri? get uri {
    for (var element in paths) {
      if (element is MvcRouterUriPath) {
        return element.uri;
      }
    }
    return null;
  }

  @override
  Future<T?> operate<T>(MvcRouteOperate operate) {
    switch (operate) {
      case MvcRouteOperatePop(result: final result):
        paths.removeLast().result?.complete(result);
        break;
      case MvcRouteOperatePush(mapData: final data):
        Completer<T?> completer = Completer();
        data.result = completer;
        paths.add(data);
        return completer.future;
      case MvcRouteOperatePushReplacement(mapData: final data, result: final result):
        paths.removeLast().result?.complete(result);
        paths.add(data);
        break;
      case MvcRouteOperatePushAndRemoveUntil(mapData: final data, predicate: final predicate):
        MvcRouterMapPathBase? candidate = paths.lastWhereOrNull((element) => predicate(element));
        while (candidate != null) {
          paths.remove(candidate..result?.complete(null));
          candidate = paths.lastWhereOrNull((element) => predicate(element));
        }
        paths.add(data);
        break;
      case MvcRouteOperatePopUntil(predicate: final predicate):
        MvcRouterMapPathBase? candidate = paths.lastWhereOrNull((element) => predicate(element));
        while (candidate != null) {
          paths.remove(candidate..result?.complete(null));
          candidate = paths.lastWhereOrNull((element) => predicate(element));
        }
        break;
      default:
    }
    return SynchronousFuture(null);
  }
}
