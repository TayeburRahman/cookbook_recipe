
import 'package:recipe_app/app/core/route_path.dart';



extension RouteBasePathExt on String {
  String get addBasePath {
    return RoutePath.basePath + this;
  }
}

