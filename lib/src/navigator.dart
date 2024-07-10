import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';
import 'package:flutter_mvc_router/flutter_mvc_router.dart';

import 'route_entity.dart';

class MvcNavigatorBranchController extends ValueNotifier<int> with DependencyInjectionService {
  MvcNavigatorBranchController(super.value, this._entity)
      : _branchActive = List.generate(
          _entity.branches?.length ?? 0,
          (index) => index == value,
        );
  final MvcRouteEntity _entity;

  int get branchCount => _entity.branches?.length ?? 0;
  List<bool> _branchActive;
  List<MvcRouteMapDataBase> branchDataAt(int index) => _entity.branches![index].value.map((e) => e.data).toList();
  Widget buildBranch(int index) {
    return MvcBuilder(
      id: "#branch_$index",
      builder: (context) {
        if (_branchActive[index]) {
          return Mvc(
            create: () => MvcNavigatorController(),
            model: _entity.branches![index],
          );
        }
        return Container();
      },
    );
  }

  @override
  set value(int newValue) {
    super.value = newValue;
    _entity.branchCurrentIndex = newValue;
    if (!_branchActive[newValue]) {
      _branchActive[newValue] = true;
    }
    getService<MvcNavigatorController>().model.notifyListeners();
  }
}

class MvcNavigatorController extends MvcController<MvcRouteStack> {
  List<Page>? _pages;

  bool canPop() => model.canPop();
  bool canForward() => model.canForward();
  Future<T?> operate<T>(MvcRouteOperate operate) => model.operate<T>(operate);

  @override
  void didUpdateModel(MvcRouteStack oldModel) {
    super.didUpdateModel(oldModel);
    if (model != oldModel) {
      oldModel.removeListener(_update);
      model.addListener(_update);
      _update();
    }
  }

  @override
  void init() {
    super.init();
    model.addListener(_update);
  }

  @override
  void initServices(ServiceCollection collection) {
    super.initServices(collection);
    collection.addSingleton((serviceProvider) => MvcRouter());
  }

  @override
  MvcView<MvcController> view() {
    return MvcViewBuilder(
      (controller) {
        if (_pages == null) {
          _update();
        }
        return MvcBuilder(
          id: model.id,
          classes: ["mvc_navigator"],
          builder: (context) {
            return Column(
              children: [
                Expanded(
                  child: Navigator(
                    pages: _pages!,
                    onPopPage: (route, result) {
                      if (!route.didPop(result)) {
                        return false;
                      }
                      model.pop();
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
    for (var element in model.value) {
      newPages.add(
        MaterialPage(
          key: element.key ?? element.data.key,
          child: Builder(
            builder: (context) {
              return MvcDependencyProvider(
                child: MvcBuilder(
                  builder: (context) {
                    if (element.child == null) {
                      return context.getService<MvcPage>().buildContent(context, null);
                    } else {
                      return context.getService<MvcPage>().buildContent(
                            context,
                            Mvc(
                              create: () => MvcNavigatorController(),
                              model: element.child!,
                            ),
                          );
                    }
                  },
                ),
                provider: (collection) {
                  collection.add<MvcPage>((serviceProvider) => element.route!.createPage());
                  collection.addSingleton((serviceProvider) => element.data);
                  collection.addSingleton((serviceProvider) => element);
                  collection.addSingleton((serviceProvider) => MvcRouteInfo(route: element.route!, routeData: element.data));
                  collection.addSingleton((serviceProvider) => MvcRouter());
                  if (element.branches != null) {
                    collection.addSingleton((serviceProvider) => MvcNavigatorBranchController(element.branchCurrentIndex ??= 0, element));
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
