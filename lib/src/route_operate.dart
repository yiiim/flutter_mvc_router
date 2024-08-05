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
  MvcRouteOperateRedirect(this.mapData);
  final MvcRouterMapPathBase mapData;
}

class MvcRouteOperatePush extends MvcRouteOperate {
  MvcRouteOperatePush(this.mapData);
  final MvcRouterMapPathBase mapData;
}

class MvcRouteOperatePushReplacement extends MvcRouteOperate {
  MvcRouteOperatePushReplacement(this.mapData, {this.result});
  final dynamic result;
  final MvcRouterMapPathBase mapData;
}

class MvcRouteOperatePushAndRemoveUntil extends MvcRouteOperate {
  MvcRouteOperatePushAndRemoveUntil(this.mapData, this.predicate, {this.result});
  final dynamic result;
  final MvcRouterMapPathBase mapData;
  final bool Function(MvcRouterMapPathBase) predicate;
}

class MvcRouteOperatePopUntil extends MvcRouteOperate {
  MvcRouteOperatePopUntil(this.predicate);
  final bool Function(MvcRouterMapPathBase) predicate;
}
