import 'dart:async';

import 'package:flutter_mvc/flutter_mvc.dart';
import 'package:flutter_mvc_router/src/route_map/base.dart';

import '../../route_map/map_data/base.dart';
import '../../route_map/map_data/named.dart';
import 'basic.dart';

mixin MvcPathRouter on MvcBasicRouter, DependencyInjectionService {
  FutureOr<T?> pushNamed<T>(String name, {dynamic arguments}) {
    return pushRoute<T>(MvcRouteNamedMapData.fromNamed(name, arguments));
  }

  FutureOr<T?> pushNamedReplacement<T>(String name, {dynamic arguments, dynamic result}) {
    return pushRouteReplacement(
      MvcRouteNamedMapData.fromNamed(name, arguments),
      result,
    );
  }

  FutureOr<T?> pushNamedAndRemoveUntil<T>(String name, bool Function(MvcRouteMapDataBase) predicate, {dynamic arguments, dynamic result}) {
    return pushRouteAndRemoveUntil(
      MvcRouteNamedMapData.fromNamed(name, arguments),
      predicate,
      result,
    );
  }

  void popUntilNamed(String name) {
    popRouteUntil((data) {
      if (data is MvcRouteNamedMapData) {
        return data.name == name;
      }
      return false;
    });
  }

  void redirectNamed(
    String name, {
    dynamic arguments,
    int? branchCurrentIndex,
    List<MvcRouteMapBase>? branches,
    dynamic extraData,
  }) {
    redirectRoute(
      MvcRouteNamedMapData.fromNamed(
        name,
        arguments,
        branchCurrentIndex: branchCurrentIndex,
        branches: branches,
        extraData: extraData,
      ),
    );
  }
}
