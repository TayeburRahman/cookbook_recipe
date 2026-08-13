import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:recipe_app/app/view/common_widgets/recipe_box_card/recipe_box_card.dart';
import 'package:recipe_app/app/view/screens/home/controller/home_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/app/core/route_path.dart';
import '../../../../utils/enums/status.dart';
import '../../meal_plan/controller/meal_plan_controller.dart';
import '../../profile_screen/my_recipe/controller/my_recipe_controller.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final HomeController controller = Get.find<HomeController>();
  final MyRecipeController myRecipeController = Get.find<MyRecipeController>();
  final MealPlanController mealPlanController = Get.find<MealPlanController>();
  final ScrollController _scrollController = ScrollController();

  String? id;

  @override
  void initState() {
    super.initState();
    controller.searchController.clear();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when user is 200px from bottom
      if (id != null) {
        if (controller.currentSearchTerm.isNotEmpty) {
          // If searching, load more search results
          controller.search(
              search: controller.currentSearchTerm, loadMore: true);
        } else {
          // Otherwise, load more category results
          controller.getCategory(id: id!, loadMore: true);
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (id == null) {
      id = GoRouterState.of(context).extra as String?;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await controller.getCategory(id: id ?? "");

        final resultList = controller.categoryData.value.result ?? [];

        for (var recipe in resultList) {
          myRecipeController.initFavorite(
              recipe.id ?? '', recipe.favorite ?? false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        appBarContent: controller.selectedCategory,
        iconData: Icons.arrow_back,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: CustomTextField(
              inputTextStyle: const TextStyle(color: AppColors.black),
              textEditingController: controller.searchController,
              onChanged: (value) {
                controller.search(search: value.trim());
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              maxLength: 50,
              hintText: AppStrings.searchHere.tr,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          Expanded(
            child: Obx(() {
              final status = controller.rxRequestStatus.value;

              if (status == Status.loading) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                ));
              } else if (status == Status.error) {
                return Center(
                    child: CustomText(
                        text: AppStrings.noDataFound.tr,
                        color: AppColors.black));
              } else if (status == Status.internetError) {
                return Center(
                    child: CustomText(
                        text: AppStrings.noInternetFound.tr,
                        color: AppColors.black));
              }

              final resultList = controller.categoryData.value.result;
              if (resultList == null || resultList.isEmpty) {
                return Center(
                    child: CustomText(
                        text: AppStrings.noDataFound.tr,
                        color: AppColors.black));
              }

              return ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16.r),
                itemCount: resultList.length + (controller.hasMoreData ? 1 : 0),
                itemBuilder: (context, index) {
                  // Show loading indicator at the bottom
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

                  final data = resultList[index];

                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: RecipeBoxCard(
                      isMoreVert: false,
                      onMoreTap: () {
                        log('object');
                      },
                      isFavorite:
                          myRecipeController.favorites[data.id]?.value ?? false,
                      onFavoriteTap: () {
                        myRecipeController.favoriteAdd(data.id ?? '');
                      },
                      isAdd: false,
                      onAdd: () {},
                      onTap: () {
                        context.pushNamed(
                          RoutePath.recipeDetails,
                          extra: {
                            "id": data.id ?? "",
                            "isExist": myRecipeController.favorites[data.id]?.value ?? (data.favorite ?? false),
                          },
                        );
                      },
                      isRating: true,
                      category: data.category?.join(", ") ?? "",
                      title: data.name ?? "",
                      imageUrl: "${data.image}",
                      time: "${data.prepTime} min",
                      rating: "${data.ratting?.toStringAsFixed(1)}",
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
