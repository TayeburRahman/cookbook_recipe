import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/core/routes.dart';
import 'package:recipe_app/app/global/controller/genarel_controller.dart';
import 'package:recipe_app/app/global/helper/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:recipe_app/app/global/model/category_model.dart';
import 'package:recipe_app/app/models/favorite/favorite_model.dart';
import 'package:recipe_app/app/models/my_recipe/my_recipe_model.dart';
import 'package:recipe_app/app/services/api_check.dart';
import 'package:recipe_app/app/services/api_client.dart';
import 'package:recipe_app/app/services/app_url.dart';
import 'package:recipe_app/app/utils/enums/status.dart';

class MyRecipeController extends GetxController {
  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  final Rx<Status> rxRequestStatus = Status.loading.obs;

  final GeneralController generalController = Get.find<GeneralController>();

  //>>>>>>>>>>>>>>>>>>✅✅Create Recipe✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxBool isRecipeCreate = false.obs;

  Future<void> recipeCreate(BuildContext context) async {
    try {
      isRecipeCreate.value = true;
      refresh();

      Map<String, dynamic> body = {
        "name": recipeNameController.text,
        "ingredients": jsonEncode(ingredients),
        "instructions": instructionsController.text,
        "nutritional": jsonEncode({
          "calories": int.tryParse(caloriesController.text) ?? 0,
          "protein": int.tryParse(proteinController.text) ?? 0,
          "carbs": int.tryParse(carbsController.text) ?? 0,
          "fat": int.tryParse(fatController.text) ?? 0,
          "fiber": int.tryParse(fiberController.text) ?? 0
        }),
        "category": [selectedCategoryId.value],
        "holiday_recipes": holidayRecipesController.text,
        "oils": oilsController.text,
        "serving_temperature": servingTemperatureController.text,
        "flavor": flavorController.text,
        "weight_and_muscle": weightLossController.text,
        "whole_food_type": wholeFoodTypeController.text,
        "serving_size": servingSizeController.text,
        "prep_time": prepTimeController.text,
        "recipe_tips": recipeTipsController.text,
      };

      List<MultipartBody> multipartList = [];
      if (generalController.image.value.isNotEmpty) {
        multipartList
            .add(MultipartBody("image", File(generalController.image.value)));
      }

      var response = await ApiClient.postMultipartData(
        ApiUrl.recipeCreate,
        body,
        multipartBody: multipartList,
      );
      if (response.body != null) {
        log("Ajay value Check ${response.body["message"]}");

        if (response.statusCode == 200) {
          AppRouter.route.pop();
          getMyRecipe();

          toastMessage(message: response.body["message"]);
          resetControllers();
        } else if (response.statusCode == 400) {
          toastMessage(message: response.body["message"]);
        }
      }
    } catch (e) {
      log("Error from recipeCreate: $e");
    } finally {
      isRecipeCreate.value = false;
      refresh();
    }
  }
  //>>>>>>>>>>>>>>>>>>✅✅Recipe Edit✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxBool isRecipeEdit = false.obs;

