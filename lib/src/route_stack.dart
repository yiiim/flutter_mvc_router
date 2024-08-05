import 'dart:async';

import 'package:collection/collection.dart';
import 'package:path/path.dart';
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
        _branchParent = branchParent;
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

  void _insertNewResult(MvcRouteEntity entity, int index) {
    value.insert(
      index,
      entity,
    );
    notifyListeners();
  }

  Future<T?> push<T>(MvcRouteEntity route) {
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

  Future<T?> forward<T>() {
    if (_forwards.isNotEmpty) {
      final needForwardRoute = _forwards.removeLast();
      final completer = Completer<T>();
      value.add(
        needForwardRoute.copyWith(
          result: completer,
        ),
      );
      notifyListeners();
      return completer.future;
    }
    return Future.value(null);
  }

  Future<T?> pushReplacement<T extends Object?>(MvcRouteEntity newRoute, {Object? result}) {
    pop(result: result);
    return push(newRoute);
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(MvcRouteEntity newRoute, MvcRoutePredicate predicate) {
    value.removeWhere((element) => predicate(element));
    return push(newRoute);
  }

  bool popUntil(MvcRoutePredicate predicate) {
    final removed = value.where((element) => predicate(element));
    for (var element in removed) {
      value.remove(element);
    }
    notifyListeners();
    return removed.isNotEmpty;
  }

  Future<T?> redirect<T>(MvcRouteEntity route) {
    value.clear();
    return push(route);
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
    Uri? effectiveUri;
    if (_child != null) {
      effectiveUri = _child?.uri;
    } else if (_branchChildren != null) {
      effectiveUri = branchActive?.uri;
    }
    MvcRouteEntity? effectiveEntity = value.lastWhereOrNull((element) => element.uri != null);
    Uri? selfUri = effectiveEntity?.uri?.replace(
      queryParameters: effectiveEntity.mapData.args<Map<String, dynamic>>(),
    );
    if (selfUri != null && effectiveUri != null) {
      return effectiveUri.replace(
        path: join(
          selfUri.path,
          effectiveUri.path,
        ),
        queryParameters: effectiveEntity?.mapData.args<Map<String, dynamic>>(),
      );
    } else if (effectiveUri != null) {
      return effectiveUri;
    } else if (selfUri != null) {
      return selfUri;
    }
    return Uri.parse("/");
  }
}
