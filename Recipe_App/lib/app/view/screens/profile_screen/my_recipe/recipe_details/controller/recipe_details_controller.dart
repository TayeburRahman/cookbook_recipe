import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/app/models/review_model/review_model.dart';
import 'package:recipe_app/app/services/api_check.dart';
import 'package:recipe_app/app/services/api_client.dart';
import 'package:recipe_app/app/services/app_url.dart';
import 'package:recipe_app/app/utils/enums/status.dart';
import 'package:recipe_app/app/view/screens/profile_screen/my_recipe/recipe_details/model/recipe_details_model.dart';

import '../../../../../../global/helper/show_custom_snackbar/show_custom_snackbar.dart';

class RecipeDetailsController extends GetxController {
  final Rx<Status> rxRequestStatus = Status.loading.obs;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;

  //>>>>>>>>>>>>>>>>>>✅✅Details✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  final Rx<DetailsData> detailsData = DetailsData().obs; // Holds profile data

  Future<void> detailsRecipe({required String id}) async {
    setRxRequestStatus(Status.loading);
    refresh();
    var response = await ApiClient.getData(ApiUrl.recipeDetails(id: id));
    setRxRequestStatus(Status.completed);

    if (response.statusCode == 200) {
      detailsData.value = DetailsData.fromJson(response.body["data"]);
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

  //>>>>>>>>>>>>>>>>>>✅✅Get Review✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxList<ReviewList> reviewList = <ReviewList>[].obs;

  getReview({required String id}) async {
    setRxRequestStatus(Status.loading);
    refresh();
    var response = await ApiClient.getData(ApiUrl.getReview(id: id));

    if (response.statusCode == 200) {
      reviewList.value = List<ReviewList>.from(
          response.body["data"].map((x) => ReviewList.fromJson(x)));
      debugPrint("reviewList=================${reviewList.length}");

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
  }

  //>>>>>>>>>>>>>>>>>>✅✅Review Send✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  final feedBackController = TextEditingController();
  RxBool isReview = false.obs;

// 👉 Updated reviewSend method with proper id handling and rating support
  Future<void> reviewSend({
    required BuildContext context,
    required String recipeId,
    required double rating,
  }) async {
    isReview.value = true;
    refresh();

    Map<String, dynamic> body = {
      "recipeId": recipeId,
      "feedback": feedBackController.text,
      "ratting": rating, // spelling is 'ratting' in your API — keep same
    };

    var response = await ApiClient.postData(
      ApiUrl.reviewSend,
      jsonEncode(body),
    );

    if (response.statusCode == 200) {
      feedBackController.clear();
      await getReview(id: recipeId);
      context.pop();
      toastMessage(message: response.body["message"]);
    } else {
      toastMessage(message: response.body["message"]);
      ApiChecker.checkApi(response);
    }

    isReview.value = false;
    refresh();
  }

  ///====================Score Added==============

  RxBool isScore = false.obs;

  Future<void> scoreAdd({
    required BuildContext context,
    required String recipeId,
    required double rating,
  }) async {
    isScore.value = true;
    refresh();

    Map<String, dynamic> body = {};

    var response = await ApiClient.postData(
      ApiUrl.score(id: recipeId, rating: rating.toString()),
      jsonEncode(body),
    );

    if (response.statusCode == 200) {
      await detailsRecipe(id: recipeId);
      context.pop();
      toastMessage(message: response.body["message"]);
    } else if (response.statusCode == 400) {
      toastMessage(message: "You have already rated this recipe");
    } else {
      ApiChecker.checkApi(response);
    }

    isScore.value = false;
    refresh();
  }
}