  Future<void> recipeUpdate(
      {required BuildContext context, required String id}) async {
    try {
      log("Ajay value Check ${generalController.imageFile.value.path}");
      log("Ajay value Check ${generalController.imageFile.value.path.runtimeType}");
      isRecipeEdit.value = true;
      refresh();

      Map<String, dynamic> body = {
        "name": recipeNameController.text,
        "ingredients": jsonEncode(ingredients),
        "instructions": instructionsController.text,
        "nutritional": jsonEncode({
          "calories": int.tryParse(caloriesController.text) ?? 0,
          "protein": int.tryParse(proteinController.text) ?? 0,
          "carbs": int.tryParse(carbsController.text) ?? 0,
          "fat": int.tryParse(fatController.text) ?? 0,
          "fiber": int.tryParse(fiberController.text) ?? 0
        }),
        "category": [selectedCategoryId.value],
        "holiday_recipes": holidayRecipesController.text,
        "oils": oilsController.text,
        "serving_temperature": servingTemperatureController.text,
        "flavor": flavorController.text,
        "weight_and_muscle": weightLossController.text,
        "whole_food_type": wholeFoodTypeController.text,
        "serving_size": servingSizeController.text,
        "prep_time": prepTimeController.text,
        "recipe_tips": recipeTipsController.text,
      };

      List<MultipartBody> multipartList = [];
      if (generalController.imageFile.value.path.isNotEmpty) {
        multipartList
            .add(MultipartBody("image", generalController.imageFile.value));
      }
      var response = await ApiClient.patchMultipart(
          ApiUrl.recipeUpdate(id: id), body,
          multipartBody: multipartList);

      log("Ajay value Check ${response.body}");
      if (response.statusCode == 400) {
        log(" 🔥🔥🔥🔥🔥🔥🔥🔥 Apni Response is ${response.statusCode}");
        log(" 🔥🔥🔥🔥🔥🔥🔥🔥 Apni Response is ${response.statusText}");
      }

      // if (response.body != null) {
      if (response.statusCode == 200) {
        getMyRecipe();
        AppRouter.route.pop();
        toastMessage(
            message: response.body["message"] ?? "Updated successfully");
      } else {
        log("Error from recipeUpdate: ${response.body["message"]}");
        // String errorMessage = response.body["message"] ?? "Error occurred";
        // toastMessage(message: errorMessage);
        // ApiChecker.checkApi(response);
      }
      // }
    } catch (e) {
      log("Error from recipeUpdate: $e");
      // toastMessage(message: "An unexpected error occurred");
    } finally {
      isRecipeEdit.value = false;
      refresh();
    }
  }
  //>>>>>>>>>>>>>>>>>>✅✅My Recipe Delete ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxBool isDeleteLoading = false.obs;

