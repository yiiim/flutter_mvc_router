import 'package:flutter/material.dart';

import '../../path_utils.dart';
import '../../serializer/map_data/uri.dart';
import '../base.dart';
import 'base.dart';

class MvcRouteUriMapData extends MvcRouteMapDataBase with MvcRoutePathParameters, MvcRouteDicationaryParameters {
  MvcRouteUriMapData({
    required this.matchedPath,
    required this.remainingLocation,
    required this.matchedLocation,
    required this.pathParameters,
    required this.uri,
    this.arguments,
    LocalKey? key,
    super.branchCurrentIndex,
    super.branches,
    super.extraData,
  }) : key = key ?? ValueKey(uri);
  factory MvcRouteUriMapData.fromUri(
    Uri uri, {
    LocalKey? key,
    int? branchCurrentIndex,
    List<MvcRouteMapBase>? branches,
    dynamic extraData,
  }) {
    return MvcRouteUriMapData(
      matchedPath: "",
      remainingLocation: uri.path,
      matchedLocation: "",
      pathParameters: {},
      uri: uri,
      key: key,
      branchCurrentIndex: branchCurrentIndex,
      branches: branches,
      extraData: extraData,
    );
  }
  @override
  final LocalKey key;
  final String matchedPath;
  final String remainingLocation;
  final String matchedLocation;
  final dynamic arguments;
  @override
  final Map<String, String> pathParameters;
  @override
  final Uri uri;

  MvcRouteUriMapData copyWith({
    String? matchedPath,
    String? remainingLocation,
    String? matchedLocation,
    Map<String, String>? pathParameters,
    Uri? uri,
  }) {
    return MvcRouteUriMapData(
      matchedPath: matchedPath ?? this.matchedPath,
      remainingLocation: remainingLocation ?? this.remainingLocation,
      matchedLocation: matchedLocation ?? this.matchedLocation,
      pathParameters: pathParameters ?? this.pathParameters,
      uri: uri ?? this.uri,
    );
  }

  MvcRouteUriMapData removeLocation(String localtion) {
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
  Map<String, dynamic> get dicationaryArgs => {...uri.queryParameters, ...pathParameters};
}
