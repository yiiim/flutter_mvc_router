import 'package:flutter/material.dart';

import '../../route/page.dart';
import 'uri.dart';

class MvcRouterPagePath<T> extends MvcRouterUriPath {
  MvcRouterPagePath({
    required super.matchedPath,
    required super.remainingLocation,
    required super.matchedLocation,
    required super.pathParameters,
    required super.uri,
    super.arguments,
    super.key,
  });
  static MvcRouterPagePath fromController<T extends MvcPageController>({
    dynamic arguments,
    String? path,
    LocalKey? key,
  }) {
    return MvcRouterPagePath<T>(
      matchedPath: "",
      remainingLocation: "$T",
      matchedLocation: "",
      pathParameters: {},
      uri: path != null ? Uri.parse(path) : null,
      arguments: arguments,
      key: key ?? ValueKey(T),
    );
  }

  final Type controllerType = T;

  @override
  E? args<E>() {
    if (arguments is E) {
      return arguments as E;
    }
    return super.args();
  }

  @override
  Map<String, dynamic> get dicationaryArgs => {
        ...super.dicationaryArgs,
        if (arguments is Map<String, dynamic>) ...arguments,
      };
  @override
  MvcRouterUriPath copyWith({String? matchedPath, String? remainingLocation, String? matchedLocation, Map<String, String>? pathParameters, Uri? uri, dynamic arguments}) {
    return MvcRouterPagePath(
      matchedPath: matchedPath ?? this.matchedPath,
      remainingLocation: remainingLocation ?? this.remainingLocation,
      matchedLocation: matchedLocation ?? this.matchedLocation,
      pathParameters: pathParameters ?? this.pathParameters,
      uri: uri ?? this.uri,
      arguments: arguments ?? this.arguments,
    );
  }
}
