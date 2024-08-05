import 'package:flutter/material.dart';
import 'package:flutter_mvc_router/flutter_mvc_router.dart';

abstract class MvcRouteBase {
  MvcRouteBase();

  Uri? get uri;

  MvcPage createPage();
  MvcRouteMatchedLocation? match(MvcRouterParseContext context) => null;
}

abstract class MvcBranchedRouteBase {
  (int index, List<MvcRouterMapBase> branch) branchs(MvcRouterMapBase map);
}

class MvcNotFoundRoute extends MvcRouteBase {
  MvcNotFoundRoute({this.builder});
  final Widget Function(BuildContext context, MvcRouteInfo routeInfo, Widget? child)? builder;

  @override
  MvcPage createPage() {
    return MvcBuilderPage(builder ?? (context, routeInfo, child) => const Center(child: Text("Not Found")));
  }

  @override
  Uri? get uri => null;
}
