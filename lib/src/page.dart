import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';

import 'route_info.dart';

abstract class MvcPage with DependencyInjectionService {
  late final MvcRouteInfo routeInfo = getService();

  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) => child;
  Widget buildContent(BuildContext context, Widget? child);
}

class MvcBuilderPage extends MvcPage {
  MvcBuilderPage(this.builder);
  final Widget Function(BuildContext context, MvcRouteInfo routeInfo, Widget? child) builder;
  @override
  Widget buildContent(BuildContext context, Widget? child) {
    return builder(context, routeInfo, child);
  }
}
