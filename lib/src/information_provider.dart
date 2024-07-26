import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mvc/flutter_mvc.dart';

import 'delegate.dart';

class MvcRouteInformationProvider extends RouteInformationProvider with ChangeNotifier, DependencyInjectionService {
  @override
  void routerReportsNewRouteInformation(RouteInformation routeInformation, {RouteInformationReportingType type = RouteInformationReportingType.none}) {
    SystemNavigator.selectMultiEntryHistory();
    SystemNavigator.routeInformationUpdated(
      uri: routeInformation.uri,
      state: routeInformation.state,
      replace: false,
    );
    _value = routeInformation;
  }

  @override
  RouteInformation get value => _value;
  late RouteInformation _value;

  @override
  FutureOr dependencyInjectionServiceInitialize() {
    // Uri platformDefaultUri = Uri.parse(
    //   WidgetsBinding.instance.platformDispatcher.defaultRouteName,
    // );
    // if (platformDefaultUri.hasEmptyPath) {
    //   platformDefaultUri = Uri(
    //     path: '/',
    //     queryParameters: platformDefaultUri.queryParameters,
    //   );
    // }
    final initialRouteMap = getService<MvcRouterDelegate>().rootRouteMap;
    _value = RouteInformation(uri: initialRouteMap.uri, state: initialRouteMap);
  }
}
