import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';
import 'package:flutter_mvc_router/flutter_mvc_router.dart';
import 'package:flutter_mvc_router/src/parser/map_parse_delegate.dart';
import 'package:flutter_mvc_router/src/router/router.dart';

import 'route_entity.dart';

class MvcNavigatorBranchController extends ValueNotifier<int> with DependencyInjectionService {
  MvcNavigatorBranchController(
    super.value, {
    required this.maps,
    required this.navigatorController,
  }) : _branchActive = List.generate(maps.length, (index) => index == value);
  MvcNavigatorController navigatorController;
  final List<MvcRouterMapBase> maps;
  MvcRouterMapBase get currentMap => maps[value];
  int get branchCount => maps.length;
  final List<bool> _branchActive;
  List<MvcRouterMapPathBase> branchDataAt(int index) => maps[index].paths;
  Widget buildBranch(int index) {
    return MvcBuilder(
      id: "#branch_$index",
      builder: (context) {
        if (_branchActive[index]) {
          return Mvc(
            create: () => MvcNavigatorController(
              branchParent: navigatorController,
              branchController: this,
              branchIndex: index,
              initialMap: maps[index],
            ),
          );
        }
        return Container();
      },
    );
  }

  @override
  set value(int newValue) {
    super.value = newValue;
    if (!_branchActive[newValue]) {
      _branchActive[newValue] = true;
    }
  }
}

class MvcNavigatorController extends MvcController with MvcRouterMixinMapParseDelegate, MvcBasicRouter, MvcPathRouter, MvcPageRouter, MvcRouter, ChangeNotifier {
  MvcNavigatorController({
    MvcNavigatorController? parent,
    MvcNavigatorController? branchParent,
    MvcNavigatorBranchController? branchController,
    required MvcRouterMapBase initialMap,
    int? branchIndex,
  })  : _parent = parent,
        _branchParent = branchParent,
        _branchController = branchController,
        _branchIndex = branchIndex,
        _initialMap = initialMap {
    if (branchController != null) {
      branchController.addListener(_branchActiveUpdate);
    }
  }
  late final MvcRouterParser _parser = getService();
  late final MvcRouteProvider _routeProvider = getService();

  final MvcRouterMapBase _initialMap;
  final MvcNavigatorController? _parent;
  final MvcNavigatorController? _branchParent;
  final MvcNavigatorBranchController? _branchController;
  final int? _branchIndex;
  List<Page>? _pages;
  MvcRouteStack? routeStack;

  @override
  List<MvcRouteBase> get routes => _routeProvider.routes();
  @override
  MvcNavigatorController? get navigatorController => this;

  Future replaceMap<T>(MvcRouterMapBase map) async {
    return _parseMap(map);
  }

  Future<T?> operate<T>(MvcRouteOperate operate) async {
    assert(routeStack != null);
    final operateResult = switch (operate) {
      MvcRouteOperateForward() => await routeStack!.forward(),
      MvcRouteOperatePop(result: final result) => routeStack!.pop(result: result),
      MvcRouteOperatePush(mapData: final data) => await routeStack!.push<T>(
          MvcRouteEntity.fromResult(
            await _parser.parseRouteMapData(
              routeStack!,
              data,
              mapParseDelegate: this,
            ),
          ),
        ),
      MvcRouteOperatePushReplacement(mapData: final data) => await routeStack!.pushReplacement<T>(
          MvcRouteEntity.fromResult(
            await _parser.parseRouteMapData(
              routeStack!,
              data,
              mapParseDelegate: this,
            ),
          ),
        ),
      MvcRouteOperatePushAndRemoveUntil(mapData: final data, predicate: final predicate) => await routeStack!.pushAndRemoveUntil<T>(
          MvcRouteEntity.fromResult(
            await _parser.parseRouteMapData(routeStack!, data, mapParseDelegate: this),
          ),
          (entity) => predicate(entity.mapData),
        ),
      MvcRouteOperatePopUntil(predicate: final predicate) => routeStack!.popUntil((entity) => predicate(entity.mapData)),
      MvcRouteOperateRedirect(mapData: final data) => await routeStack!.redirect(
          MvcRouteEntity.fromResult(
            await _parser.parseRouteMapData(
              routeStack!,
              data,
              mapParseDelegate: this,
            ),
          ),
        ),
      _ => null
    };
    if (operateResult is T) {
      return operateResult;
    }
    return null;
  }

