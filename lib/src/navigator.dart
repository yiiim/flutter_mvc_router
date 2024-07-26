import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';
import 'package:flutter_mvc_router/flutter_mvc_router.dart';
import 'package:flutter_mvc_router/src/parser/map_parser.dart';
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
            ),
            model: maps[index],
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

class MvcNavigatorController extends MvcController<MvcRouterMapBase> with MvcRouterMixinMapParser, MvcBasicRouter, MvcPathRouter, MvcPageRouter, MvcRouter {
  MvcNavigatorController({
    MvcNavigatorController? parent,
    MvcNavigatorController? branchParent,
    MvcNavigatorBranchController? branchController,
    int? branchIndex,
  })  : _parent = parent,
        _branchParent = branchParent,
        _branchController = branchController,
        _branchIndex = branchIndex {
    if (branchController != null) {
      branchController.addListener(_branchActiveUpdate);
    }
  }

  final MvcNavigatorController? _parent;
  final MvcNavigatorController? _branchParent;
  final MvcNavigatorBranchController? _branchController;
  final int? _branchIndex;
  List<Page>? _pages;

  bool _parsing = false;
  @override
  MvcRouteStack? routeStack;

  Future<T?> operate<T>(MvcRouteOperate operate) async => await routeStack?.operate<T>(operate);

  Future _parseModel() async {
    update(() => _parsing = true);
    routeStack?.removeListener(_update);
    routeStack = MvcRouteStack.fromResult(
      await getService<MvcRouterParser>().parseRouteMap(
        model,
        mapParser: getService<MvcRouterMapParser>(),
      ),
      getService<MvcRouterParser>(),
      parent: _parent?.routeStack,
      branchParent: _branchParent?.routeStack,
      branchIndex: _branchIndex,
    );
    routeStack?.addListener(_update);
    if (_branchController != null && _branchParent != null && _branchIndex == _branchController?.value) {
      _branchParent?.routeStack?.branchActive = routeStack;
    }
    update(() => _parsing = false);
  }

  void _branchActiveUpdate() {
    if (_branchController != null) {
      if (_branchIndex == _branchController!.value) {
        _branchParent?.routeStack?.branchActive = routeStack;
      }
    }
  }

  @override
  void didUpdateModel(MvcRouterMapBase oldModel) {
    super.didUpdateModel(oldModel);
    if (model != oldModel) {
      _parseModel();
    }
  }

  @override
  void init() {
    super.init();
    _parseModel();
  }

  @override
  void initServices(ServiceCollection collection) {
    super.initServices(collection);
    collection.addSingleton<MvcRouter>((serviceProvider) => this);
    collection.addSingleton<MvcRouterMapParser>((serviceProvider) => this);
  }

  @override
  MvcView<MvcController> view() {
    return MvcViewBuilder(
      (controller) {
        if (_parsing) {
          return const SizedBox.shrink();
        }
        if (routeStack == null) {
          return const SizedBox.shrink();
        }
        if (_pages == null) {
          _update();
        }
        return MvcBuilder(
          id: model.id,
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
                      routeStack?.pop();
                      return true;
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
              return MvcDependencyProvider(
                child: MvcBuilder(
                  builder: (context) {
                    if (element.remainingPath == null || element.remainingPath!.isEmpty) {
                      return context.getService<MvcPage>().buildContent(context, null);
                    } else {
                      return context.getService<MvcPage>().buildContent(
                        context,
                        Builder(
                          builder: (context) {
                            return Mvc<MvcNavigatorController, MvcRouterMapBase>(
                              create: () => MvcNavigatorController(parent: this),
                              model: MvcRouterBasicMap([element.remainingPath!]),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
                provider: (collection) {
                  collection.add<MvcPage>((serviceProvider) => element.route.createPage());
                  collection.addSingleton((serviceProvider) => element.mapData);
                  collection.addSingleton((serviceProvider) => element);
                  collection.addSingleton((serviceProvider) => MvcRouteInfo(route: element.route, routeData: element.mapData));
                  if (element.route is MvcBranchedRouteBase) {
                    final map = MvcRouterBasicMap([element.remainingPath ?? MvcRouterEmptyPath()]);
                    List<MvcRouterMapBase> maps = (element.route as MvcBranchedRouteBase).branchesDefaultMap();
                    final int? index = (element.route as MvcBranchedRouteBase).mapIndex(map);
                    if (index != null) {
                      maps[index] = map;
                    }
                    collection.addSingleton(
                      (serviceProvider) => MvcNavigatorBranchController(
                        index ?? 0,
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
