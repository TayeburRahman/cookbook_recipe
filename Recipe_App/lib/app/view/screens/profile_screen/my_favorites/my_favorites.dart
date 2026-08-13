import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/app/core/route_path.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/enums/status.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/common_widgets/genarel_error_screen/genarel_error_screen.dart';
import 'package:recipe_app/app/view/common_widgets/no_internet_screen/no_internet_screen.dart';
import 'package:recipe_app/app/view/common_widgets/recipe_box_card/recipe_box_card.dart';
import 'package:recipe_app/app/view/screens/profile_screen/my_recipe/controller/my_recipe_controller.dart';

class MyFavorites extends StatefulWidget {
  const MyFavorites({super.key});

  @override
  State<MyFavorites> createState() => _MyFavoritesState();
}

class _MyFavoritesState extends State<MyFavorites> {
  final MyRecipeController controller = Get.find<MyRecipeController>();

  @override
  void initState() {
    controller.getFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        appBarContent: AppStrings.myFavorites.tr,
        iconData: Icons.arrow_back,
        appBarBgColor: AppColors.white,
      ),
      body: SafeArea(
        child: Obx(() {
          switch (controller.rxRequestStatus.value) {
            case Status.loading:
              return const CustomLoader(); // Show loading indicator
            case Status.internetError:
              return NoInternetScreen(onTap: () {
                controller.getFavorites();
              });
            case Status.error:
              return GeneralErrorScreen(
                onTap: () {
                  controller.getFavorites();
                },
              );
            case Status.completed:
              // Show message if no data is available
              if (controller.favoriteRecipeData.value.data?.recipes?.isEmpty ??
                  true) {
                return Center(
                  child: CustomText(
                    text: "No Data Found",
                    fontSize: 20.sp,
                    color: AppColors.black,
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.w),
                child: ListView.builder(
                  itemCount: controller
                          .favoriteRecipeData.value.data?.recipes?.length ??
                      0,
                  itemBuilder: (context, index) {
                    var data = controller
                        .favoriteRecipeData.value.data?.recipes?[index];

                    if (data == null) {
                      return Container();
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: RecipeBoxCard(
                        showFavoriteIcon:
                            true, // ✅ if planId/day null, show favorite

                        isFavorite:
                            controller.favorites[data.id]?.value ?? false,
                        onFavoriteTap: () {
                          controller.favoriteAdd(data.id ?? '');
                        },
                        isAdd: false,
                        onAdd: () {
                          if (data.id != null) {
                            controller.favoriteAddRemove(id: data.id!);
                          }
                        },

                        onTap: () {
                          context.pushNamed(
                            RoutePath.recipeDetails,
                            extra: {
                              "id": data.id ?? "",
                              "isExist": controller.favorites[data.id]?.value ?? true,
                            },
                          );
                        },

                        isRating: true,
                        category: data.category?.join(", ") ?? "N/A",
                        title: data.name ?? "N/A",
                        imageUrl: data.image ==
                                "https://res.cloudinary.com/dudch9v0a/image/upload/v1765352079/recipes/image_3192.jpg"
                            ? "https://res.cloudinary.com/dudch9v0a/image/upload/v1765352079/recipes/image_3192.jpg"
                            : "${data.image}",
                        time: '${data.prepTime} min',
                        rating: '${data.ratting?.toStringAsFixed(1)}',
                      ),
                    );

                    // return Padding(
                    //   padding: EdgeInsets.symmetric(vertical: 10.h),
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       context.pushNamed(
                    //         RoutePath.recipeDetails,
                    //         extra: {
                    //           "id": data.id ?? "",
                    //           "isExist": true, // ✅ pass this flag
                    //         },
                    //       );
                    //     },
                    //     child: FavoriteItem(
                    //       category: data.category ?? "Unknown",
                    //       title: data.name ?? "No Name",
                    //       imageUrl: "${data.image}",
                    //       time: '${data.prepTime} min',
                    //       rating: '${data.ratting}',
                    //       onAdd: () {
                    //         if (data.id != null) {
                    //           controller.favoriteAddRemove(id: data.id!);
                    //         }
                    //       },
                    //       onEdit: () {},
                    //       isFavorite: RxBool(data.favorite ?? false),
                    //     ),
                    //   ),
                    // );
                  },
                ),
              );
          }
        }),
      ),
    );
  }
}
