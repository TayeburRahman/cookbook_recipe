import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/app/global/helper/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:recipe_app/app/global/model/category_model.dart';
import 'package:recipe_app/app/models/my_recipe/recipe_box.dart'
    show RecipeBoxDataMap;
import 'package:recipe_app/app/services/api_check.dart' show ApiChecker;
import 'package:recipe_app/app/services/api_client.dart' show ApiClient;
import 'package:recipe_app/app/services/app_url.dart' show ApiUrl;
import 'package:recipe_app/app/utils/enums/status.dart' show Status;

class RecipeBoxController extends GetxController {
  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  final Rx<Status> rxRequestStatus = Status.loading.obs;

  //>>>>>>>>>>>>>>>>>>✅✅Recipe Box✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  final Rx<RecipeBoxDataMap> recipeBoxData = RecipeBoxDataMap().obs;

  // Pagination state
  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  String currentFilterParams = "";

  // Reset all filters and pagination
  void resetFiltersAndPagination() {
    selectedMealTypes.clear();
    selectedRegions.clear();
    selectedOil.value = '';
    selectGainVsLost.value = '';
    selectedFoodTypes.clear();
    selectFlavorType.value = '';
    rating.value = 0;
    prepTimeRange.value = const RangeValues(0, 200);

    isDropdownOpen.value = false;
    isOils.value = false;
    isGainVsLost.value = false;
    isFoodType.value = false;
    isFlavorType.value = false;
    isRatingLoading.value = false;

    currentPage = 1;
    hasMoreData = true;
    currentFilterParams = "";
    searchController.clear();
  }

  getRecipeBox({String? other, bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore || !hasMoreData) return;
      isLoadingMore = true;
      currentPage++;
    } else {
      setRxRequestStatus(Status.loading);
      currentPage = 1;
      hasMoreData = true;
      currentFilterParams = other ?? "";
    }

    refresh();

    final endpoint = ApiUrl.recipeBoxFilter(
      param: currentFilterParams,
      page: currentPage,
      limit: 10,
    );
    var response = await ApiClient.getData(endpoint);

    if (!loadMore) {
      setRxRequestStatus(Status.completed);
    }

