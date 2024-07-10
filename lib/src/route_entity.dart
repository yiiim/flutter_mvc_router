import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mvc_router/flutter_mvc_router.dart';

class MvcRouteEntity {
  MvcRouteEntity({
    required this.data,
    this.route,
    this.child,
    this.key,
    this.branches,
    this.branchCurrentIndex,
    this.result,
  });
  MvcRouteMapDataBase data;
  MvcRouteBase? route;
  MvcRouteStack? child;
  int? branchCurrentIndex;
  List<MvcRouteStack>? branches;
  LocalKey? key;
  Completer? result;

  MvcRouteEntity copyWith({
    MvcRouteMapDataBase? data,
    MvcRouteBase? route,
    MvcRouteStack? child,
    int? branchCurrentIndex,
    List<MvcRouteStack>? branches,
    LocalKey? key,
    Completer? result,
  }) {
    return MvcRouteEntity(
      data: data ?? this.data,
      route: route ?? this.route,
      child: child ?? this.child,
      branchCurrentIndex: branchCurrentIndex ?? this.branchCurrentIndex,
      branches: branches ?? this.branches,
      key: key ?? this.key,
      result: result ?? this.result,
    );
  }
}
