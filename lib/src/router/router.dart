import 'package:flutter_mvc/flutter_mvc.dart';
import 'package:flutter_mvc_router/flutter_mvc_router.dart';

mixin MvcRouter on MvcPathRouter, MvcPageRouter, MvcBasicRouter, DependencyInjectionService {
  @override
  MvcRouterDelegate get delegate => getService<MvcRouterDelegate>();
  @override
  MvcRouteStack? get routeStack => tryGetService<MvcNavigatorController>()?.routeStack;
}
