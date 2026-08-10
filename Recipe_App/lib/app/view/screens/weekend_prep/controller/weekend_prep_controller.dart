import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:recipe_app/app/global/helper/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:recipe_app/app/services/api_check.dart';
import 'package:recipe_app/app/services/api_client.dart';
import 'package:recipe_app/app/utils/enums/status.dart';
import 'package:recipe_app/app/view/screens/weekend_prep/models/weekend_prep_model.dart';

class WeekendPrepController extends GetxController {
  final Rx<Status> rxRequestStatus = Status.completed.obs;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;

  final Rx<WeekendPrepModel> weekendPrepData = WeekendPrepModel().obs;

  Future<void> toggleSpeedPrep({
    required String planId,
    required String stepId,
    required SpeedPrepStep step,
  }) async {
    try {
      step.isLoading = true;
      weekendPrepData.refresh();

      Map<String, String> body = {
        "planId": planId,
        "stepId": stepId,
      };
      log("body ====================> $body");

      var response = await ApiClient.patchData(
          "/meal_plan/toggle-speed-prep", jsonEncode(body));

      if (response.statusCode == 200 && response.body['success'] == true) {
        step.isDone = !(step.isDone ?? false);
      } else {
        toastMessage(message: response.body['message']);
      }
    } catch (e) {
      log("error from toggleSpeedPrep $e");
      toastMessage(message: "Something went wrong");
    } finally {
      step.isLoading = false;
      weekendPrepData.refresh();
    }
  }

  Future<void> getWeekendPrepData({required String id}) async {
    try {
      setRxRequestStatus(Status.loading);
      refresh();

      var response = await ApiClient.getData("/meal_plan/weekend-prep/$id");

      if (response.statusCode == 200) {
        weekendPrepData.value = WeekendPrepModel.fromJson(response.body);
        setRxRequestStatus(Status.completed);
        refresh();
      } else {
        if (response.statusText == ApiClient.noInternetMessage) {
          setRxRequestStatus(Status.internetError);
        } else {
          // Instead of generic error status, let's keep it as completed but
          // populate the model with the error message from the backend.
          weekendPrepData.value =
              WeekendPrepModel(message: response.statusText, data: null);
          setRxRequestStatus(Status.completed);
        }
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      log("error from getWeekendPrepData $e");
      weekendPrepData.value =
          WeekendPrepModel(message: e.toString(), data: null);
      setRxRequestStatus(Status.error);
    } finally {
      refresh();
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
