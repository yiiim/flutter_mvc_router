import 'package:flutter/material.dart';
import 'package:flutter_mvc_router/flutter_mvc_router.dart';

class MvcRouteMapParseResult {
  MvcRouteMapParseResult({
    required this.map,
    this.key,
    this.id,
    required this.results,
  });
  final MvcRouteMapBase map;
  final GlobalKey? key;
  final String? id;
  final List<MvcRouteMapDataParseResult> results;
}

class MvcRouteMapDataParseResult {
  MvcRouteMapDataParseResult({
    required this.route,
    required this.mapData,
    this.location,
    this.child,
    this.key,
    this.branches,
    this.branchCurrentIndex,
  });
  final MvcRouteMapDataBase mapData;
  final MvcRouteBase? route;
  final MvcRouteMatchedLocation? location;
  final LocalKey? key;
  final MvcRouteMapDataParseResult? child;
  final int? branchCurrentIndex;
  final List<MvcRouteMapParseResult>? branches;
}
