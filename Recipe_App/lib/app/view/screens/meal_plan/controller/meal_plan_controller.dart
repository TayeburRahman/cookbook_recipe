import 'dart:convert' show jsonEncode;
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:recipe_app/app/core/routes.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/global/helper/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:recipe_app/app/services/api_check.dart';
import 'package:recipe_app/app/services/api_client.dart';
import 'package:recipe_app/app/services/app_url.dart';
import 'package:recipe_app/app/utils/enums/status.dart';
import 'package:recipe_app/app/view/screens/meal_plan/controller/delete_api_client.dart';
import 'package:recipe_app/app/view/screens/meal_plan/models/feature_plan_model.dart';
import 'package:recipe_app/app/view/screens/meal_plan/models/get_custom_plan.dart';
import 'package:recipe_app/app/view/screens/meal_plan/models/get_weekly_model.dart';
import 'package:recipe_app/app/view/screens/meal_plan/models/weekly_meal_plan_model.dart';
import '../../../../services/error_response.dart';
import '../../../../services/new_api_client.dart';

class MealPlanController extends GetxController {
  Plan? selectedPlan;
  CustomPlanList? selectedCustomPlanList;
  FeaturePlanList? selectedFeaturePlanList;
  RxString selectedPlanId = "".obs;
  RxString selectedDay = "".obs;

  final Rx<Status> rxRequestStatus = Status.loading.obs;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;

  //>>>>>>>>>>>>>>>>>>✅✅Get Weekly Plan✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  final Rx<WeeklyModelData> weeklyPlanData =
      WeeklyModelData().obs; // Holds profile data

