import 'package:flutter/widgets.dart';
import 'package:flutter_mvc/flutter_mvc.dart';
import 'package:flutter_mvc_router/src/route_map/map_data/uri.dart';

class MvcRouteInformationProvider extends PlatformRouteInformationProvider with DependencyInjectionService {
  MvcRouteInformationProvider()
      : super(
          initialRouteInformation: RouteInformation(
            uri: Uri.parse(WidgetsBinding.instance.platformDispatcher.defaultRouteName),
            state: MvcRouterUriPath.fromUri(
              Uri.parse(
                WidgetsBinding.instance.platformDispatcher.defaultRouteName,
              ),
            ),
          ),
        );

  // @override
  // void routerReportsNewRouteInformation(RouteInformation routeInformation, {RouteInformationReportingType type = RouteInformationReportingType.none}) {
  //   SystemNavigator.selectMultiEntryHistory();
  //   SystemNavigator.routeInformationUpdated(
  //     uri: routeInformation.uri,
  //     state: routeInformation.state,
  //     replace: false,
  //   );
  //   _value = routeInformation;
  // }

  // @override
  // RouteInformation get value => _value;
  // late RouteInformation _value;

  // @override
  // FutureOr dependencyInjectionServiceInitialize() {
  //   // Uri platformDefaultUri = Uri.parse(
  //   //   WidgetsBinding.instance.platformDispatcher.defaultRouteName,
  //   // );
  //   // if (platformDefaultUri.hasEmptyPath) {
  //   //   platformDefaultUri = Uri(
  //   //     path: '/',
  //   //     queryParameters: platformDefaultUri.queryParameters,
  //   //   );
  //   // }
  //   final initialRouteMap = getService<MvcRouterDelegate>().rootRouteMap;
  //   _value = RouteInformation(uri: initialRouteMap.uri, state: initialRouteMap);
  // }
}
