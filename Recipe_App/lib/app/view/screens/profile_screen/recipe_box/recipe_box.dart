import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/app/core/route_path.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/enums/status.dart' show Status;
import 'package:recipe_app/app/view/common_widgets/common_filter_box/common_filter_box.dart';
import 'package:recipe_app/app/view/common_widgets/custom_loader/custom_loader.dart'
    show CustomLoader;
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/common_widgets/genarel_error_screen/genarel_error_screen.dart'
    show GeneralErrorScreen;
import 'package:recipe_app/app/view/common_widgets/no_internet_screen/no_internet_screen.dart'
    show NoInternetScreen;
import 'package:recipe_app/app/view/screens/home/search_field/search_field.dart';
import 'package:recipe_app/app/view/screens/meal_plan/controller/meal_plan_controller.dart';
import 'package:recipe_app/app/view/screens/profile_screen/my_recipe/controller/my_recipe_controller.dart';
import 'package:recipe_app/app/view/screens/profile_screen/recipe_box/controller/recipe_box_controller.dart';
import 'package:recipe_app/app/view/common_widgets/custom_nav_bar/custom_nav_bar.dart';
import '../../../common_widgets/recipe_box_card/recipe_box_card.dart';

class RecipeBox extends StatefulWidget {
  final Map<String, dynamic>? extraData;

  const RecipeBox({super.key, this.extraData});

  @override
  State<RecipeBox> createState() => _RecipeBoxState();
}

class _RecipeBoxState extends State<RecipeBox> {
  final RecipeBoxController controller = Get.find<RecipeBoxController>();
  final MealPlanController mealPlanController = Get.find<MealPlanController>();
  final MyRecipeController myRecipeController = Get.find<MyRecipeController>();

  final ScrollController _scrollController = ScrollController();

  String? planId;
  String? planName;
  String? day;
  String? removeId;
  bool isSwap = false;

  @override
  void initState() {
    super.initState();

    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);

    final extraData = widget.extraData;

    if (extraData != null) {
      planId = extraData['planId']?.toString();
      planName = extraData['planName']?.toString();
      day = extraData['day']?.toString();
      removeId = extraData['recipeId']?.toString();
      isSwap = extraData['isSwap'] == true;

      debugPrint("✅ ====== Plan ID: $planId");
      debugPrint("✅ ====== Plan Name: $planName");
      debugPrint("✅ =======Received Day: $day");
      debugPrint("✅ =======recipe id: $removeId");
      debugPrint("✅ =======IsSwap: $isSwap");

      mealPlanController.selectedPlanId.value = planId ?? "";
      mealPlanController.selectedDay.value = day ?? "";
      // Category Logic
      // Clear all filters and reset pagination
      controller.resetFiltersAndPagination();
      controller.searchController.clear();
      controller.mealOptions.clear();
      controller.getAllCategory();
    } else {
      debugPrint("⚠️ No extra data received.");
      planId = null;
      day = null;
    }

    final selectedParam = controller.currentFilterParams;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getRecipeBox(
        other: selectedParam,
      );

