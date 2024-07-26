import 'package:flutter/material.dart';

import 'base.dart';

class MvcRouterEmptyPath extends MvcRouterMapPathBase {
  MvcRouterEmptyPath() : super(key: UniqueKey());
  @override
  bool get isEmpty => true;
  @override
  Uri get uri => Uri.parse("");
  @override
  String serialization() => "";
}
