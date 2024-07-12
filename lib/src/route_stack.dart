import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvc_router/flutter_mvc_router.dart';
import 'route_entity.dart';

typedef MvcRoutePredicate = bool Function(MvcRouteEntity route);
typedef MvcRouteDataParser = FutureOr<MvcRouteEntity> Function(MvcRouteMapDataBase data);

class MvcRouteStackChildMapResult extends MvcRouteMapParseResult {
  MvcRouteStackChildMapResult({
    required super.results,
    super.key,
    super.id,
  }) : super(
          map: MvcBasicRouteMap(results.map((e) => e.mapData).toList()),
        );
}

class MvcRouteStack extends ValueNotifier<List<MvcRouteEntity>> implements MvcRouteMapBase {
  final MvcRouterParser parser;
  MvcRouteStack? _parent;
  MvcRouteStack? _branchParent;
  bool isRoot = false;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  MvcRouteStack(super._value, this.parser, {this.key, this.id});
  factory MvcRouteStack.fromResult(MvcRouteMapParseResult result, MvcRouterParser parser) {
    List<MvcRouteEntity> enities = [];
    List<MvcRouteMapDataParseResult> children = [];
    for (var element in result.results) {
      if (enities.isNotEmpty) {
        if (enities.last.key == element.key) {
          enities.last.data = element.mapData;
          enities.last.route = element.route;
          if (element.child != null) {
            children.add(element.child!);
          }
          continue;
        } else if (children.isNotEmpty) {
          enities.last.child = MvcRouteStack.fromResult(
            MvcRouteStackChildMapResult(results: children),
            parser,
          );
          children = [];
        }
      }
      enities.add(
        MvcRouteEntity(
          data: element.mapData,
          route: element.route,
          key: element.key,
          branchCurrentIndex: element.branchCurrentIndex ?? 0,
          branches: element.branches?.map((e) => MvcRouteStack.fromResult(e, parser)).toList(),
          result: element.mapData.result,
        ),
      );
      if (element.child != null) {
        children.add(element.child!);
      }
    }
    if (children.isNotEmpty) {
      enities.last.child = MvcRouteStack.fromResult(
        MvcRouteStackChildMapResult(results: children),
        parser,
      );
    }
    return MvcRouteStack(enities, parser, key: result.key, id: result.id).._setUpChildrenParent();
  }

  void _setUpChildrenParent() {
    for (var element in value) {
      element.child?._parent = this;
      element.child?._setUpChildrenParent();
      for (var branch in element.branches ?? <MvcRouteStack>[]) {
        branch._branchParent = this;
        branch._setUpChildrenParent();
      }
    }
  }

  void _insertNewResult(MvcRouteMapDataParseResult entity, int index) {
    if (value.isNotEmpty) {
      if (index != 0) {
        if (value[index - 1].key == entity.key) {
          value[index - 1].data = entity.mapData;
          value[index - 1].route = entity.route;
          if (entity.child != null) {
            if (value[index - 1].child != null) {
              value[index - 1].child!._insertNewResult(entity.child!, value[index - 1].child!.length);
            } else {
              value[index - 1].child = MvcRouteStack.fromResult(
                MvcRouteStackChildMapResult(results: [entity.child!]),
                parser,
              ).._parent = this;
            }
          }
          notifyListeners();
          return;
        }
      }
      if (index < value.length) {
        if (value[index].key == entity.key) {
          if (entity.child != null) {
            if (value[index].child != null) {
              value[index].child!._insertNewResult(entity.child!, 0);
            } else {
              value[index].child = MvcRouteStack.fromResult(
                MvcRouteStackChildMapResult(results: [entity.child!]),
                parser,
              ).._parent = this;
            }
          }
          return;
        }
      }
    }
    value.add(
      MvcRouteEntity(
        data: entity.mapData,
        route: entity.route,
        key: entity.key,
        child: entity.child == null
            ? null
            : (MvcRouteStack.fromResult(
                MvcRouteStackChildMapResult(results: [entity.child!]),
                parser,
              ).._parent = this),
        result: entity.mapData.result,
        branchCurrentIndex: entity.branchCurrentIndex ?? 0,
        branches: entity.branches
            ?.map(
              (e) => MvcRouteStack.fromResult(e, parser)
                .._setUpChildrenParent()
                .._branchParent = this,
            )
            .toList(),
      ),
    );
    notifyListeners();
  }

