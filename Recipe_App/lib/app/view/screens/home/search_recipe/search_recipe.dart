import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/app/core/route_path.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/enums/status.dart';
import 'package:recipe_app/app/view/common_widgets/common_filter_box/common_filter_box.dart';
import 'package:recipe_app/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/common_widgets/genarel_error_screen/genarel_error_screen.dart';
import 'package:recipe_app/app/view/common_widgets/no_internet_screen/no_internet_screen.dart';
import 'package:recipe_app/app/view/common_widgets/recipe_box_card/recipe_box_card.dart';
import 'package:recipe_app/app/view/screens/home/search_field/search_field.dart';
import 'package:recipe_app/app/view/screens/profile_screen/my_recipe/controller/my_recipe_controller.dart';
import 'package:recipe_app/app/view/screens/profile_screen/recipe_box/controller/recipe_box_controller.dart';

class SearchRecipe extends StatefulWidget {
  const SearchRecipe({super.key});

  @override
  State<SearchRecipe> createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipe> {
  final RecipeBoxController controller = Get.find<RecipeBoxController>();
  final MyRecipeController myRecipeController = Get.find<MyRecipeController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    // Clear all filters and reset pagination
    controller.resetFiltersAndPagination();
    controller.mealOptions.clear();
    controller.getAllCategory();

    // Load all recipes without any filter parameters
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getRecipeBox(other: "");

      // Initialize favorites for the loaded recipes
      final resultList = controller.recipeBoxData.value.result ?? [];
      for (var recipe in resultList) {
        myRecipeController.initFavorite(
            recipe.id ?? '', recipe.favorite ?? false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    controller.resetFiltersAndPagination();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when user is 200px from bottom
      if (controller.currentSearchTerm.isNotEmpty) {
        controller.search(search: controller.currentSearchTerm, loadMore: true);
      } else {
        controller.getRecipeBox(loadMore: true);
      }
    }
  }

  void _showFilterBox() {
    CommonFilterBox.filterBox(
      context: context,
      controller: controller,
    );
  }

  Widget _buildRecipeList() {
    if (controller.recipeBoxData.value.result == null ||
        controller.recipeBoxData.value.result!.isEmpty) {
      return Center(
        child: CustomText(
          text: AppStrings.noDataFound.tr,
          fontSize: 20.sp,
          color: AppColors.black,
        ),
      );
    }

    final resultList = controller.recipeBoxData.value.result ?? [];

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
      itemCount: resultList.length + (controller.hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        // loading indicator
        if (index == resultList.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          );
        }

        var data = resultList[index];

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: RecipeBoxCard(
            isFavorite: myRecipeController.favorites[data.id]?.value ?? false,
            onFavoriteTap: () {
              myRecipeController.favoriteAdd(data.id ?? '');
            },
            onTap: () {
              context.pushNamed(
                RoutePath.recipeDetails,
                extra: {
                  "id": data.id ?? "",
                  "isExist": true,
                },
              );
            },
            isRating: true,
            category: data.category?.join(", ") ?? "",
            title: data.name ?? "No Name",
            imageUrl: "${data.image}",
            time: '${data.prepTime} min',
            rating: '${data.ratting?.toStringAsFixed(1)}',
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return Obx(() {
      switch (controller.rxRequestStatus.value) {
        case Status.loading:
          return const CustomLoader();
        case Status.internetError:
          return NoInternetScreen(onTap: () {
            controller.getRecipeBox(other: controller.currentFilterParams);
          });
        case Status.error:
          return GeneralErrorScreen(
            onTap: () {
              controller.getRecipeBox(other: controller.currentFilterParams);
            },
          );
        case Status.completed:
          return _buildRecipeList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        centerTitle: true,
        title: Text(
          AppStrings.searchRecipe.tr,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchFilterRow(onFilterTap: _showFilterBox),
                  // CustomText(
                  //   top: 10.h,
                  //   text: AppStrings.recentSearch.tr,
                  //   fontSize: 16.sp,
                  //   fontWeight: FontWeight.w600,
                  //   color: AppColors.green,
                  //   bottom: 10.h,
                  // ),
                ],
              ),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }
}
