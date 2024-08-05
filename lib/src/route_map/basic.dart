import 'package:flutter/material.dart';

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
}
