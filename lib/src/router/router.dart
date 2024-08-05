import 'package:flutter_mvc/flutter_mvc.dart';
import 'package:flutter_mvc_router/flutter_mvc_router.dart';

mixin MvcRouter on MvcPathRouter, MvcPageRouter, MvcBasicRouter, DependencyInjectionService {
  @override
  MvcRouterDelegate get delegate => getService();

  @override
  MvcNavigatorController? get navigatorController => getService();
}