  Future<void> removeRecipe(
      {required BuildContext context, required String id}) async {
    try {
      isDeleteLoading.value = true;
      refresh();

      var response = await ApiClient.deleteData(
        ApiUrl.recipeDelete(id: id),
      );

      if (response.statusCode == 200) {
        String message = response.body["message"];
        getMyRecipe();
        toastMessage(message: message);
        AppRouter.route.pop();
      } else {
        String errorMessage = response.body["message"] ?? "Error occurred";
        toastMessage(message: errorMessage);
      }
    } catch (e) {
      toastMessage(message: "An error occurred. Please try again.");
      log("Error from removeRecipe: $e");
    } finally {
      isDeleteLoading.value = false;
      refresh();
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅My Recipe Method ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxList<MyRecipeList> myRecipeList = <MyRecipeList>[].obs;

  Future<void> getMyRecipe() async {
    try {
      setRxRequestStatus(Status.loading);
      refresh();
      var response = await ApiClient.getData(ApiUrl.myAllRecipe);

      if (response.statusCode == 200) {
        myRecipeList.value = List<MyRecipeList>.from(
            response.body["data"].map((x) => MyRecipeList.fromJson(x)));

        debugPrint("My RecipeList=================${myRecipeList.length}");

        // setRxRequestStatus(Status.completed);
        // refresh();
      } else {
        if (response.statusText == ApiClient.noInternetMessage) {
          setRxRequestStatus(Status.internetError);
        } else {
          setRxRequestStatus(Status.error);
        }
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      log("Error from getMyRecipe: $e");
    } finally {
      setRxRequestStatus(Status.completed);
      refresh();
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Favorite Method ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  final Rx<FavoriteModel> favoriteRecipeData = FavoriteModel().obs;

  Future<void> getFavorites() async {
    try {
      setRxRequestStatus(Status.loading);
      refresh();
      var response = await ApiClient.getData(ApiUrl.getFavorite);

      // setRxRequestStatus(Status.completed);

      if (response.statusCode == 200) {
        // Check if 'data' exists and contains valid information
        if (response.body["data"] != null) {
          favoriteRecipeData.value = FavoriteModel.fromJson(response.body);

          // Populate the favorites map for reactivity
          final recipes = favoriteRecipeData.value.data?.recipes ?? [];
          for (var recipe in recipes) {
            if (recipe.id != null) {
              initFavorite(recipe.id!, true);
            }
          }

          // Debugging
          debugPrint(
              "Favorite=====================${favoriteRecipeData.value.data?.recipes?.length}");
        } else {
          debugPrint("Error: 'data' is null in the response");
          setRxRequestStatus(Status.error);
        }
      } else {
        if (response.statusText == ApiClient.noInternetMessage) {
          setRxRequestStatus(Status.internetError);
        } else {
          setRxRequestStatus(Status.error);
        }
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      setRxRequestStatus(Status.error);
      debugPrint("Error while fetching favorites: $e");
    } finally {
      setRxRequestStatus(Status.completed);
      refresh();
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅ favorite add remove✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  final favorites = <String, RxBool>{}.obs;

  /// initialize favorite value per recipe
  void initFavorite(String id, bool initialValue) {
    if (!favorites.containsKey(id)) {
      favorites[id] = initialValue.obs;
    }
  }

  void favoriteAdd(String id) async {
    // যদি map এ না থাকে, initialize করো
    favorites.putIfAbsent(id, () => false.obs);

    // toggle local status
    favorites[id]!.toggle();

    update(); // update GetX observers

    Map<String, String> body = {};

    var response = await ApiClient.patchData(
      ApiUrl.addFavorite(id: id),
      jsonEncode(body),
    );

    if (response.statusCode == 200) {
      await getFavorites();
      await getMyRecipe();
      toastMessage(
        message: response.body["message"],
      );
    } else {
      ApiChecker.checkApi(response);
      // যদি error হয়, status আগের মতো ফেরত রাখো
      favorites[id]!.toggle();
    }
  }

  RxBool isFavorite = false.obs;

  Future<void> favoriteAddRemove({required String id}) async {
    try {
      isFavorite.value = isFavorite.value;
      refresh();

      Map<String, String> body = {};

      var response = await ApiClient.patchData(
        ApiUrl.addFavorite(id: id),
        jsonEncode(body),
      );

      if (response.statusCode == 200) {
        await getFavorites();
        await getMyRecipe();
        toastMessage(
          message: response.body["message"],
        );
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      log("Error from favoriteAddRemove: $e");
    } finally {
      isFavorite.value = isFavorite.value;
      refresh();
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅ Other✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  // Dropdown State
  var isSizeDropdownOpen = false.obs;
  var isHoliday = false.obs;

  // Selected Values
  var selectedSizeTime = "Select your size".obs;
  var selectedHolidayRecipes = "Select ".obs;
  var selectedCategory = "Select ".obs;
  var selectedCategoryId = "".obs;

  final List<String> sizes = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10"
  ];
  final List<String> holidays = ["Arabi", "Backyard BBQ", "Chinese"];

  //=============Radio
// Selected values
  var selectedOption = "Oil Free".obs;
  var selectedTemperature = "".obs;
  var selectedFlavor = "".obs;
  var lossGain = "".obs;
  var foodType = "".obs;

  // Options
  final List<String> oils = ["oil_free", "with_oil"];
  final List<String> servingTemperature = ["Cold", "Hot"];
  final List<String> servingFlavor = ["Sweet", "Savory"];
  final List<String> lossGainList = [
    "weight_loss",
    "muscle_gain",
    "maintain_weight"
  ];
  final List<String> foodTypeList = [
    "plant_based",
    "whole_food",
    "paleo",
    "animal_protein",
    "vegan",
    "vegetarian"
  ];

  // Selection change functions
  void changeSelection(String value) {
    selectedOption.value = value;
    oilsController.text = value;
  }

  void changeTemperatureSelection(String value) {
    selectedTemperature.value = value;
    servingTemperatureController.text = value;
  }

  void changeFlavorSelection(String value) {
    selectedFlavor.value = value;
    flavorController.text = value;
  }

  void changeLossSelection(String value) {
    lossGain.value = value;
    weightLossController.text = value;
  }

  void changeFoodType(String value) {
    foodType.value = value;
    wholeFoodTypeController.text = value;
  }

  TextEditingController caloriesController = TextEditingController();
  TextEditingController fatController = TextEditingController();
  TextEditingController proteinController = TextEditingController();
  TextEditingController fiberController = TextEditingController();
  TextEditingController carbsController = TextEditingController();
  // TextEditingController recipeNameController = TextEditingController();
  TextEditingController recipeNameController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();
  TextEditingController nutritionalController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController holidayRecipesController = TextEditingController();
  TextEditingController oilsController = TextEditingController();
  TextEditingController servingTemperatureController = TextEditingController();
  TextEditingController flavorController = TextEditingController();
  TextEditingController weightLossController = TextEditingController();
  TextEditingController wholeFoodTypeController = TextEditingController();
  TextEditingController servingSizeController = TextEditingController();
  TextEditingController prepTimeController = TextEditingController();
  TextEditingController recipeTipsController = TextEditingController();

  // ingredients
  RxList<String> ingredientsList = <String>[].obs;

  // RxList<String> instructionsList = <String>[].obs;

  void addIngredient() {
    final ingredient = ingredientsController.text.trim();
    if (ingredient.isNotEmpty) {
      ingredientsList.add(ingredient);
      ingredientsController.clear(); // Clears the input field
    }
  }

  void removeIngredient(String ingredient) {
    ingredientsList.remove(ingredient);
  }

  List<String> get ingredients => ingredientsList.toList();

  //Clear controller

  void resetControllers() {
    recipeNameController.clear();
    instructionsController.clear();
    nutritionalController.clear();
    categoryController.clear();
    holidayRecipesController.clear();
    oilsController.clear();
    servingTemperatureController.clear();
    flavorController.clear();
    weightLossController.clear();
    wholeFoodTypeController.clear();
    servingSizeController.clear();
    prepTimeController.clear();
    recipeTipsController.clear();
    ingredientsList.clear();
    caloriesController.clear();
    fatController.clear();
    proteinController.clear();
    fiberController.clear();
    carbsController.clear();
    generalController.clearImage();
    selectedOption.value = "";
    foodType.value = "";
    lossGain.value = "";
    selectedFlavor.value = "";
    selectedTemperature.value = "";
  }

  var isCategory = false.obs;
  List<CategoryModelNew> allCategoryList = <CategoryModelNew>[];
  List<String> category = [
    // "breakfast",
    // "lunches-and-dinners",
    // "appetizers",
    // "salads",
    // "soups",
    // "desserts",
    // "smoothies/shakes",
    // "salad-dressings",
    // "jams/marmalades",
    // "sides",
  ];
  Future<void> getAllCategory() async {
    setRxRequestStatus(Status.loading);
    refresh();
    var response = await ApiClient.getData(ApiUrl.category);

    if (response.statusCode == 200) {
      // for (var element in response.body["data"]) {
      //   categoryList.add(CategoryModelNew.fromJson(element));
      // }

      allCategoryList = List<CategoryModelNew>.from(
          response.body["data"].map((x) => CategoryModelNew.fromJson(x)));
      for (var element in allCategoryList) {
        category.add(element.name ?? "");
      }

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

  void toggleDropdown(RxBool dropdownState) {
    dropdownState.value = !dropdownState.value;
  }

  void selectItem(String item, RxString selectedValue, RxBool dropdownState,
      TextEditingController controller) {
    selectedValue.value = item;
    controller.text = item;
    dropdownState.value = false;
    // Logic
    int index = allCategoryList.indexWhere(
      (element) =>
          element.name?.toLowerCase() == selectedCategory.toLowerCase(),
    );
    selectedCategoryId.value = allCategoryList[index].id.toString();
  }

  @override
  void onInit() {
    super.onInit();
    getAllCategory();
  }
}