  Future<void> getWeeklyPlan() async {
    setRxRequestStatus(Status.loading);
    refresh();
    var response = await ApiClient.getData(ApiUrl.getWeeklyPlan);
    setRxRequestStatus(Status.completed);

    if (response.statusCode == 200) {
      weeklyPlanData.value = WeeklyModelData.fromJson(response.body["data"]);
      debugPrint(
          "weeklyPlanData==============${weeklyPlanData.value.plans?.length}");
      refresh();
    } else {
      if (response.statusText == ApiClient.noInternetMessage) {
        setRxRequestStatus(Status.internetError);
      } else {
        setRxRequestStatus(Status.error);
      }
      ApiChecker.checkApi(response);
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Get weekly Meal Plan✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  final Rx<WeeklyMealPlanData> weeklyMealPlanData = WeeklyMealPlanData().obs;

  Future<void> getWeeklyMealPlan({required String id}) async {
    setRxRequestStatus(Status.loading);
    refresh();
    var response = await ApiClient.getData(ApiUrl.mealPlanDetails(id: id));
    setRxRequestStatus(Status.completed);

    if (response.statusCode == 200) {
      weeklyMealPlanData.value =
          WeeklyMealPlanData.fromJson(response.body["data"]);
      debugPrint(
          "MealPlanData==============${weeklyMealPlanData.value.data?.length}");

      debugPrint("Nutrition === ${weeklyMealPlanData.value.data}");

      refresh();
    } else {
      if (response.statusText == ApiClient.noInternetMessage) {
        setRxRequestStatus(Status.internetError);
      } else {
        setRxRequestStatus(Status.error);
      }
      ApiChecker.checkApi(response);
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Create Custom Plan ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  final TextEditingController planNameController = TextEditingController();
  RxString createdPlanName = "".obs;

  @override
  void onClose() {
    planNameController.dispose();
    super.onClose();
  }

  RxBool isCreate = false.obs;

  Future<void> createCustomPlanMethod() async {
    try {
      isCreate.value = true;
      refresh();
      Map<String, String> body = {"name": planNameController.text};
      var response = await ApiClient.postData(
        ApiUrl.createCustomPlan,
        jsonEncode(body),
      );
      if (response.statusCode == 200) {
        createdPlanName.value = planNameController.text.trim();
        planNameController.clear();
        toastMessage(
          message: response.body["message"],
        );
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      log("error from createCustomPlanMethod $e");
    } finally {
      isCreate.value = false;
      refresh();
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Get Custom Plan✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  RxList<CustomPlanList> customPlanList = <CustomPlanList>[].obs;

  Future<void> getCustomPlan() async {
    try {
      setRxRequestStatus(Status.loading);
      refresh();
      var response = await ApiClient.getData(ApiUrl.getCustomPlan);

      if (response.statusCode == 200) {
        customPlanList.value = List<CustomPlanList>.from(
            response.body["data"].map((x) => CustomPlanList.fromJson(x)));
        debugPrint("CustomPlanList=================${customPlanList.length}");

        setRxRequestStatus(Status.completed);
        refresh();
      } else {
        if (response.statusText == ApiClient.noInternetMessage) {
          setRxRequestStatus(Status.internetError);
        } else {
          setRxRequestStatus(Status.error);
        }
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      log("error from getCustomPlan $e");
    } finally {
      setRxRequestStatus(Status.completed);
      refresh();
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Plan Delete✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxBool isDeleteLoading = false.obs;

  Future<void> planeDelete(
      {required String id, required BuildContext context}) async {
    isDeleteLoading.value = true;
    update();

    final url = "${ApiUrl.baseUrl}${ApiUrl.planeDelete(id: id)}";
    var response = await NewApiClient.delete(url);

    debugPrint("📥 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      getCustomPlan();
      Navigator.pop(context);
      snackBar(AppStrings.mealPlanDeletedSuccessfully.tr, isError: false);
    } else {
      snackBar(response.statusText ?? AppStrings.failedToDelete.tr);
    }

    isDeleteLoading.value = false;
    update();
  }

  //>>>>>>>>>>>>>>>>>>✅✅Clean Meal Plan✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxBool isCleanLoading = false.obs;

  Future<void> cleanMealPlan(
      {required String id, required BuildContext context}) async {
    isCleanLoading.value = true;
    update();

    final url = ApiUrl.cleanMealPlan(id: id);
    var response = await DeleteApiClient.delete(url);

    debugPrint("📥 Clean Meal Plan Response: ${response.body}");

    if (response.statusCode == 200) {
      getWeeklyMealPlan(id: id);
      Navigator.pop(context);
      snackBar('Cleaned plan successfully!'.tr, isError: false);
    } else {
      snackBar(response.statusText ?? AppStrings.somethingWentWrong.tr);
    }

    isCleanLoading.value = false;
    update();
  }

  //>>>>>>>>>>>>>>>>>>✅✅Reset Meal Plan✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxBool isResetLoading = false.obs;

  Future<void> resetMealPlan(
      {required String id, required BuildContext context}) async {
    isResetLoading.value = true;
    update();

    final url = ApiUrl.resetMealPlan(id: id);
    var response = await ApiClient.patchData(url, jsonEncode({}));

    debugPrint("📥 Reset Meal Plan Response: ${response.body}");

    if (response.statusCode == 200) {
      getWeeklyMealPlan(id: id);
      Navigator.pop(context);
      snackBar('Reset plan successfully!'.tr, isError: false);
    } else {
      snackBar(response.statusText ?? AppStrings.somethingWentWrong.tr);
    }

    isResetLoading.value = false;
    update();
  }

  //>>>>>>>>>>>>>>>>>>✅✅Get Feature Plan✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  RxList<FeaturePlanList> featurePlanList = <FeaturePlanList>[].obs;

  Future<void> getFeaturePlan() async {
    try {
      setRxRequestStatus(Status.loading);
      refresh();
      var response = await ApiClient.getData(ApiUrl.getFeaturePlan);

      if (response.statusCode == 200) {
        featurePlanList.value = List<FeaturePlanList>.from(
            response.body["data"].map((x) => FeaturePlanList.fromJson(x)));
        debugPrint("featurePlanList=================${featurePlanList.length}");

        setRxRequestStatus(Status.completed);
        refresh();
      } else {
        if (response.statusText == ApiClient.noInternetMessage) {
          setRxRequestStatus(Status.internetError);
        } else {
          setRxRequestStatus(Status.error);
        }
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      log("error from getFeaturePlan $e");
    } finally {
      setRxRequestStatus(Status.completed);
      refresh();
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Add Recipe✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxBool isAddLoading = false.obs;

  Future<void> addRecipe({
    required String planId,
    required String recipeId,
    required String day,
  }) async {
    try {
      isAddLoading.value = true;
      refresh();
      String url =
          ApiUrl.addRecipe(recipeId: recipeId, day: day, planId: planId);

      debugPrint("SwapAdd URL: $url");
      Map<String, String> body = {};

      var response = await ApiClient.postData(
        url,
        jsonEncode(body),
      );

      if (response.statusCode == 200) {
        getWeeklyMealPlan(id: planId);
        toastMessage(
          message: response.body["message"],
        );
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      log("error from addRecipe $e");
    } finally {
      isAddLoading.value = false;
      refresh();
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Swap Add✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxBool isSwap = false.obs;

  Future<void> swapAdd({
    required String removeId,
    required String newId,
    required String day,
    required String planId,
  }) async {
    try {
      isSwap.value = true;
      refresh();

      String url = ApiUrl.swapAdd(
        removeId: removeId,
        newId: newId,
        day: day,
        planId: planId,
      );

      debugPrint("SwapAdd URL:============>>> $url");
      Map<String, dynamic> body = {};

      var response = await ApiClient.patchData(
        url,
        jsonEncode(body),
      );

      if (response.statusCode == 200) {
        getWeeklyMealPlan(id: planId);
        toastMessage(
          message: response.body["message"] ?? AppStrings.swapSuccessful.tr,
        );
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      debugPrint("SwapAdd Exception:============ $e");
    } finally {
      isSwap.value = false;
      refresh();
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Swap Remove✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxBool isSwapRemove = false.obs;

  Future<void> swapRemove({
    required String removeId,
    required String day,
    required String planId,
    required BuildContext context,
  }) async {
    try {
      debugPrint(
          '====> swapRemove() called with: removeId=$removeId, day=$day, planId=$planId');

      isSwapRemove.value = true;
      debugPrint('====> isSwapRemove set to true');
      refresh();
      debugPrint('====> Controller refreshed');

      try {
        // 🔑 Build URL
        final url = ApiUrl.swapRemove(
          removeId: removeId,
          day: day,
          planId: planId,
        );
        debugPrint("====> swapRemove URL: $url");

        // 🔑 Call Delete API
        final response = await DeleteApiClient.delete(url);
        debugPrint(
            "====> swapRemove API Response: [${response.statusCode}] ${response.body}");

        // 🔑 Handle Success
        if (response.statusCode == 200) {
          getWeeklyMealPlan(id: planId);
          AppRouter.route.pop();
          toastMessage(message: AppStrings.successfullyRemoved.tr);
        }
        // 🔑 Handle Failure
      } catch (e) {
        debugPrint("====> swapRemove Exception: $e");
        showCustomSnackBar(AppStrings.somethingWentWrong.tr);
      } finally {
        isSwapRemove.value = false;
        debugPrint('====> isSwapRemove set to false');
        refresh();
        debugPrint('====> Controller refreshed');
      }
    } catch (e) {
      log("error from swapRemove $e");
    } finally {
      isSwapRemove.value = false;
      refresh();
    }
  }

  final RxInt selectedIndex = 0.obs;

  @override
  void onInit() {
    getWeeklyPlan();
    getCustomPlan();
    getFeaturePlan();
    super.onInit();
  }
}
