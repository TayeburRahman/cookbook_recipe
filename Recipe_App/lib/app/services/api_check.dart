import 'package:get/get.dart';
import 'package:recipe_app/app/global/helper/local_db/local_db.dart';
import 'package:recipe_app/app/global/helper/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:recipe_app/app/utils/app_constants/app_constants.dart';

class ApiChecker {
  static void checkApi(Response response, {bool getXSnackBar = false}) async {
    if (response.statusCode == 401) {
      toastMessage(
        message: response.body["message"],
      );
      await SharePrefsHelper.remove(AppConstants.bearerToken);

      await SharePrefsHelper.setBool(AppConstants.rememberMe, false);
      // AppRouter.route.goNamed(
      //   RoutePath.signInScreen,
      // );
    } else if (response.statusCode == 403) {
      toastMessage(
        message: response.body["message"],
      );
    } else {
      showCustomSnackBar(response.statusText, getXSnackBar: getXSnackBar);
    }
  }
}
