import 'package:flutter/material.dart';

import '../../path_utils.dart';
import '../../serializer/map_data/uri.dart';
import 'base.dart';

class MvcRouterUriPath extends MvcRouterMapPathBase with MvcRoutePathParameters, MvcRouteDicationaryParameters {
  MvcRouterUriPath({
    required this.matchedPath,
    required this.remainingLocation,
    required this.matchedLocation,
    required this.pathParameters,
    this.uri,
    this.arguments,
    LocalKey? key,
    super.extraData,
  }) : super(key: key ?? ValueKey(uri));
  factory MvcRouterUriPath.fromUri(
    Uri uri, {
    LocalKey? key,
    dynamic extraData,
  }) {
    return MvcRouterUriPath(
      matchedPath: "",
      remainingLocation: uri.path,
      matchedLocation: "",
      pathParameters: {},
      uri: uri,
      key: key,
      extraData: extraData,
    );
  }
  final String matchedPath;
  final String remainingLocation;
  final String matchedLocation;
  final dynamic arguments;
  @override
  final Map<String, String> pathParameters;
  @override
  final Uri? uri;

  MvcRouterUriPath copyWith({
    String? matchedPath,
    String? remainingLocation,
    String? matchedLocation,
    Map<String, String>? pathParameters,
    Uri? uri,
  }) {
    return MvcRouterUriPath(
      matchedPath: matchedPath ?? this.matchedPath,
      remainingLocation: remainingLocation ?? this.remainingLocation,
      matchedLocation: matchedLocation ?? this.matchedLocation,
      pathParameters: pathParameters ?? this.pathParameters,
      uri: uri ?? this.uri,
    );
  }

  MvcRouterUriPath removeLocation(String localtion) {
    if (localtion.isEmpty) {
      return copyWith();
    }
    final String newRemainingLocation = remainingLocation.substring(localtion.length, remainingLocation.length);
    return copyWith(
      remainingLocation: newRemainingLocation,
      matchedLocation: concatenatePaths(matchedLocation, localtion),
    );
  }

  @override
  String serialization() {
    return MvcRouteUriMapDataSerializer().serialization(this);
  }

  @override
  Map<String, dynamic> get dicationaryArgs => {
        if (uri != null) ...uri!.queryParameters,
        ...pathParameters,
      };

  @override
  bool get isEmpty => remainingLocation.isEmpty;
}
