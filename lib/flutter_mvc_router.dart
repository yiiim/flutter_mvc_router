import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';

import 'flutter_mvc_router.dart';

import 'src/serializer/manager.dart';
import 'src/serializer/map/default.dart';
import 'src/serializer/serializer.dart';

export 'src/middleware/middleware.dart';
export 'src/parser/parser.dart';
export 'src/parser/context.dart';
export 'src/parser/result.dart';
export 'src/route/path.dart';
export 'src/route/page.dart';
export 'src/route/route.dart';
export 'src/route/match_location/match_location.dart';
export 'src/route/match_location/path.dart';
export 'src/route_map/base.dart';
export 'src/route_map/basic.dart';
export 'src/route_map/map_data/uri.dart';
export 'src/route_map/map_data/page.dart';
export 'src/route_map/map_data/empty.dart';
export 'src/route_map/map_data/named.dart';
export 'src/serializer/map_data/uri.dart';
export 'src/router/basic.dart';
export 'src/router/page.dart';
export 'src/router/path.dart';
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
export 'src/router/router.dart';

extension FlutterMvcRouter on ServiceCollection {
  void addMvcRouter({List<MvcRouteBase> routes = const []}) {
    addSingleton<RouteInformationProvider>((serviceProvider) => serviceProvider.get<MvcRouteInformationProvider>());
    addSingleton<RouteInformationParser<MvcRouterMapBase>>((serviceProvider) => serviceProvider.get<MvcRouteInformationParser>());
    addSingleton<RouterDelegate>((serviceProvider) => serviceProvider.get<MvcRouterDelegate>(), initializeWhenServiceProviderBuilt: true);
    addSingleton((serviceProvider) => MvcRouteInformationParser());
    addSingleton((serviceProvider) => MvcRouterDelegate());
    addSingleton((serviceProvider) => MvcRouteInformationProvider());
    addSingleton((serviceProvider) => MvcRouterParser());
    addSingleton<MvcRouter>((serviceProvider) => serviceProvider.get<MvcRouterDelegate>());
    addSingleton((serviceProvider) => MvcRouterSerializerManager());
    addSingleton((serviceProvider) => MvcNotFoundRoute());
    addSingleton<RouteMapDataSerializer<MvcRouterUriPath>>(
      (serviceProvider) => MvcRouteUriMapDataSerializer(),
      initializeWhenServiceProviderBuilt: true,
    );
    addSingleton<RouteMapSerializer<MvcRouterMapBase>>(
      (serviceProvider) => DefaultMvcRouteMapSerializer(),
      initializeWhenServiceProviderBuilt: true,
    );
    addSingleton<ServiceObserver<RouteSerializerBase>>((serviceProvider) => serviceProvider.get<MvcRouterSerializerManager>());
    addSingleton<MvcRouterConfig>(
      (serviceProvider) => MvcRouterConfig(
        routerDelegate: serviceProvider.get<MvcRouterDelegate>(),
        routeInformationProvider: serviceProvider.get<RouteInformationProvider>(),
        routeInformationParser: serviceProvider.get<RouteInformationParser<MvcRouterMapBase>>(),
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
      initializeWhenServiceProviderBuilt: true,
    );
  }

  void addMvcRouterMiddleware<T extends MvcRouterMiddleware>(T Function(ServiceProvider serviceProvider) factory) {
    add<T>(factory);
    configure<MvcRouterParser>((service) => service.middlewareTypes.add(T));
  }
}
