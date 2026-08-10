import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/core/route_path.dart';
import 'package:recipe_app/app/core/routes.dart';
import 'package:recipe_app/app/global/helper/local_db/local_db.dart';
import 'package:recipe_app/app/utils/app_constants/app_constants.dart';

class SplashController extends GetxController {
  Future<void> navigateScreen() async {
    String? tokenValue =
        await SharePrefsHelper.getString(AppConstants.bearerToken);
    if (tokenValue == "") {
      AppRouter.route.goNamed(
        RoutePath.getStartedScreen,
      );
    } else {
      AppRouter.route.goNamed(
        RoutePath.homeScreen,
      );
    }
    // AppRouter.route.goNamed(RoutePath.infor);
  }

  // Lang Function
  Future<void> initLangCheck() async {
    String valueLang = await SharePrefsHelper.getString(AppConstants.language);
    if (valueLang.isNotEmpty) {
      Get.updateLocale(Locale(valueLang));
    } else {
      Get.updateLocale(const Locale("en_US"));
    }
  }

  @override
  void onReady() {
    Future.delayed(const Duration(seconds: 2), () {
      // Init Lang Check Function
      initLangCheck();
      // Navigate Logic
      navigateScreen();
      //   Get.to(CompleteProfileScreen());
    });
    super.onReady();
  }
}
