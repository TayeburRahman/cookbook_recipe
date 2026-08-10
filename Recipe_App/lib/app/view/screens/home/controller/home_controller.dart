import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/global/model/category_model.dart';
import 'package:recipe_app/app/models/home/banner_model.dart' show BannerList;
import 'package:recipe_app/app/models/home/recipe_for_you_model.dart';
import 'package:recipe_app/app/services/api_check.dart';
import 'package:recipe_app/app/services/api_client.dart';
import 'package:recipe_app/app/services/app_url.dart';
import 'package:recipe_app/app/utils/enums/status.dart';

import '../../../../models/home/category.dart';

class HomeController extends GetxController {
  String selectedCategory = "";
  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  final Rx<Status> rxRequestStatus = Status.loading.obs;

  //>>>>>>>>>>>>>>>>>>✅✅Recipe Method For You✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxList<RecipeForYouList> recipeForYouList = <RecipeForYouList>[].obs;

  Future<void> recipeForYou({bool isGlobal = false}) async {
    if (!isGlobal) {
      setRxRequestStatus(Status.loading);
      refresh();
    }

    try {
      var response = await ApiClient.getData(ApiUrl.recipeForYou);

      if (response.statusCode == 200) {
        recipeForYouList.value = List<RecipeForYouList>.from(
            response.body["data"].map((x) => RecipeForYouList.fromJson(x)));
        debugPrint(
            "For You RecipeList=================${recipeForYouList.length}");

        if (!isGlobal) {
          setRxRequestStatus(Status.completed);
          refresh();
        }
      } else {
        if (!isGlobal) {
          if (response.statusText == ApiClient.noInternetMessage) {
            setRxRequestStatus(Status.internetError);
          } else {
            setRxRequestStatus(Status.error);
          }
          ApiChecker.checkApi(response);
          refresh();
        }
      }
    } catch (e) {
      if (!isGlobal) {
        setRxRequestStatus(Status.error);
        refresh();
      }
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Banner✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxList<BannerList> bannerList = <BannerList>[].obs;

  Future<void> getBanner({bool isGlobal = false}) async {
    if (!isGlobal) {
      setRxRequestStatus(Status.loading);
      refresh();
    }

    try {
      var response = await ApiClient.getData(ApiUrl.banner);

      if (response.statusCode == 200) {
        bannerList.value = List<BannerList>.from(
            response.body["data"].map((x) => BannerList.fromJson(x)));
        debugPrint("Total Ads=================${bannerList.length}");

        if (!isGlobal) {
          setRxRequestStatus(Status.completed);
          refresh();
        }
      } else {
        if (!isGlobal) {
          if (response.statusText == ApiClient.noInternetMessage) {
            setRxRequestStatus(Status.internetError);
          } else {
            setRxRequestStatus(Status.error);
          }
          ApiChecker.checkApi(response);
          refresh();
        }
      }
    } catch (e) {
      if (!isGlobal) {
        setRxRequestStatus(Status.error);
        refresh();
      }
    }
  }

  @override
  void onInit() {
    // Don't auto-load data here to avoid duplicate calls
    // Let the UI trigger data loading when needed
    super.onInit();
  }
  //>>>>>>>>>>>>>>>>>>✅✅ Category List✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  var currentIndex = 0.obs; // Reactive variable for carousel index
  List<CategoryModelNew> categoryList = [];

  //===================Get Category===============
  Future<void> getAllCategory({bool isGlobal = false}) async {
    if (!isGlobal) {
      setRxRequestStatus(Status.loading);
      refresh();
    }

    try {
      var response = await ApiClient.getData(ApiUrl.category);

      if (response.statusCode == 200) {
        categoryList = List<CategoryModelNew>.from(
            response.body["data"].map((x) => CategoryModelNew.fromJson(x)));

        if (!isGlobal) {
          setRxRequestStatus(Status.completed);
          refresh();
        }
      } else {
        if (!isGlobal) {
          if (response.statusText == ApiClient.noInternetMessage) {
            setRxRequestStatus(Status.internetError);
          } else {
            setRxRequestStatus(Status.error);
          }
          ApiChecker.checkApi(response);
          refresh();
        }
      }
    } catch (e) {
      if (!isGlobal) {
        setRxRequestStatus(Status.error);
        refresh();
      }
    }
  }

  // ... (rest of the file remains same until getGoal, getAllData etc)

  // ... (rest of existing code needs to be verified if I'm replacing too much)
  // Wait, I need to be careful with replacement scope.
  // I will target getAllData separately or include it focused.

  // This replacement chunk is too large and risky. Let me split it.
  // I will replace methods one by one or group logically.

  final Rx<CategoryData> categoryData =
      CategoryData().obs; // Holds profile data

  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  String currentCategoryId = "";
  String currentSearchTerm = "";

  // Search controller for category screen
  TextEditingController searchController = TextEditingController();

  Future<void> getCategory({required String id, bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore || !hasMoreData) return;
      isLoadingMore = true;
      currentPage++;
    } else {
      setRxRequestStatus(Status.loading);
      currentPage = 1;
      hasMoreData = true;
      currentCategoryId = id;
      currentSearchTerm = ""; // Clear search when loading new category
    }

    refresh();
    var response = await ApiClient.getData(
        ApiUrl.getCategories(id: id, page: currentPage, limit: 10));

    if (!loadMore) {
      setRxRequestStatus(Status.completed);
    }

    if (response.statusCode == 200) {
      final newData = CategoryData.fromJson(response.body["data"]);

      if (loadMore) {
        // Append new results to existing list
        final existingResults = categoryData.value.result ?? [];
        final newResults = newData.result ?? [];
        categoryData.value = CategoryData(
          result: [...existingResults, ...newResults],
          meta: newData.meta,
        );

        // Check if there's more data
        if (newData.meta != null) {
          hasMoreData = currentPage < (newData.meta!.totalPage ?? 0);
        }
      } else {
        // Initial load
        categoryData.value = newData;
        if (newData.meta != null) {
          hasMoreData = currentPage < (newData.meta!.totalPage ?? 0);
        }
      }

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

  // Search within category
  Future<void> search({required String search, bool loadMore = false}) async {
    if (search.isEmpty) {
      // If search is empty, reload category data
      await getCategory(id: currentCategoryId);
      return;
    }

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

    refresh();

    // Search within the current category
    var response = await ApiClient.getData(ApiUrl.searchRecipe(
        name: currentSearchTerm, page: currentPage, limit: 10));

    if (!loadMore) {
      setRxRequestStatus(Status.completed);
    }

    if (response.statusCode == 200) {
      final dataJson = response.body["data"];
      if (dataJson != null) {
        final newData = CategoryData.fromJson(dataJson);

        if (loadMore) {
          // Append new results to existing list
          final existingResults = categoryData.value.result ?? [];
          final newResults = newData.result ?? [];
          categoryData.value = CategoryData(
            result: [...existingResults, ...newResults],
            meta: newData.meta,
          );

          // Check if there's more data
          if (newData.meta != null) {
            hasMoreData = currentPage < (newData.meta!.totalPage ?? 0);
          }
        } else {
          // Initial load
          categoryData.value = newData;
          if (newData.meta != null) {
            hasMoreData = currentPage < (newData.meta!.totalPage ?? 0);
          }
        }
      }
      isLoadingMore = false;
      refresh();
    } else {
      if (!loadMore) {
        setRxRequestStatus(Status.error);
      }
      isLoadingMore = false;
      ApiChecker.checkApi(response);
    }
  }

  //===================Get goal===============
  final Rx<CategoryData> getGoalData = CategoryData().obs;

  int goalCurrentPage = 1;
  bool goalIsLoadingMore = false;
  bool goalHasMoreData = true;

  Future<void> getGaol({required String name, bool loadMore = false}) async {
    if (loadMore) {
      if (goalIsLoadingMore || !goalHasMoreData) return;
      goalIsLoadingMore = true;
      goalCurrentPage++;
    } else {
      setRxRequestStatus(Status.loading);
      goalCurrentPage = 1;
      goalHasMoreData = true;
    }

    refresh();
    var response = await ApiClient.getData(ApiUrl.getWeightLossMuscleGain(
        goal: name, page: goalCurrentPage, limit: 10));

    if (!loadMore) {
      setRxRequestStatus(Status.completed);
    }

    if (response.statusCode == 200) {
      final newData = CategoryData.fromJson(response.body["data"]);

      if (loadMore) {
        // Append new results to existing list
        final existingResults = getGoalData.value.result ?? [];
        final newResults = newData.result ?? [];
        getGoalData.value = CategoryData(
          result: [...existingResults, ...newResults],
          meta: newData.meta,
        );

        // Check if there's more data
        if (newData.meta != null) {
          goalHasMoreData = goalCurrentPage < (newData.meta!.totalPage ?? 0);
        }
      } else {
        // Initial load
        getGoalData.value = newData;
        if (newData.meta != null) {
          goalHasMoreData = goalCurrentPage < (newData.meta!.totalPage ?? 0);
        }
      }

      goalIsLoadingMore = false;
      refresh();

      debugPrint("GetGoalData=====${getGoalData.value.result?.length}");
    } else {
      if (!loadMore) {
        if (response.statusText == ApiClient.noInternetMessage) {
          setRxRequestStatus(Status.internetError);
        } else {
          setRxRequestStatus(Status.error);
        }
      }
      goalIsLoadingMore = false;
      ApiChecker.checkApi(response);
    }
  }

  Future<void> getAllData() async {
    setRxRequestStatus(Status.loading);
    refresh();

    try {
      await Future.wait([
        getBanner(isGlobal: true),
        recipeForYou(isGlobal: true),
        getAllCategory(isGlobal: true),
      ]);

      setRxRequestStatus(Status.completed);
      refresh();
    } catch (e) {
      setRxRequestStatus(Status.error);
      refresh();
    }
  }
}
