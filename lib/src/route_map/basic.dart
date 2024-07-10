import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../route_operate.dart';
import '../serializer/map/default.dart';
import 'base.dart';
import 'map_data/base.dart';
import 'map_data/uri.dart';

class MvcBasicRouteMap extends MvcRouteMapBase {
  MvcBasicRouteMap(
    this.datas, {
    this.id,
    this.key,
  });
  final List<MvcRouteMapDataBase> datas;
  final GlobalKey? key;
  final String? id;
  @override
  int get length => datas.length;

  @override
  MvcRouteMapDataBase dataAtIndex(int index) {
    return datas[index];
  }

  @override
  String serialization() {
    return DefaultMvcRouteMapSerializer().serialization(this);
  }

  @override
  Uri? get uri {
    for (var element in datas) {
      if (element is MvcRouteUriMapData) {
        return element.uri;
      }
    }
    return null;
  }

  @override
  Future<T?> operate<T>(MvcRouteOperate operate) {
    switch (operate) {
      case MvcRouteOperatePop(result: final result):
        datas.removeLast().result?.complete(result);
        break;
      case MvcRouteOperatePush(mapData: final data):
        Completer<T?> completer = Completer();
        data.result = completer;
        datas.add(data);
        return completer.future;
      case MvcRouteOperatePushReplacement(mapData: final data, result: final result):
        datas.removeLast().result?.complete(result);
        datas.add(data);
        break;
      case MvcRouteOperatePushAndRemoveUntil(mapData: final data, predicate: final predicate):
        MvcRouteMapDataBase? candidate = datas.lastWhereOrNull((element) => predicate(element));
        while (candidate != null) {
          datas.remove(candidate..result?.complete(null));
          candidate = datas.lastWhereOrNull((element) => predicate(element));
        }
        datas.add(data);
        break;
      case MvcRouteOperatePopUntil(predicate: final predicate):
        MvcRouteMapDataBase? candidate = datas.lastWhereOrNull((element) => predicate(element));
        while (candidate != null) {
          datas.remove(candidate..result?.complete(null));
          candidate = datas.lastWhereOrNull((element) => predicate(element));
        }
        break;
      default:
    }
    return SynchronousFuture(null);
  }
}
