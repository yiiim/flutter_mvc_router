import 'base.dart';

class MvcEmptyRouteMapData extends MvcRouteMapDataBase {
  MvcEmptyRouteMapData();
  @override
  bool get isEmpty => true;
  @override
  Uri get uri => Uri.parse("");
}
