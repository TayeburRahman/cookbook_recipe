import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:recipe_app/app/services/api_check.dart';
import '../../../../global/helper/show_custom_snackbar/show_custom_snackbar.dart';
import '../../../../models/grocery_advice_model/grocery_advice_model.dart';
import '../../../../models/grocery_model/grocery_model.dart';
import '../../../../services/api_client.dart';
import '../../../../services/app_url.dart';
import '../../../../utils/enums/status.dart';

class GroceryController extends GetxController {
  final Rx<Status> rxRequestStatus = Status.loading.obs;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;

  //>>>>>>>>>>>>>>>>>>✅✅Get weekly Grocery✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  final Rx<GroceryData> groceryData = GroceryData().obs;

  Future<void> getWeeklyGrocery({required String id}) async {
    setRxRequestStatus(Status.loading);
    refresh();
    var response = await ApiClient.getData(ApiUrl.groceryList(id: id));
    setRxRequestStatus(Status.completed);

    if (response.statusCode == 200) {
      groceryData.value = GroceryData.fromJson(response.body["data"]);
      // debugPrint("Grocery==============${groceryData.value.data?.length}");
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

  //>>>>>>>>>>>>>>>>>>✅✅Get Grocery List Advice (By Aisle)✅✅<<<<<<<<<<<<<<<<<<<<
  final Rx<Status> rxAdviceStatus = Status.loading.obs;
  final Rx<GroceryAdviceData?> groceryAdviceData = Rx<GroceryAdviceData?>(null);

  void setRxAdviceStatus(Status value) => rxAdviceStatus.value = value;

  Future<void> getGroceryListAdvice({required String id}) async {
    setRxAdviceStatus(Status.loading);
    groceryAdviceData.value = null;
    var response = await ApiClient.getData(ApiUrl.groceryListAdvice(id: id));
    if (response.statusCode == 200) {
      groceryAdviceData.value = GroceryAdviceData.fromJson(response.body["data"]);
      setRxAdviceStatus(Status.completed);
    } else {
      if (response.statusText == ApiClient.noInternetMessage) {
        setRxAdviceStatus(Status.internetError);
      } else {
        setRxAdviceStatus(Status.error);
      }
      ApiChecker.checkApi(response);
    }
  }

  Future<void> toggleIngredient({
    required Ingredient ingredientObj,
  }) async {
    if (ingredientObj.id == null || ingredientObj.id!.isEmpty) {
      return;
    }

    try {
      ingredientObj.isToggling.value = true;

      String url =
          ApiUrl.toggleIngredients(ingredientsId: ingredientObj.id ?? "");

      var response = await ApiClient.patchData(url, jsonEncode({}));

      if (response.statusCode != 200) {
        // Revert on API failure
        ingredientObj.buy.value = !ingredientObj.buy.value;
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      log("Errors from toggle ingredient ${e.toString()}");
      // Revert on error
      ingredientObj.buy.value = !ingredientObj.buy.value;
    } finally {
      ingredientObj.isToggling.value = false;
    }
  }

  Future<void> toggleAisleItem({
    required String planId,
    required String itemName,
    required bool isPurchased,
  }) async {
    if (planId.isEmpty || itemName.isEmpty) return;

    try {
      var body = jsonEncode({
        "planId": planId,
        "itemName": itemName,
        "isPurchased": isPurchased,
      });

      await ApiClient.patchData(ApiUrl.toggleAisleItem, body);
    } catch (e) {
      log("Errors from toggleAisleItem ${e.toString()}");
    }
  }
}