    if (response.statusCode == 200) {
      final newData = RecipeBoxDataMap.fromJson(response.body["data"]);

      if (loadMore) {
        // Append new results to existing list
        final existingResults = recipeBoxData.value.result ?? [];
        final newResults = newData.result ?? [];
        recipeBoxData.value = RecipeBoxDataMap(
          result: [...existingResults, ...newResults],
          meta: newData.meta,
        );

        // Check if there's more data
        if (newData.meta != null) {
          hasMoreData = currentPage < (newData.meta!.totalPage ?? 0);
        }
      } else {
        // Initial load
        recipeBoxData.value = newData;
        if (newData.meta != null) {
          hasMoreData = currentPage < (newData.meta!.totalPage ?? 0);
        }
      }

      debugPrint("Fetched Recipes: ${recipeBoxData.value.result?.length}");
      isLoadingMore = false;
      refresh();
    } else {
      if (!loadMore) {
        if (response.statusText == ApiClient.noInternetMessage) {
          setRxRequestStatus(Status.internetError);
        } else {
          setRxRequestStatus(Status.error);
        }
      }
      isLoadingMore = false;
      ApiChecker.checkApi(response);
    }
  }

  ///: <<<<<<======🗄️🗄️🗄️🗄️🗄️🗄️💡💡Search 💡💡🗄️🗄️🗄️🗄️🗄️🗄️🗄️>>>>>>>>===========
  TextEditingController searchController = TextEditingController();

  /// Search recipe by name
  String currentSearchTerm = "";

  Future<void> search({required String search, bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore || !hasMoreData) return;
      isLoadingMore = true;
      currentPage++;
    } else {
      setRxRequestStatus(Status.loading);
      currentPage = 1;
      hasMoreData = true;
      currentSearchTerm = search;
    }

    recipeBoxData.refresh();

    var response = await ApiClient.getData(ApiUrl.searchRecipe(
        name: currentSearchTerm, page: currentPage, limit: 10));

    if (!loadMore) {
      setRxRequestStatus(Status.completed);
    }

    if (response.statusCode == 200) {
      final dataJson = response.body["data"];
      if (dataJson != null) {
        final newData = RecipeBoxDataMap.fromJson(dataJson);

        if (loadMore) {
          // Append new results to existing list
          final existingResults = recipeBoxData.value.result ?? [];
          final newResults = newData.result ?? [];
          recipeBoxData.value = RecipeBoxDataMap(
            result: [...existingResults, ...newResults],
            meta: newData.meta,
          );

          // Check if there's more data
          if (newData.meta != null) {
            hasMoreData = currentPage < (newData.meta!.totalPage ?? 0);
          }
        } else {
          // Initial load
          recipeBoxData.value = newData;
          if (newData.meta != null) {
            hasMoreData = currentPage < (newData.meta!.totalPage ?? 0);
          }
        }
      }
      isLoadingMore = false;
      recipeBoxData.refresh();
    } else {
      if (!loadMore) {
        setRxRequestStatus(Status.error);
      }
      isLoadingMore = false;
      ApiChecker.checkApi(response);
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Recipe  Box Filter✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  var selectedMealTypes = <String>[].obs;
  var selectedRegions = <String>[].obs;
  var selectedOil = ''.obs;
  var selectGainVsLost = ''.obs;
  var selectedFoodTypes = <String>[].obs;
  var selectFlavorType = ''.obs;

  var isDropdownOpen = false.obs;
  var isRegionOpen = false.obs;
  var isOils = false.obs;
  var isGainVsLost = false.obs;
  var isFoodType = false.obs;
  var isFlavorType = false.obs;
  //===================Get Category===============
  Future<void> getAllCategory() async {
    setRxRequestStatus(Status.loading);
    refresh();
    var response = await ApiClient.getData(ApiUrl.category);

    if (response.statusCode == 200) {
      categoryList = List<CategoryModelNew>.from(
          response.body["data"].map((x) => CategoryModelNew.fromJson(x)));

      // Sort category list alphabetically by name
      categoryList.sort((a, b) => (a.name ?? "").compareTo(b.name ?? ""));

      mealOptions.clear();
      for (var element in categoryList) {
        mealOptions.add(element.name ?? "");
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

  // Dropdown options
  List<CategoryModelNew> categoryList = [];
  final List<String> mealOptions = [];
  final List<String> regionList = [
    "Arabic",
    "Chinese",
    "Ethnic",
    "French",
    "Greek",
    "Indian",
    "Italian",
    "Japanese",
    "Mexican",
    "Thai"
  ];
  final List<String> oilsList = ["oil_free", "with_oil"];

  final List<String> gainVsLostList = [
    "maintain_weight",
    "muscle_gain",
    "weight_loss"
  ];

  final List<String> foodTypeList = [
    "animal_protein",
    "paleo",
    "plant_based",
    "vegan",
    "vegetarian",
    "whole_food"
  ];

  final List<String> flavorTypeList = ["Savory", "Sweet", "Spicy"];

  var otherSelectedValue = ''.obs;

  void callApiWithFilter({required String key, required String value}) {
    otherSelectedValue.value = value;

    final filterParam = "$key=$value";

    getRecipeBox(other: filterParam);
    // print("Calling API with filter: $filterParam");
  }

// MealType সিলেক্ট করার সময় কল করবেন
  void selectMealType(String mealType) {
    if (selectedMealTypes.contains(mealType)) {
      selectedMealTypes.remove(mealType);
    } else {
      selectedMealTypes.add(mealType);
    }
  }

// Region সিলেক্ট করার সময়
  void selectRegion(String region) {
    if (selectedRegions.contains(region)) {
      selectedRegions.remove(region);
    } else {
      selectedRegions.add(region);
    }
  }

// Oils সিলেক্ট করার সময় কল করবেন
  void selectOil(String oilType) {
    selectedOil.value = oilType;
    isOils.value = false;
  }

// GainVsLost সিলেক্ট করার সময়
  void selectGainVSLostOil(String gainLostType) {
    selectGainVsLost.value = gainLostType;
    isGainVsLost.value = false;
  }

// FoodType সিলেক্ট করার সময়
  void selectFoodTypes(String foodType) {
    if (selectedFoodTypes.contains(foodType)) {
      selectedFoodTypes.remove(foodType);
    } else {
      selectedFoodTypes.add(foodType);
    }
  }

// FlavorType সিলেক্ট করার সময়
  void selectFlavorTypes(String flavorType) {
    selectFlavorType.value = flavorType;
    isFlavorType.value = false;
  }

  // Dropdown togglers
  void toggleDropdown() {
    isDropdownOpen.value = !isDropdownOpen.value;
  }

  void toggleRegionDropdown() {
    isRegionOpen.value = !isRegionOpen.value;
  }

  void toggleGainVSLostDropdown() {
    isGainVsLost.value = !isGainVsLost.value;
  }

  void toggleOilsDropdown() {
    isOils.value = !isOils.value;
  }

  void toggleFoodType() {
    isFoodType.value = !isFoodType.value;
  }

  void toggleFlavorType() {
    isFlavorType.value = !isFlavorType.value;
  }

  //==========================Clear Method================
  void clearAllFilters() {
    selectedMealTypes.clear();
    selectedRegions.clear();
    selectedOil.value = '';
    selectGainVsLost.value = '';
    selectedFoodTypes.clear();
    selectFlavorType.value = '';
    rating.value = 0;

    // Optional: Close all dropdowns
    isDropdownOpen.value = false;
    isRegionOpen.value = false;
    isOils.value = false;
    isGainVsLost.value = false;
    isFoodType.value = false;
    isFlavorType.value = false;
    isRatingLoading.value = false;
    getRecipeBox();

    toastMessage(message: 'All filters cleared!');
  }

  // ========================Rating===================
  var isRatingLoading = false.obs;

  void callRatingFilter(BuildContext context) async {
    if (rating.value > 0) {
      isRatingLoading.value = true;
      await Future.delayed(const Duration(milliseconds: 800));

      callApiWithFilter(key: "ratting", value: rating.value.toString());

      isRatingLoading.value = false;
      context.pop(); // Close dialog
    } else {
      toastMessage(message: 'Please select a rating before continuing.');
    }
  }

  // ========================PrepTIme===================

  final Rx<RangeValues> prepTimeRange = const RangeValues(0, 200).obs;

  void getRecipeBoxWithPrepTime(BuildContext context) async {
    final start = prepTimeRange.value.start.round();
    final end = prepTimeRange.value.end.round();

    final param = "prep_time_start=$start&prep_time_end=$end";

    await getRecipeBox(other: param);

    context.pop();
  }

  //===========================Prep+Rating===================
  void applyFilters(BuildContext context) async {
    isRatingLoading.value = true;

    List<String> queryParts = [];

    // 1. Combine Meal Type and Region into Category
    List<String> categorySlugs = [];

    // Meal Types
    for (var meal in selectedMealTypes) {
      int index = categoryList.indexWhere(
        (element) => element.name?.toLowerCase() == meal.toLowerCase(),
      );
      if (index != -1) {
        categorySlugs.add(categoryList[index].slug ?? "");
      } else {
        categorySlugs.add(meal.toLowerCase().replaceAll(' ', '-'));
      }
    }

    // Regions
    for (var region in selectedRegions) {
      int index = categoryList.indexWhere(
        (element) => element.name?.toLowerCase() == region.toLowerCase(),
      );
      if (index != -1) {
        categorySlugs.add(categoryList[index].slug ?? "");
      } else {
        categorySlugs.add(region.toLowerCase().replaceAll(' ', '-'));
      }
    }

    if (categorySlugs.isNotEmpty) {
      queryParts.add("category=${categorySlugs.join(',')}");
    }

    // 2. Oils
    if (selectedOil.value.isNotEmpty) {
      queryParts.add("oils=${selectedOil.value}");
    }

    // 3. Weight/Muscle
    if (selectGainVsLost.value.isNotEmpty) {
      queryParts.add("weight_and_muscle=${selectGainVsLost.value}");
    }

    // 4. Food Type
    if (selectedFoodTypes.isNotEmpty) {
      queryParts.add("whole_food_type=${selectedFoodTypes.join(',')}");
    }

    // 5. Flavor
    if (selectFlavorType.value.isNotEmpty) {
      queryParts.add("flavor=${selectFlavorType.value}");
    }

    // 6. Rating
    if (rating.value > 0) {
      queryParts.add("ratting=${rating.value}");
    }

    // 7. Prep Time
    final start = prepTimeRange.value.start.round();
    final end = prepTimeRange.value.end.round();
    if (start > 0 || end < 200) {
      queryParts.add("prep_time_start=$start&prep_time_end=$end");
    }

    if (queryParts.isEmpty) {
      await getRecipeBox();
    } else {
      String query = queryParts.join("&");
      await getRecipeBox(other: query);
    }

    isRatingLoading.value = false;
    context.pop();
  }

  var rating = 0.obs;

  void updateRating(int newRating) {
    rating.value = newRating;
    // print('Selected Rating: $newRating');
  }
}
