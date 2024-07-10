import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mvc_router/flutter_mvc_router.dart';

abstract class MvcRouteMapDataBase {
  MvcRouteMapDataBase({
    this.branches,
    this.branchCurrentIndex,
    this.extraData,
  });
  T? args<T>() {
    if (this is T) {
      return this as T;
    }
    return null;
  }

  LocalKey get key => ValueKey(this);
  Uri get uri;
  bool get isEmpty => false;
  Completer? result;
  int? branchCurrentIndex;
  List<MvcRouteMapBase>? branches;
  dynamic extraData;

  String serialization() {
    return "MvcRouteMapData";
  }
}

mixin MvcRoutePathParameters on MvcRouteMapDataBase {
  Map<String, String> get pathParameters;
  @override
  T? args<T>() {
    if (T == Map<String, String>) {
      return pathParameters as T;
    }
    return super.args();
  }
}
mixin MvcRouteDicationaryParameters on MvcRouteMapDataBase {
  Map<String, dynamic> get dicationaryArgs;

  @override
  T? args<T>() {
    return dicationaryArgs.values.whereType<T>().firstOrNull ?? super.args();
  }
}

extension MvcRouteMapDataParametersHelper on MvcRouteMapDataBase {
  String? pathParameter(String key) {
    return args<MvcRoutePathParameters>()?.pathParameters[key];
  }

  String? queryParameter(String key) {
    return uri.queryParameters[key];
  }

  T? argsForKey<T>(String key) {
    final dicationaryArgs = args<MvcRouteDicationaryParameters>()?.dicationaryArgs;
    if (dicationaryArgs != null) {
      if (dicationaryArgs.containsKey(key) && dicationaryArgs[key] is T) {
        return dicationaryArgs[key] as T;
      }
    }
    return null;
  }
}
