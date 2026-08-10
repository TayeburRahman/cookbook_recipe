import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/app/global/helper/extension/extension.dart';
import 'package:recipe_app/app/global/helper/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:recipe_app/app/models/payments/subscription_model.dart';
import 'package:recipe_app/app/services/api_check.dart';
import 'package:recipe_app/app/services/api_client.dart' show ApiClient;
import 'package:recipe_app/app/services/app_url.dart' show ApiUrl;
import 'package:recipe_app/app/utils/enums/status.dart' show Status;
import '../../../../../core/route_path.dart';

class PaymentController extends GetxController {
  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  final Rx<Status> rxRequestStatus = Status.loading.obs;

  //>>>>>>>>>>>>>>>>>>✅✅subscriptionList✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxList<SubscriptionList> subscriptionList = <SubscriptionList>[].obs;

  Future<void> getSubscription() async {
    try {
      setRxRequestStatus(Status.loading);
      debugPrint("Status: loading");
      await Future.delayed(const Duration(seconds: 1));
      var response = await ApiClient.getData(ApiUrl.getSubscription);

      if (response.statusCode == 200) {
        subscriptionList.value = List<SubscriptionList>.from(
            response.body["data"].map((x) => SubscriptionList.fromJson(x)));
        setRxRequestStatus(Status.completed);
        debugPrint("Status: completed");
      } else {
        if (response.statusText == ApiClient.noInternetMessage) {
          setRxRequestStatus(Status.internetError);
          debugPrint("Status: internetError");
        } else {
          setRxRequestStatus(Status.error);
          debugPrint("Status: error");
        }
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      log("Error From Get Subscription $e");
    } finally {
      setRxRequestStatus(Status.completed);
      refresh();
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Create Checkout Payment✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxString loadingSubscriptionId = ''.obs;

  Future<void> createPayment(
      {required BuildContext context, required String subscriptionId}) async {
    try {
      debugPrint("=== Payment process started ===");
      debugPrint("Subscription ID: $subscriptionId");

      loadingSubscriptionId.value = subscriptionId;
      refresh();

      Map<String, String> body = {
        "subscriptionId": subscriptionId,
      };

      debugPrint("API Body: ${jsonEncode(body)}");
      debugPrint("Calling API: ${ApiUrl.createPayment}");

      var response = await ApiClient.postData(
        ApiUrl.createPayment,
        jsonEncode(body),
      );

      debugPrint("API Response Status Code: ${response.statusCode}");
      debugPrint("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        String generatedLink = response.body["data"]?['url'];
        debugPrint("Generated Stripe Checkout URL: $generatedLink");
        toastMessage(message: response.body["message"]);
        debugPrint("[GoRouter] Navigating to WebViewScreen with payment URL");
        context.push(RoutePath.webViewScreen.addBasePath, extra: generatedLink);
      } else {
        debugPrint("API call failed with status: ${response.statusCode}");
        ApiChecker.checkApi(response);
      }

      debugPrint("=== Payment process ended ===");
    } catch (e) {
      log("Error From Create Payment $e");
    } finally {
      loadingSubscriptionId.value = '';
      refresh();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getSubscription();
  }
}
