import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/app/core/route_path.dart';
import 'package:recipe_app/app/core/routes.dart';
import 'package:recipe_app/app/global/helper/local_db/local_db.dart';
import 'package:recipe_app/app/global/helper/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:recipe_app/app/models/info_model/faq_model.dart';
import 'package:recipe_app/app/models/info_model/terms_model.dart';
import 'package:recipe_app/app/services/api_check.dart';
import 'package:recipe_app/app/services/api_client.dart';
import 'package:recipe_app/app/services/app_url.dart';
import 'package:recipe_app/app/utils/app_constants/app_constants.dart';
import 'package:recipe_app/app/utils/enums/status.dart';

class InfoController extends GetxController {
  final rxRequestStatus = Status.loading.obs;
  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;

  var selectedIndex = Rx<int?>(null);

  // Toggle the selected FAQ item
  void toggleItem(int index) {
    selectedIndex.value = selectedIndex.value == index ? null : index;
  }

  // Common Error Handler for API statuses
  void _handleApiError(var response) {
    if (response.statusText == ApiClient.noInternetMessage) {
      setRxRequestStatus(Status.internetError);
    } else {
      setRxRequestStatus(Status.error);
    }
    ApiChecker.checkApi(response);
  }

  // >>>>>>>>>>>>>>>>>>✅✅ Change Password ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  RxBool isChange = false.obs;

  Future<void> changePassword(BuildContext context) async {
    try {
      isChange.value = true;
      refresh();
      Map<String, String> body = {
        "oldPassword": oldPasswordController.text,
        "newPassword": newPasswordController.text,
        "confirmPassword": confirmPasswordController.text
      };
      var response = await ApiClient.patchData(
        ApiUrl.changePassword,
        jsonEncode(body),
      );
      if (response.statusCode == 200) {
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        AppRouter.route.pop();
        toastMessage(message: response.body["message"]);
      } else {
        toastMessage(message: response.body["message"]);
        // ApiChecker.checkApi(response);
      }
    } catch (e) {
      log("Error in changePassword: $e");
    } finally {
      isChange.value = false;
      refresh();
    }
  }

  // >>>>>>>>>>>>>>>>>>✅✅ Contact Us ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();
  RxBool isContact = false.obs;

  Future<void> contact(BuildContext context) async {
    try {
      isContact.value = true;
      refresh();
      Map<String, String> body = {
        "name": nameController.text,
        "email": emailController.text,
        "subject": subjectController.text,
        "message": messageController.text
      };
      var response = await ApiClient.postData(
        ApiUrl.contact,
        jsonEncode(body),
      );
      if (response.statusCode == 200) {
        nameController.clear();
        emailController.clear();
        subjectController.clear();
        messageController.clear();
        context.pop();
        toastMessage(message: response.body["message"]);
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      log("Error in contact: $e");
    } finally {
      isContact.value = false;
      refresh();
    }
  }

  // >>>>>>>>>>>>>>>>>>✅✅ Get Faq ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxList<FaqList> faqList = <FaqList>[].obs;

  Future<void> getFaq() async {
    try {
      setRxRequestStatus(Status.loading);

      var response = await ApiClient.getData(ApiUrl.faq);

      if (response.statusCode == 200) {
        // 1. Check if body or the "data" key is null
        var responseData = response.body["data"];

        if (responseData != null && responseData is List) {
          log("✅ Response received with ${responseData.length} items");

          faqList.value =
              List<FaqList>.from(responseData.map((x) => FaqList.fromJson(x)));

          setRxRequestStatus(Status.completed);
        } else {
          // Handle case where status is 200 but data is missing or empty
          faqList.clear();
          setRxRequestStatus(Status.completed);
          log("⚠️ Data key was null or not a list");
        }
      } else {
        _handleApiError(response);
      }
    } catch (e) {
      log("❌ Error in getFaq: $e");
      setRxRequestStatus(Status.error);
    } finally {
      // refresh() is usually called automatically by GetX when .value changes,
      // but keep it if your UI depends on specific manual triggers.
      update();
    }
  }

  // >>>>>>>>>>>>>>>>>>✅✅ Get Terms ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  Rx<TermsData> termsData = TermsData().obs;

  Future<void> getTerms() async {
    try {
      setRxRequestStatus(Status.loading);

      // Using refresh() here is fine if you need to trigger a UI rebuild immediately
      update();

      var response = await ApiClient.getData(ApiUrl.terms);

      if (response.statusCode == 200) {
        // 1. Check if the body exists and the 'data' key is not null
        final dynamic responseBody = response.body;

        if (responseBody != null && responseBody['data'] != null) {
          log("✅ Terms data received");

          // 2. Safely parse and assign
          termsData.value = TermsData.fromJson(responseBody['data']);
          setRxRequestStatus(Status.completed);
        } else {
          // Handle case where status is 200 but 'data' is missing or null
          log("⚠️ Terms data key is null or missing");
          setRxRequestStatus(Status.error);
        }
      } else {
        _handleApiError(response);
      }
    } catch (e) {
      log("❌ Error in getTerms: $e");
      setRxRequestStatus(Status.error);
    } finally {
      // Ensure UI is updated regardless of success or failure
      refresh();
    }
  }

  // >>>>>>>>>>>>>>>>>>✅✅ Get Privacy ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  Rx<TermsData> privacyData = TermsData().obs;

  Future<void> getPrivacy() async {
    try {
      setRxRequestStatus(Status.loading);

      var response = await ApiClient.getData(ApiUrl.privacyPolicy);

      if (response.statusCode == 200) {
        // 1. Safeguard: Check if body or data is null before parsing
        if (response.body != null && response.body['data'] != null) {
          privacyData.value = TermsData.fromJson(response.body['data']);
          setRxRequestStatus(Status.completed);
        } else {
          // Handle case where API succeeds but returns no data
          log("⚠️ Privacy data is null in response");
          setRxRequestStatus(Status.error);
        }
      } else {
        _handleApiError(response);
      }
    } catch (e) {
      log("❌ Error in getPrivacy: $e");
      setRxRequestStatus(Status.error);
    } finally {
      refresh(); // Updates the UI state
    }
  }

  // >>>>>>>>>>>>>>>>>>✅✅ Account Delete ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxBool isDeleteLoading = false.obs;

  Future<void> delete({required String id}) async {
    try {
      isDeleteLoading.value = true;
      refresh();
      var response = await ApiClient.deleteData(ApiUrl.deleteAccount(id: id));

      if (response.statusCode == 200) {
        await SharePrefsHelper.remove(AppConstants.bearerToken);
        await SharePrefsHelper.remove(AppConstants.userId);
        SharePrefsHelper.setBool(AppConstants.rememberMe, false);

        AppRouter.route.goNamed(RoutePath.signInScreen);
        toastMessage(message: response.body["message"]);
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      log("Error in delete: $e");
    } finally {
      isDeleteLoading.value = false;
      refresh();
    }
  }

  @override
  void onInit() {
    getFaq();
    getTerms();
    getPrivacy();
    super.onInit();
  }
}
