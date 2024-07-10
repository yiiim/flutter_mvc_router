import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';

import '../page.dart';
import '../parser/context.dart';
import '../route_info.dart';
import '../route_map/map_data/controller.dart';
import '../parser/user_info.dart';
import '../router/base.dart';
import '../router/navigation/basic.dart';
import '../router/navigation/page.dart';
import '../router/navigation/path.dart';
import '../router/router.dart';
import 'match_location/match_location.dart';
import 'path.dart';

class MvcPageModel {
  const MvcPageModel({required this.routeInfo, this.child});
  final MvcRouteInfo routeInfo;
  final Widget? child;
}

abstract class MvcPageControllerBase extends MvcController<MvcPageModel> implements MvcRouterBase {}

abstract class MvcPageController extends MvcPageControllerBase with MvcBasicRouter, MvcPathRouter, MvcPageRouter, MvcMixinRouter {
  late final router = getService<MvcPageRouter>();
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
  MvcPageRoute({String? path, super.children = const []})
      : super(
          path: path ?? T.toString(),
          pageFactory: () => _MvcControllerRoutePage<T>(),
        );
  @override
  MvcRouteMatchedLocation? match(MvcRouterParseContext<MvcRouterParseUserInfo> context) {
    if (context.mapData is MvcRoutePageMapData && (context.mapData as MvcRoutePageMapData).controllerType == T) {
      return MvcRouteAllMatchLocation();
    }
    return super.match(context);
  }
}
