import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/global/language/language_transalator.dart';
import 'app/bindings/dependency_injection.dart';
import 'app/core/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 776),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp.router(
        initialBinding: DependencyInjection(),
        debugShowCheckedModeBanner: false,
        routeInformationParser: AppRouter.route.routeInformationParser,
        routerDelegate: AppRouter.route.routerDelegate,
        routeInformationProvider: AppRouter.route.routeInformationProvider,
        locale: const Locale("en", "US"),
        translations: Language(),
      ),
    );
  }
}


























// h = 20.h
// w = 20.w
// fontSize= 20.sp
//Border Radius = 20.r
//horizontal padding = 20.h///20.w
// vertical padding = 20.w //10.h
//padding ALl = 4.0.r




