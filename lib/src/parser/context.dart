import '../route_map/map_data/base.dart';
import 'user_info.dart';

class MvcRouterParseContext<T extends MvcRouterParseUserInfo> {
  MvcRouterParseContext({required this.mapData, this.userInfo});
  final MvcRouteMapDataBase mapData;
  final T? userInfo;

  MvcRouterParseContext change({MvcRouteMapDataBase? mapData, T? userInfo}) {
    MvcRouterParseContext newContext = MvcRouterParseContext(
      mapData: mapData ?? this.mapData,
      userInfo: userInfo ?? this.userInfo,
    );
    return newContext;
  }
}
