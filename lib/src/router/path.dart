import 'dart:async';

import '../route_map/map_data/base.dart';
import '../route_map/map_data/named.dart';
import 'basic.dart';

mixin MvcPathRouter on MvcBasicRouter {
  FutureOr<T?> pushNamed<T>(String name, {dynamic arguments}) {
    return pushRoute<T>(MvcRouterNamedPath.fromNamed(name, arguments));
  }

  FutureOr<T?> pushNamedReplacement<T>(String name, {dynamic arguments, dynamic result}) {
    return pushRouteReplacement(
      MvcRouterNamedPath.fromNamed(name, arguments),
      result,
    );
  }

  FutureOr<T?> pushNamedAndRemoveUntil<T>(String name, bool Function(MvcRouterMapPathBase) predicate, {dynamic arguments, dynamic result}) {
    return pushRouteAndRemoveUntil(
      MvcRouterNamedPath.fromNamed(name, arguments),
      predicate,
      result,
    );
  }

  void popUntilNamed(String name) {
    popRouteUntil((data) {
      if (data is MvcRouterNamedPath) {
        return data.name == name;
      }
      return false;
    });
  }

  void redirectNamed(
    String name, {
    dynamic arguments,
    dynamic extraData,
  }) {
    redirectRoute(
      MvcRouterNamedPath.fromNamed(
        name,
        arguments,
        extraData: extraData,
      ),
    );
  }
}
