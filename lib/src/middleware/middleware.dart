import 'dart:async';
import 'package:flutter_mvc/flutter_mvc.dart';

import '../parser/context.dart';
import '../parser/result.dart';

typedef RouteHandler = FutureOr<MvcRouteMapDataParseResult> Function(MvcRouterParseContext context, {bool restore});

class MvcRouterMiddleware with DependencyInjectionService {
  RouteHandler middleware(RouteHandler handler) => handler;
}
