import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';
import 'package:flutter_mvc_router/flutter_mvc_router.dart';

abstract class MvcRouteProvider {
  List<MvcRouteBase> routes();
}

class MvcDefaultRouteProvider extends MvcRouteProvider {
  final List<MvcRouteBase> _routes;
  MvcDefaultRouteProvider({required List<MvcRouteBase> routes}) : _routes = routes;
  @override
  List<MvcRouteBase> routes() => _routes;
}

class MvcRouteProviderWidget extends MvcStatefulWidget {
  final List<MvcRouteBase> routes;
  final Widget child;
  const MvcRouteProviderWidget({required this.routes, required this.child, super.key});
  @override
  MvcWidgetState<MvcStatefulWidget> createState() => _MvcRouteProviderWidgetState();
}

class _MvcRouteProviderWidgetState extends MvcWidgetState<MvcRouteProviderWidget> implements MvcRouteProvider {
  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void initServices(ServiceCollection collection, ServiceProvider? parent) {
    super.initServices(collection, parent);
    collection.addSingleton<MvcRouteProvider>((serviceProvider) => this);
  }

  @override
  List<MvcRouteBase> routes() => widget.routes;
}
