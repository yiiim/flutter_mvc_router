import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mvc_router/flutter_mvc_router.dart';

class MvcRouteEntity {
  MvcRouteEntity({
    required this.mapData,
    required this.route,
    required this.location,
    this.remainingPath,
    this.key,
    this.id,
    this.uri,
    this.result,
  });
  final MvcRouterMapPathBase mapData;
  final MvcRouteBase route;
  final MvcRouteMatchedLocation location;
  final MvcRouterMapPathBase? remainingPath;
  final LocalKey? key;
  final String? id;
  final Uri? uri;
  Completer? result;

  factory MvcRouteEntity.fromResult(MvcRouterMapPathParseResult result) {
    return MvcRouteEntity(
      mapData: result.mapData,
      route: result.route,
      location: result.location,
      remainingPath: result.remainingPath,
      key: result.key,
      uri: (result.mapData.uri ?? result.route.uri),
      id: result.id,
    );
  }

  MvcRouteEntity copyWith({
    MvcRouterMapPathBase? mapData,
    MvcRouteBase? route,
    MvcRouteMatchedLocation? location,
    MvcRouterMapPathBase? remainingPath,
    LocalKey? key,
    String? id,
    Completer? result,
    Uri? uri,
  }) {
    return MvcRouteEntity(
      mapData: mapData ?? this.mapData,
      route: route ?? this.route,
      location: location ?? this.location,
      remainingPath: remainingPath ?? this.remainingPath,
      key: key ?? this.key,
      id: id ?? this.id,
      result: result ?? this.result,
      uri: uri ?? this.uri,
    );
  }
}
