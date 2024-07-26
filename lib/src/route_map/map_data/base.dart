import 'dart:async';
import 'package:flutter/material.dart';

abstract class MvcRouterMapPathBase {
  MvcRouterMapPathBase({
    this.extraData,
    required this.key,
  });
  T? args<T>() {
    if (this is T) {
      return this as T;
    }
    return null;
  }

  final LocalKey key;
  Completer? result;
  dynamic extraData;
  String serialization();

  Uri? get uri;
  bool get isEmpty => false;
}

mixin MvcRoutePathParameters on MvcRouterMapPathBase {
  Map<String, String> get pathParameters;
  @override
  T? args<T>() {
    if (T == Map<String, String>) {
      return pathParameters as T;
    }
    return super.args();
  }
}
mixin MvcRouteDicationaryParameters on MvcRouterMapPathBase {
  Map<String, dynamic> get dicationaryArgs;

  @override
  T? args<T>() {
    return dicationaryArgs.values.whereType<T>().firstOrNull ?? super.args();
  }
}

extension MvcRouteMapDataParametersHelper on MvcRouterMapPathBase {
  String? pathParameter(String key) {
    return args<MvcRoutePathParameters>()?.pathParameters[key];
  }

  String? queryParameter(String key) {
    return uri?.queryParameters[key];
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
