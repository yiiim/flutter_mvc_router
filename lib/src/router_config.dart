import 'package:flutter/widgets.dart';
import 'package:flutter_mvc/flutter_mvc.dart';

import 'route_map/base.dart';

class MvcRouterConfig extends RouterConfig<MvcRouteMapBase> with DependencyInjectionService {
  MvcRouterConfig({
    super.routeInformationProvider,
    super.routeInformationParser,
    required super.routerDelegate,
    super.backButtonDispatcher,
  });
}
