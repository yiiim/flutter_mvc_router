import 'package:flutter/material.dart';

import 'uri.dart';

class MvcRouterNamedPath extends MvcRouterUriPath {
  MvcRouterNamedPath(
    this.name, {
    super.arguments,
    super.key,
    required super.uri,
    required super.matchedPath,
    required super.remainingLocation,
    required super.matchedLocation,
    required super.pathParameters,
    super.extraData,
  });
  factory MvcRouterNamedPath.fromNamed(
    String name,
    dynamic arguments, {
    LocalKey? key,
    dynamic extraData,
  }) {
    Uri uri = Uri.parse(name);
    return MvcRouterNamedPath(
      name,
      key: key,
      arguments: arguments,
      uri: uri,
      matchedPath: "",
      remainingLocation: uri.path,
      matchedLocation: "",
      pathParameters: {},
      extraData: extraData,
    );
  }
  final String name;

  @override
  T? args<T>() {
    if (arguments is T) {
      return arguments as T;
    }
    return super.args();
  }

  @override
  Map<String, dynamic> get dicationaryArgs => {
        ...super.dicationaryArgs,
        if (arguments is Map<String, dynamic>) ...arguments,
      };
  @override
  MvcRouterUriPath copyWith({String? name, dynamic arguments, String? matchedPath, String? remainingLocation, String? matchedLocation, Map<String, String>? pathParameters, Uri? uri}) {
    return MvcRouterNamedPath(
      name ?? this.name,
      arguments: arguments ?? this.arguments,
      matchedPath: matchedPath ?? this.matchedPath,
      remainingLocation: remainingLocation ?? this.remainingLocation,
      matchedLocation: matchedLocation ?? this.matchedLocation,
      pathParameters: pathParameters ?? this.pathParameters,
      uri: uri ?? this.uri,
    );
  }
}
