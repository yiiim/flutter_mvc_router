import 'parser/map_parser.dart';
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
  final MvcRouterMapPathBase mapData;
  final MvcRouterMapParser? router;
}

class MvcRouteOperatePush extends MvcRouteOperate {
  MvcRouteOperatePush(this.mapData, {this.router});
  final MvcRouterMapPathBase mapData;
  final MvcRouterMapParser? router;
}

class MvcRouteOperatePushReplacement extends MvcRouteOperate {
  MvcRouteOperatePushReplacement(this.mapData, {this.result, this.router});
  final dynamic result;
  final MvcRouterMapPathBase mapData;
  final MvcRouterMapParser? router;
}

class MvcRouteOperatePushAndRemoveUntil extends MvcRouteOperate {
  MvcRouteOperatePushAndRemoveUntil(this.mapData, this.predicate, {this.result, this.router});
  final dynamic result;
  final MvcRouterMapPathBase mapData;
  final bool Function(MvcRouterMapPathBase) predicate;
  final MvcRouterMapParser? router;
}

class MvcRouteOperatePopUntil extends MvcRouteOperate {
  MvcRouteOperatePopUntil(this.predicate);
  final bool Function(MvcRouterMapPathBase) predicate;
}
