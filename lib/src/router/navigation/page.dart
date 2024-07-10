import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_mvc/flutter_mvc.dart';

import '../../route/page.dart';
import '../../route_map/map_data/controller.dart';
import '../../route_map/map_data/base.dart';
import 'basic.dart';

mixin MvcPageRouter on MvcBasicRouter, DependencyInjectionService {
  Future<dynamic> pushPage<T extends MvcPageController>({String? prefix, dynamic arguments}) {
    return pushRoute(
      MvcRoutePageMapData.fromController<T>(
        arguments: arguments,
        key: UniqueKey(),
      ),
    );
  }

  Future<dynamic> pushPageReplacement<T extends MvcPageController>({
    dynamic arguments,
    dynamic result,
  }) {
    return pushRouteReplacement(
      MvcRoutePageMapData.fromController<T>(
        arguments: arguments,
      ),
      result,
    );
  }

  Future<T?> pushPageAndRemoveUntil<T extends MvcPageController>(bool Function(MvcRouteMapDataBase) predicate, {dynamic arguments, dynamic result}) {
    return pushRouteAndRemoveUntil(
      MvcRoutePageMapData.fromController<T>(),
      predicate,
      result,
    );
  }

  void popUntilPage<T extends MvcPageController>() {
    popRouteUntil(
      (data) {
        if (data is MvcRoutePageMapData) {
          return data.controllerType == T;
        }
        return false;
      },
    );
  }

  void redirectPage<T extends MvcPageController>({dynamic arguments}) {
    redirectRoute(MvcRoutePageMapData.fromController<T>(arguments: arguments));
  }
}
