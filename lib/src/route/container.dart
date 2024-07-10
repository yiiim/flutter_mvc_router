import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';

import '../page.dart';
import '../parser/context.dart';
import '../route_info.dart';
import 'match_location/match_location.dart';
import 'page.dart';
import 'route.dart';

class MvcContainerRoute extends MvcRouteBase with MvcContainerRouteMixin {
  MvcContainerRoute({required this.children, this.builder});
  @override
  final List<MvcRouteBase> children;
  final Widget Function(BuildContext context, MvcRouteInfo routeInfo, Widget? child)? builder;

  @override
  MvcPage createPage() {
    return MvcBuilderPage(builder ?? (context, routeInfo, child) => child ?? const SizedBox());
  }

  @override
  MvcRouteMatchedLocation? match(MvcRouterParseContext context) {
    return MvcRouteAnyMatchLocation();
  }
}

class MvcPageContainerRoute<T extends MvcPageController> extends MvcRouteBase with MvcContainerRouteMixin {
  MvcPageContainerRoute({required this.children});
  @override
  final List<MvcRouteBase> children;

  @override
  MvcPage createPage() {
    return MvcBuilderPage(
      (context, routeInfo, child) {
        return Mvc<T, MvcPageModel>(model: MvcPageModel(routeInfo: routeInfo, child: child));
      },
    );
  }

  @override
  MvcRouteMatchedLocation? match(MvcRouterParseContext context) {
    return MvcRouteAnyMatchLocation();
  }
}
