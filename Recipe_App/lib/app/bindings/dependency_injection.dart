import 'package:get/get.dart';
import 'package:recipe_app/app/global/controller/auth_controller.dart';
import 'package:recipe_app/app/global/controller/genarel_controller.dart';
import 'package:recipe_app/app/global/controller/language_controller.dart';
import 'package:recipe_app/app/view/screens/home/controller/home_controller.dart';
import 'package:recipe_app/app/view/screens/meal_plan/controller/meal_plan_controller.dart';
import 'package:recipe_app/app/view/screens/profile_screen/my_recipe/controller/my_recipe_controller.dart';
import 'package:recipe_app/app/view/screens/profile_screen/personal_info/controller/profile_controller.dart';
import 'package:recipe_app/app/view/screens/profile_screen/recipe_box/controller/recipe_box_controller.dart';
import 'package:recipe_app/app/view/screens/profile_screen/setting/controller/info_controller.dart';
import 'package:recipe_app/app/view/screens/splash/controller/splash_controller.dart';

import '../view/screens/authentication/subscription_plan/controller/payment_controller.dart';
import '../view/screens/grocery/controller/grocery_controller.dart';
import '../view/screens/notification/controller.dart';
import '../view/screens/profile_screen/my_recipe/recipe_details/controller/recipe_details_controller.dart'
    show RecipeDetailsController;

class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController(), fenix: true);
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => InfoController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => MyRecipeController(), fenix: true);
    Get.lazyPut(() => PaymentController(), fenix: true);
    Get.lazyPut(() => RecipeBoxController(), fenix: true);
    Get.lazyPut(() => LanguageController(), fenix: true);
    Get.lazyPut(() => MealPlanController(), fenix: true);
    Get.lazyPut(() => GeneralController(), fenix: true);
    Get.lazyPut(() => NotificationController(), fenix: true);
    Get.lazyPut(() => RecipeDetailsController(), fenix: true);
    Get.lazyPut(() => GroceryController(), fenix: true);
  }
}
