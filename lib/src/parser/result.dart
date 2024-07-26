import 'package:flutter/material.dart';
import 'package:flutter_mvc_router/flutter_mvc_router.dart';

class MvcRouterMapParseResult {
  MvcRouterMapParseResult({
    required this.map,
    this.key,
    this.id,
    required this.paths,
  });
  final MvcRouterMapBase map;
  final GlobalKey<NavigatorState>? key;
  final String? id;
  final List<MvcRouterMapPathParseResult> paths;
}

class MvcRouterMapPathParseResult {
  MvcRouterMapPathParseResult({
    required this.route,
    required this.mapData,
    required this.location,
    this.remainingPath,
    this.key,
    this.id,
  });
  final MvcRouterMapPathBase mapData;
  final MvcRouteBase route;
  final MvcRouteMatchedLocation location;
  final MvcRouterMapPathBase? remainingPath;
  final LocalKey? key;
  final String? id;
}
