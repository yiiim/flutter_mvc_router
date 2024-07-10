import 'router/base.dart';
import 'route_map/map_data/base.dart';

abstract class MvcRouteOperate {}

class MvcRouteOperateForward extends MvcRouteOperate {
  MvcRouteOperateForward();
}

class MvcRouteOperatePop extends MvcRouteOperate {
  MvcRouteOperatePop([this.result]);
  final dynamic result;
}

class MvcRouteOperateRedirect extends MvcRouteOperate {
  MvcRouteOperateRedirect(this.mapData, {this.router});
  final MvcRouteMapDataBase mapData;
  final MvcRouterBase? router;
}

class MvcRouteOperatePush extends MvcRouteOperate {
  MvcRouteOperatePush(this.mapData, {this.router});
  final MvcRouteMapDataBase mapData;
  final MvcRouterBase? router;
}

class MvcRouteOperatePushReplacement extends MvcRouteOperate {
  MvcRouteOperatePushReplacement(this.mapData, {this.result, this.router});
  final dynamic result;
  final MvcRouteMapDataBase mapData;
  final MvcRouterBase? router;
}

class MvcRouteOperatePushAndRemoveUntil extends MvcRouteOperate {
  MvcRouteOperatePushAndRemoveUntil(this.mapData, this.predicate, {this.result, this.router});
  final dynamic result;
  final MvcRouteMapDataBase mapData;
  final bool Function(MvcRouteMapDataBase) predicate;
  final MvcRouterBase? router;
}

class MvcRouteOperatePopUntil extends MvcRouteOperate {
  MvcRouteOperatePopUntil(this.predicate);
  final bool Function(MvcRouteMapDataBase) predicate;
}