  Future _parseMap(MvcRouterMapBase map) async {
    routeStack?.removeListener(_routeStackUpdate);
    routeStack = MvcRouteStack.fromResult(
      await _parser.parseRouteMap(map, mapParseDelegate: this),
      _parser,
      parent: _parent?.routeStack,
      branchParent: _branchParent?.routeStack,
      branchIndex: _branchIndex,
    );
    routeStack?.addListener(_routeStackUpdate);
    if (_branchController != null && _branchParent != null && _branchIndex == _branchController?.value) {
      _branchParent?.routeStack?.branchActive = routeStack;
    }
    _routeStackUpdate();
  }

  void _branchActiveUpdate() {
    if (_branchController != null) {
      if (_branchIndex == _branchController!.value) {
        _branchParent?.routeStack?.branchActive = routeStack;
      }
    }
  }

  void _childUpdate() {
    notifyListeners();
  }

  void _branchUpdate() {
    notifyListeners();
  }

  void _routeStackUpdate() {
    _update();
    notifyListeners();
    _parent?._childUpdate();
    _branchParent?._branchUpdate();
  }

  @override
  void init() {
    super.init();
    _parseMap(_initialMap);
  }

  @override
  void initServices(ServiceCollection collection) {
    super.initServices(collection);
    collection.addSingleton<MvcRouter>((serviceProvider) => this);
    collection.addSingleton<MvcRouterMapParseDelegate>((serviceProvider) => this);
  }

  @override
  MvcView<MvcController> view() {
    return MvcViewBuilder(
      (controller) {
        if (routeStack == null) {
          return const SizedBox.shrink();
        }
        if (_pages == null) {
          _update();
        }
        return MvcBuilder(
          id: routeStack!.id,
          classes: const ["mvc_navigator"],
          builder: (context) {
            return Column(
              children: [
                Expanded(
                  child: Navigator(
                    key: routeStack!.key,
                    pages: _pages!,
                    onPopPage: (route, result) {
                      if (!route.didPop(result)) {
                        return false;
                      }
                      return routeStack?.pop() ?? true;
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _update() {
    List<Page> newPages = [];
    for (var element in routeStack?.value ?? <MvcRouteEntity>[]) {
      newPages.add(
        MaterialPage(
          key: element.key ?? element.mapData.key,
          child: Builder(
            builder: (context) {
              Widget? child;
              if (element.remainingPath != null && !element.remainingPath!.isEmpty) {
                child = Builder(
                  builder: (context) {
                    return Mvc(
                      create: () => MvcNavigatorController(
                        parent: this,
                        initialMap: MvcRouterBasicMap([element.remainingPath!]),
                      ),
                    );
                  },
                );
              }
              return MvcDependencyProvider(
                child: MvcBuilder(
                  builder: (context) {
                    return context.getService<MvcPage>().buildContent(context, child);
                  },
                ),
                provider: (collection) {
                  collection.add<MvcPage>((serviceProvider) => element.route.createPage());
                  collection.addSingleton((serviceProvider) => element.mapData);
                  collection.addSingleton((serviceProvider) => element);
                  collection.addSingleton((serviceProvider) => element.route);
                  collection.addSingleton((serviceProvider) => MvcRouteInfo(route: element.route, routeData: element.mapData, child: child));
                  if (element.route is MvcBranchedRouteBase) {
                    final map = MvcRouterBasicMap([element.remainingPath ?? MvcRouterEmptyPath()]);
                    final (int index, List<MvcRouterMapBase> maps) = (element.route as MvcBranchedRouteBase).branchs(map);
                    collection.addSingleton(
                      (serviceProvider) => MvcNavigatorBranchController(
                        index,
                        maps: maps,
                        navigatorController: this,
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      );
    }
    _pages = newPages;
    update();
  }
}
