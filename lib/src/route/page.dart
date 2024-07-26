import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';

import '../page.dart';
import '../parser/context.dart';
import '../route_info.dart';
import '../route_map/map_data/page.dart';
import '../router/basic.dart';
import '../router/page.dart';
import '../router/path.dart';
import '../router/router.dart';
import 'match_location/match_location.dart';
import 'path.dart';

class MvcPageModel {
  const MvcPageModel({required this.routeInfo, this.child});
  final MvcRouteInfo routeInfo;
  final Widget? child;
}

abstract class MvcPageControllerBase extends MvcController<MvcPageModel> {}

abstract class MvcPageController extends MvcPageControllerBase with MvcBasicRouter, MvcPathRouter, MvcPageRouter, MvcRouter {
  T? args<T>() => model.routeInfo.args<T>();
  T? argsForKey<T>(String key) => model.routeInfo.argsForKey<T>(key);
}

class _MvcControllerRoutePage<T extends MvcPageController> extends MvcPage {
  @override
  Widget buildContent(BuildContext context, Widget? child) {
    return Mvc<T, MvcPageModel>(model: MvcPageModel(routeInfo: routeInfo, child: child));
  }
}

class MvcPageRoute<T extends MvcPageController> extends MvcPathRoute {
  MvcPageRoute({String? path})
      : super(
          path: path ?? T.toString(),
          pageFactory: () => _MvcControllerRoutePage<T>(),
        );
  @override
  MvcRouteMatchedLocation? match(MvcRouterParseContext context) {
    if (context.mapData is MvcRouterPagePath && (context.mapData as MvcRouterPagePath).controllerType == T) {
      return MvcRouteAllMatchLocation();
    }
    return super.match(context);
  }
}