      final resultList = controller.recipeBoxData.value.result ?? [];
      for (var recipe in resultList) {
        myRecipeController.initFavorite(
            recipe.id ?? '', recipe.favorite ?? false);
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.85) {
      // Load more when user scrolls 85% of the way down
      if (!controller.isLoadingMore && controller.hasMoreData) {
        controller.getRecipeBox(
          other: controller.currentFilterParams,
          loadMore: true,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    controller.resetFiltersAndPagination();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.white,
        // actions: [
        //   GestureDetector(
        //     onTap: () {
        //       CommonFilterBox.filterBox(
        //         context: context,
        //         controller: controller,
        //       );
        //     },
        //     child: Container(
        //       // height: 50.h,
        //       margin: EdgeInsets.only(right: 10.w),
        //       padding:
        //           EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 8.0.h),
        //       decoration: const BoxDecoration(
        //         color: AppColors.green900,
        //         borderRadius: BorderRadius.all(Radius.circular(5)),
        //       ),
        //       child: Row(
        //         children: [
        //           CustomText(
        //             text: AppStrings.filter.tr,
        //             color: AppColors.white,
        //             fontSize: 12.sp,
        //             fontWeight: FontWeight.w400,
        //           ),
        //           SizedBox(width: 10.w),
        //           Assets.images.filter.image(),
        //         ],
        //       ),
        //     ),
        //   ),
        // ],
        title: CustomText(
          text: (planId != null && day != null)
              ? "ADD A RECIPE TO THE PLAN"
              : AppStrings.recipeBox.tr,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w500,
          fontSize: 18.sp,
          color: AppColors.black,
        ),
      ),

      // appBar: CustomAppBar(
      //   isFilter: true,
      //   onFilterTap: () {
      //     CommonFilterBox.filterBox(
      //       context: context,
      //       controller: controller,
      //     );
      //   },s
      //   appBarContent: AppStrings.recipeBox.tr,
      //   iconData: Icons.arrow_back,
      //   appBarBgColor: AppColors.white,
      // ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 5),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       child: CustomTextField(
              //         inputTextStyle: const TextStyle(color: AppColors.black),
              //         textEditingController: controller.searchController,
              //         onChanged: (value) {
              //           controller.search(search: value.trim());
              //         },
              //         keyboardType: TextInputType.text,
              //         textInputAction: TextInputAction.search,
              //         maxLength: 50,
              //         hintText: AppStrings.searchHere.tr,
              //         prefixIcon: const Icon(Icons.search),
              //       ),
              //     ),
              //     SizedBox(width: 10.w),
              //     GestureDetector(
              //       onTap: () {
              //         CommonFilterBox.filterBox(
              //           context: context,
              //           controller: controller,
              //         );
              //       },
              //       child: Container(
              //         height: 50.h,
              //         padding: EdgeInsets.symmetric(
              //             horizontal: 10.0.w, vertical: 5.0.h),
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: const BorderRadius.all(Radius.circular(5)),
              //           border: Border.all(color: Colors.grey),
              //         ),
              //         child: Row(
              //           children: [
              //             CustomText(
              //               text: AppStrings.filter.tr,
              //               color: AppColors.green,
              //               fontSize: 12.sp,
              //               fontWeight: FontWeight.bold,
              //             ),
              //             SizedBox(width: 5.w),
              //             const Icon(
              //               Icons.filter_alt_outlined,
              //               color: AppColors.green,
              //             )
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchFilterRow(onFilterTap: () {
                      CommonFilterBox.filterBox(
                        context: context,
                        controller: controller,
                      );
                    }),
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
              Expanded(
                child: Obx(() {
                  switch (controller.rxRequestStatus.value) {
                    case Status.loading:
                      return const CustomLoader();
                    case Status.internetError:
                      return NoInternetScreen(onTap: () {
                        controller.getRecipeBox(
                            other: controller.currentFilterParams);
                      });
                    case Status.error:
                      return GeneralErrorScreen(
                        onTap: () {
                          controller.getRecipeBox(
                              other: controller.currentFilterParams);
                        },
                      );
                    case Status.completed:
                      if (controller.recipeBoxData.value.result?.isEmpty ??
                          true) {
                        return Center(
                          child: CustomText(
                            text: AppStrings.noDataFound.tr,
                            fontSize: 20.sp,
                            color: AppColors.black,
                          ),
                        );
                      }

                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: controller
                                      .recipeBoxData.value.result?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                var data = controller
                                    .recipeBoxData.value.result?[index];

                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: RecipeBoxCard(
                                    showFavoriteIcon:
                                        planId == null || day == null,
                                    isFavorite: myRecipeController
                                            .favorites[data?.id]?.value ??
                                        false,
                                    onFavoriteTap: () {
                                      myRecipeController
                                          .favoriteAdd(data?.id ?? '');
                                    },
                                    isAdd: planId != null && day != null,
                                    onAdd: () async {
                                      if (planId != null && day != null) {
                                        if (isSwap) {
                                          await mealPlanController.swapAdd(
                                            removeId: removeId ?? "",
                                            newId: data?.id ?? "",
                                            day: day ?? "",
                                            planId: planId ?? "",
                                          );
                                        } else {
                                          await mealPlanController.addRecipe(
                                            planId: planId ?? "",
                                            recipeId: data?.id ?? "",
                                            day: day ?? "",
                                          );
                                        }
                                        context.pop(true);
                                      } else {
                                        Get.snackbar(
                                          "Error",
                                          "No plan selected",
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                      }
                                    },
                                    onTap: () {
                                      context.pushNamed(
                                        RoutePath.recipeDetails,
                                        extra: {
                                          "id": data?.id ?? "",
                                          "isExist": myRecipeController.favorites[data?.id]?.value ?? (data?.favorite ?? false),
                                          "planName": planName ?? "",
                                          "planId": planId ?? "",
                                          "day": day ?? "",
                                        },
                                      );
                                    },
                                    isRating: true,
                                    category: data?.category?.join(", ") ?? "",
                                    title: data?.name ?? "No Name",
                                    imageUrl: "${data?.image}",
                                    time: '${data?.prepTime} min',
                                    rating:
                                        '${data?.ratting?.toStringAsFixed(1)}',
                                  ),
                                );
                              },
                            ),
                          ),
                          // Loading indicator at the bottom when loading more
                          if (controller.isLoadingMore)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: const CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                        ],
                      );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
