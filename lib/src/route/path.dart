import 'package:flutter/material.dart';

import '../page.dart';
import '../parser/context.dart';
import '../path_utils.dart';
import '../route_info.dart';
import '../route_map/map_data/uri.dart';
import 'match_location/match_location.dart';
import 'match_location/path.dart';
import 'route.dart';

typedef MvcPathRouteBuilder = Widget Function(BuildContext context, MvcRouteInfo routeInfo, Widget? child);
typedef MvcPathRoutePageFactory = MvcPage Function();

class MvcPathRoute extends MvcRouteBase with MvcContainerRouteMixin {
  MvcPathRoute({
    required this.path,
    this.builder,
    this.pageFactory,
    this.children = const <MvcRouteBase>[],
  }) {
    _pathRegExp = patternToRegExp(path, pathParameters);
  }
  final String path;
  final List<String> pathParameters = <String>[];
  @override
  final List<MvcRouteBase> children;
  final MvcPathRouteBuilder? builder;
  final MvcPathRoutePageFactory? pageFactory;

  @override
  MvcPage createPage() {
    return pageFactory?.call() ?? MvcBuilderPage(builder!);
  }

  RegExpMatch? _matchPatternAsPrefix(String loc) => _pathRegExp.matchAsPrefix(loc) as RegExpMatch?;
  Map<String, String> _extractPathParams(RegExpMatch match) => extractPathParameters(pathParameters, match);

  late final RegExp _pathRegExp;

  @override
  MvcRouteMatchedLocation? match(MvcRouterParseContext context) {
    if (context.mapData is! MvcRouteUriMapData) {
      return null;
    }
    MvcRouteUriMapData mapData = context.mapData as MvcRouteUriMapData;
    final RegExpMatch? regExpMatch = _matchPatternAsPrefix(mapData.remainingLocation);
    if (regExpMatch == null) {
      return null;
    }
    final Map<String, String> encodedParams = _extractPathParams(regExpMatch);
    return RoutePathMatchLocation(
      location: regExpMatch.group(0)!,
      pathParameters: encodedParams,
    );
  }
}
