import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';

import 'flutter_mvc_router.dart';

import 'src/serializer/manager.dart';
import 'src/serializer/map/default.dart';
import 'src/serializer/serializer.dart';


export 'src/middleware/middleware.dart';
export 'src/parser/user_info.dart';
export 'src/parser/parser.dart';
export 'src/parser/context.dart';
export 'src/parser/result.dart';
export 'src/route/container.dart';
export 'src/route/path.dart';
export 'src/route/page.dart';
export 'src/route/route.dart';
export 'src/route/match_location/match_location.dart';
export 'src/route/match_location/path.dart';
export 'src/route_map/base.dart';
export 'src/route_map/basic.dart';
export 'src/route_map/map_data/uri.dart';
export 'src/route_map/map_data/controller.dart';
export 'src/route_map/map_data/empty.dart';
export 'src/route_map/map_data/named.dart';
export 'src/serializer/map_data/uri.dart';
export 'src/router/router.dart';
export 'src/router/base.dart';
export 'src/router/navigation/basic.dart';
export 'src/router/navigation/page.dart';
export 'src/router/navigation/path.dart';
export 'src/information_parser.dart';
export 'src/router_config.dart';
export 'src/navigator.dart';
export 'src/information_provider.dart';
export 'src/delegate.dart';
export 'src/page.dart';
export 'src/route_info.dart';
export 'src/route_operate.dart';
export 'src/route_stack.dart';
export 'src/route_provider.dart';
export 'src/route_map/map_data/base.dart';

extension FlutterMvcRouter on ServiceCollection {
  void addMvcRouter({List<MvcRouteBase> routes = const []}) {
    addSingleton<RouteInformationProvider>((serviceProvider) => serviceProvider.get<MvcRouteInformationProvider>());
    addSingleton<RouteInformationParser<MvcRouteMapBase>>((serviceProvider) => serviceProvider.get<MvcRouteInformationParser>());
    addSingleton<RouterDelegate>((serviceProvider) => MvcRouterDelegate(), initializeWhenServiceProviderBuilt: true);
    addSingleton((serviceProvider) => MvcRouteInformationParser());
    addSingleton((serviceProvider) => MvcRouterDelegate());
    addSingleton((serviceProvider) => MvcRouteInformationProvider());
    addSingleton((serviceProvider) => MvcRouterParser());
    addSingleton((serviceProvider) => MvcRouter());
    addSingleton<MvcRouterBase>((serviceProvider) => serviceProvider.get<MvcRouter>());
    addSingleton((serviceProvider) => MvcRouterSerializerManager());
    addSingleton((serviceProvider) => MvcNotFoundRoute());
    addSingleton<RouteMapDataSerializer<MvcRouteUriMapData>>(
      (serviceProvider) => MvcRouteUriMapDataSerializer(),
      initializeWhenServiceProviderBuilt: true,
    );
    addSingleton<RouteMapSerializer<MvcRouteMapBase>>(
      (serviceProvider) => DefaultMvcRouteMapSerializer(),
      initializeWhenServiceProviderBuilt: true,
    );
    addSingleton<ServiceObserver<RouteSerializerBase>>((serviceProvider) => serviceProvider.get<MvcRouterSerializerManager>());
    addSingleton<MvcRouterConfig>(
      (serviceProvider) => MvcRouterConfig(
        routerDelegate: serviceProvider.get<MvcRouterDelegate>(),
        routeInformationProvider: serviceProvider.get<RouteInformationProvider>(),
        routeInformationParser: serviceProvider.get<RouteInformationParser<MvcRouteMapBase>>(),
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
      initializeWhenServiceProviderBuilt: true,
    );
    addController((serviceProvider) => MvcNavigatorController());
  }


  void addMvcRouterMiddleware<T extends MvcRouterMiddleware>(T Function(ServiceProvider serviceProvider) factory) {
    add<T>(factory);
    configure<MvcRouterParser>((service) => service.middlewareTypes.add(T));
  }
}
