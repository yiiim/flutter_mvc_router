import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvc_router/flutter_mvc_router.dart';
import 'route_entity.dart';

typedef MvcRoutePredicate = bool Function(MvcRouteEntity route);

class MvcRouteStack extends ValueNotifier<List<MvcRouteEntity>> implements MvcRouterMapBase {
  MvcRouteStack._(
    super._value,
    this.parser,
    this.map, {
    this.id,
    MvcRouteStack? parent,
    MvcRouteStack? branchParent,
    int? branchIndex,
  })  : _parent = parent,
        _branchParent = branchParent,
        _branchIndex = branchIndex;
  factory MvcRouteStack.fromResult(
    MvcRouterMapParseResult result,
    MvcRouterParser parser, {
    MvcRouteStack? parent,
    MvcRouteStack? branchParent,
    int? branchIndex,
  }) {
    final stack = MvcRouteStack._(
      result.paths.map((e) => MvcRouteEntity.fromResult(e)).toList(),
      parser,
      result.map,
      id: result.id,
      parent: parent,
      branchParent: branchParent,
      branchIndex: branchIndex,
    );
    if (parent != null) {
      parent._child = stack;
    }
    if (branchParent != null) {
      branchParent._branchChildren ??= [];
      branchParent._branchChildren!.add(stack);
    }
    return stack;
  }

  final MvcRouterParser parser;
  final MvcRouterMapBase map;
  final MvcRouteStack? _parent;
  MvcRouteStack? _child;
  final MvcRouteStack? _branchParent;
  final int? _branchIndex;
  List<MvcRouteStack>? _branchChildren;
  final List<MvcRouteEntity> _forwards = [];
  MvcRouteStack? branchActive;

  MvcRouteStack get topStack {
    if (_child != null) {
      return _child!.topStack;
    } else if (_branchChildren != null) {
      return branchActive!.topStack;
    } else {
      return this;
    }
  }

  void _insertNewResult(MvcRouterMapPathParseResult entity, int index) {
    value.insert(
      index,
      MvcRouteEntity.fromResult(entity),
    );
    notifyListeners();
  }

  Future<T?> push<T>(MvcRouterMapPathParseResult route) {
    Completer<T?> completer = Completer();
    route.mapData.result = completer;
    _forwards.clear();
    _insertNewResult(route, value.length);
    return completer.future;
  }

  bool pop({
    dynamic result,
  }) {
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

  Future<T?> pushReplacement<T extends Object?>(MvcRouterMapPathParseResult newRoute, {Object? result}) {
    pop(result: result);
    return push(newRoute);
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(MvcRouterMapPathParseResult newRoute, MvcRoutePredicate predicate) {
    value.removeWhere((element) => predicate(element));
    return push(newRoute);
  }

  void popUntil(MvcRoutePredicate predicate) {
    value.removeWhere((element) => predicate(element));
    notifyListeners();
  }

  bool canPop({
    bool useChildPop = false,
    bool useBranchPop = false,
  }) {
    return value.length > 1 ? true : (_parent?.canPop() ?? false);
  }

  bool canForward() {
    return _forwards.isNotEmpty ? true : (_parent?.canForward() ?? false);
  }

  bool get isCurrent {
    if (_parent == null && _branchParent == null) {
      return true;
    } else if (_parent == null && _branchParent != null) {
      return _branchParent!.branchActive == this;
    } else if (_parent != null && _branchParent == null) {
      return _parent!.isCurrent;
    } else {
      return _parent!.isCurrent && _branchParent!.branchActive == this;
    }
  }

  MvcRouteEntity get currentRoute => value.last;

  bool get isEmpty => value.isEmpty;

  @override
  String serialization() {
    return MvcRouterBasicMap(value.map((e) => e.mapData).toList()).serialization();
  }

  @override
  Future<T?> operate<T>(MvcRouteOperate operate) async {
    switch (operate) {
      case MvcRouteOperateForward():
        assert(_forwards.isNotEmpty);
        forward();
        break;
      case MvcRouteOperatePop(result: final result):
        pop(result: result);
        break;
      case MvcRouteOperatePush(mapData: final data, router: final router):
        return push<T>(await parser.parseRouteMapData(this, data, mapParser: router));
      case MvcRouteOperatePushReplacement(mapData: final data, router: final router):
        return pushReplacement<T>(await parser.parseRouteMapData(this, data, mapParser: router));
      case MvcRouteOperatePushAndRemoveUntil(mapData: final data, predicate: final predicate, router: final router):
        return pushAndRemoveUntil<T>(await parser.parseRouteMapData(this, data, mapParser: router), (entity) => predicate(entity.mapData));
      case MvcRouteOperatePopUntil(predicate: final predicate):
        popUntil((entity) => predicate(entity.mapData));
        break;
      case MvcRouteOperateRedirect(mapData: final data, router: final router):
        value.clear();
        push(await parser.parseRouteMapData(this, data, mapParser: router));
        break;
      default:
    }
    return SynchronousFuture(null);
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
    _parent?.notifyListeners();
    _branchParent?.notifyListeners();
  }

  @override
  final String? id;

  @override
  GlobalKey<NavigatorState> get key => map.key;

  @override
  List<MvcRouterMapPathBase> get paths => map.paths;

  @override
  Uri? get uri {
    if (_child != null) {
      return _child?.uri;
    } else if (_branchChildren != null) {
      return branchActive?.uri;
    } else {
      for (var element in value.reversed) {
        if (element.uri != null) {
          return element.uri;
        }
      }
    }
    return Uri.parse("/");
  }
}
