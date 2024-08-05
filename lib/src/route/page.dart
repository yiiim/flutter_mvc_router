import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';
import 'package:flutter_mvc_router/src/route_info.dart';

import '../page.dart';
import '../parser/context.dart';
import '../route_map/map_data/page.dart';
import 'match_location/match_location.dart';
import 'path.dart';

class _MvcControllerRoutePage<TModelType, TControllerType extends MvcController<TModelType>> extends MvcPage {
  _MvcControllerRoutePage({this.modelCreate, this.create});

  final TControllerType Function(MvcRouteInfo routeInfo)? create;
  final TModelType Function(MvcRouteInfo routeInfo)? modelCreate;
  @override
  Widget buildContent(BuildContext context, Widget? child) {
    return Mvc<TControllerType, TModelType>(
      model: modelCreate?.call(routeInfo) as TModelType,
      create: create == null ? null : () => create!.call(routeInfo),
    );
  }
}

class MvcPageRoute<TModelType, TControllerType extends MvcController<TModelType>> extends MvcPathRoute {
  MvcPageRoute({
    String? path,
    TControllerType Function(MvcRouteInfo routeInfo)? create,
    final TModelType Function(MvcRouteInfo routeInfo)? modelCreate,
  }) : super(
          path: path ?? TControllerType.toString(),
          pageFactory: () => _MvcControllerRoutePage<TModelType, TControllerType>(
            modelCreate: modelCreate,
            create: create,
          ),
        );
  @override
  MvcRouteMatchedLocation? match(MvcRouterParseContext context) {
    if (context.mapData is MvcRouterPagePath && (context.mapData as MvcRouterPagePath).controllerType == TControllerType) {
      return MvcRouteAllMatchLocation();
    }
    return super.match(context);
  }
}
