import 'package:flutter/material.dart';
import 'map_data/base.dart';

abstract class MvcRouterMapBase {
  List<MvcRouterMapPathBase> get paths;
  Uri? get uri;
  String? get id;
  GlobalKey<NavigatorState> get key;
  String serialization();
}
