import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/app/core/route_path.dart';
import 'package:recipe_app/app/core/routes.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/enums/status.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_dialoge_alart/custom_dialoge_alart.dart';
import 'package:recipe_app/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/common_widgets/favorite_item/favorite_item.dart';
import 'package:recipe_app/app/view/common_widgets/genarel_error_screen/genarel_error_screen.dart';
import 'package:recipe_app/app/view/common_widgets/no_internet_screen/no_internet_screen.dart';
import 'package:recipe_app/app/view/screens/profile_screen/my_recipe/controller/my_recipe_controller.dart';

class MyRecipeScreen extends StatefulWidget {
  const MyRecipeScreen({super.key});

  @override
  State<MyRecipeScreen> createState() => _MyRecipeScreenState();
}

class _MyRecipeScreenState extends State<MyRecipeScreen> {
  final MyRecipeController controller = Get.find<MyRecipeController>();

  @override
  void initState() {
    controller.getMyRecipe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,

        ///============================ Header ===============================
        appBar: CustomAppBar(
          appBarContent: AppStrings.myRecipe.tr,
          iconData: Icons.arrow_back,
          appBarBgColor: AppColors.white,
        ),
        body: Obx(() {
          switch (controller.rxRequestStatus.value) {
            case Status.loading:
              return const CustomLoader();
            case Status.internetError:
              return NoInternetScreen(onTap: () {
                controller.getFavorites();
              });
            case Status.error:
              return GeneralErrorScreen(
                onTap: () {
                  controller.getMyRecipe();
                },
              );
            case Status.completed:
              if (controller.myRecipeList.isEmpty) {
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
                  // reverse: true,
                  itemCount: controller.myRecipeList.length,
                  itemBuilder: (context, index) {
                    var data = controller.myRecipeList[index];

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed(
                            RoutePath.recipeDetails,
                            extra: {
                              "id": data.id ?? "",
                              "isExist": controller.favorites[data.id]?.value ?? false,
                            },
                          );
                        },
                        child: FavoriteItem(
                          onRemove: () {
                            CustomDialogAlert.showDeleteConfirmationDialog(
                                context, () {
                              controller.removeRecipe(
                                id: data.id ?? "",
                                context: context,
                              );
                            });
                          },
                          onEdit: () {
                            AppRouter.route
                                .pushNamed(RoutePath.addRecipe, extra: data);
                          },
                          isEdit: true,
                          isBgWhiteColor: true,
                          isFavorites: true,
                          category: data.category?.join(", ") ?? "",
                          title: data.name ?? "No Name",
                          imageUrl: "${data.image}",
                          time: '${data.prepTime} min',
                          rating: '${data.ratting}',
                        ),
                      ),
                    );
                  },
                ),
              );
          }
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AppRouter.route.pushNamed(
              RoutePath.addRecipe,
            );
          },
          backgroundColor: AppColors.bottomNabColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ));
  }
}
