import 'dart:async';

import 'package:flutter/material.dart';

import '../route_operate.dart';
import 'map_data/base.dart';

abstract class MvcRouteMapBase {
  int get length;
  MvcRouteMapDataBase dataAtIndex(int index);
  Future<T?> operate<T>(MvcRouteOperate operate);

  String serialization();
  Uri? get uri;
  GlobalKey? get key;
  String? get id;
}
