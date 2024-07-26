import 'dart:async';

import 'package:flutter/material.dart';

import '../route_operate.dart';
import 'map_data/base.dart';

abstract class MvcRouterMapBase {
  List<MvcRouterMapPathBase> get paths;
  Uri? get uri;
  String? get id;
  GlobalKey<NavigatorState> get key;
  Future<T?> operate<T>(MvcRouteOperate operate);
  String serialization();
}
