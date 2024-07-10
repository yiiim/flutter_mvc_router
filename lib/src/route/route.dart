import 'package:flutter/material.dart';

import '../parser/context.dart';
import '../page.dart';
import '../route_info.dart';
import 'match_location/match_location.dart';

abstract class MvcRouteBase {
  MvcPage createPage();
  MvcRouteMatchedLocation? match(MvcRouterParseContext context) => null;
}

mixin MvcContainerRouteMixin on MvcRouteBase {
  List<MvcRouteBase> get children;
}

class MvcNotFoundRoute extends MvcRouteBase {
  MvcNotFoundRoute({this.builder});
  final Widget Function(BuildContext context, MvcRouteInfo routeInfo, Widget? child)? builder;

  @override
  MvcPage createPage() {
    return MvcBuilderPage(builder ?? (context, routeInfo, child) => const Center(child: Text("Not Found")));
  }
}