  final List<MvcRouteEntity> _forwards = [];

  Future<T?> push<T>(MvcRouteMapDataParseResult route) {
    Completer<T?> completer = Completer();
    route.mapData.result = completer;
    _forwards.clear();
    _insertNewResult(route, value.length);
    return completer.future;
  }

  bool pop([dynamic result]) {
    if (value.isEmpty) return false;
    if (value.last.child?.value.isNotEmpty == true) {
      return value.last.child!.pop(result);
    }
    if (value.length == 1) {
      assert(_parent != null);
      return _parent?.pop(result) ?? false;
    }
    final routeEntity = value.removeLast();
    _forwards.add(routeEntity);
    routeEntity.result?.complete(result);
    if (value.isEmpty) {}
    notifyListeners();
    return true;
  }

  void forward() {
    if (_forwards.isNotEmpty) {
      final needForwardRoute = _forwards.removeLast();
      value.add(
        needForwardRoute.copyWith(
          result: Completer(),
        ),
      );
      notifyListeners();
    }
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
    _parent?.notifyListeners();
    _branchParent?.notifyListeners();
  }

  Future<T?> pushReplacement<T extends Object?>(MvcRouteMapDataParseResult newRoute, {Object? result}) {
    pop(result);
    return push(newRoute);
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(MvcRouteMapDataParseResult newRoute, MvcRoutePredicate predicate) {
    value.removeWhere((element) => predicate(element));
    return push(newRoute);
  }

  void popUntil(MvcRoutePredicate predicate) {
    value.removeWhere((element) => predicate(element));
    notifyListeners();
  }

  bool canPop() {
    return value.length > 1 ? true : (_parent?.canPop() ?? false);
  }

  bool canForward() {
    return _forwards.isNotEmpty ? true : (_parent?.canForward() ?? false);
  }

  bool get isCurrent {
    if (_parent == null && _branchParent == null) {
      return true;
    }
    if (_branchParent != null) {
      return _branchParent!.isCurrent && _branchParent!.currentRoute.branches![_branchParent!.currentRoute.branchCurrentIndex!] == this;
    }
    return _parent!.isCurrent;
  }

  MvcRouteEntity get currentRoute => value.last;

  bool get isEmpty => value.isEmpty;

  @override
  MvcRouteMapDataBase dataAtIndex(int index) {
    return value[index].data;
  }

  @override
  int get length => value.length;

  @override
  String serialization() {
    return MvcBasicRouteMap(value.map((e) => e.data).toList()).serialization();
  }

  @override
  Uri? get uri {
    for (var element in value.reversed) {
      if (element.data is MvcRouteUriMapData) {
        return (element.data as MvcRouteUriMapData).uri;
      }
    }
    return null;
  }

  @override
  Future<T?> operate<T>(MvcRouteOperate operate) async {
    switch (operate) {
      case MvcRouteOperateForward():
        assert(_forwards.isNotEmpty);
        forward();
        break;
      case MvcRouteOperatePop(result: final result):
        pop(result);
        break;
      case MvcRouteOperatePush(mapData: final data, router: final router):
        return push<T>(await parser.parseRouteMapData(data, router: router));
      case MvcRouteOperatePushReplacement(mapData: final data, router: final router):
        return pushReplacement<T>(await parser.parseRouteMapData(data, router: router));
      case MvcRouteOperatePushAndRemoveUntil(mapData: final data, predicate: final predicate, router: final router):
        return pushAndRemoveUntil<T>(await parser.parseRouteMapData(data, router: router), (entity) => predicate(entity.data));
      case MvcRouteOperatePopUntil(predicate: final predicate):
        popUntil((entity) => predicate(entity.data));
        break;
      case MvcRouteOperateRedirect(mapData: final data, router: final router):
        value.clear();
        push(await parser.parseRouteMapData(data, router: router));
        break;
      default:
    }
    return SynchronousFuture(null);
  }

  @override
  final String? id;

  @override
  final GlobalKey? key;
}
