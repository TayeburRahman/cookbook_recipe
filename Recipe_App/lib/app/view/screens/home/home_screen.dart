import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/app/core/route_path.dart';
import 'package:recipe_app/app/core/routes.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_constants/app_constants.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/enums/status.dart' show Status;
import 'package:recipe_app/app/view/common_widgets/common_home_app_bar/common_home_app_bar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_home_card/custom_home_card.dart';
import 'package:recipe_app/app/view/common_widgets/custom_loader/custom_loader.dart'
    show CustomLoader;
import 'package:recipe_app/app/view/common_widgets/custom_nav_bar/custom_nav_bar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/common_widgets/recipe_card/recipe_card.dart';
import 'package:recipe_app/app/view/screens/home/controller/home_controller.dart';
import 'package:recipe_app/app/view/screens/home/widgets/diet_goals_widgets.dart';
import 'package:recipe_app/app/view/screens/home/widgets/sliders_widgets.dart';
import 'package:recipe_app/app/view/screens/profile_screen/personal_info/controller/profile_controller.dart';
import 'package:recipe_app/app/view/screens/profile_screen/my_recipe/controller/my_recipe_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeController = Get.find<HomeController>();
  final profileController = Get.find<ProfileController>();
  final myRecipeController = Get.find<MyRecipeController>();
  final _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Create once, not on every rebuild

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Only fetch if data is missing
      if (profileController.profileModel.value.name == null) {
        profileController.getProfile();
      }
      if (homeController.bannerList.isEmpty) {
        homeController.getAllData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: const CustomNavBar(currentIndex: 0),
      body: RefreshIndicator(
        color: Colors.black,
        onRefresh: () async {
          await profileController.getProfile();
          await homeController.getAllData();
        },
        child: CustomScrollView(
          slivers: [
            // Top spacing
            SliverToBoxAdapter(
              child: SizedBox(height: 20.h),
            ),

            //===================== Appbar =====================
            SliverToBoxAdapter(
              child: Obx(() {
                return CommonHomeAppBar(
                  isSearch: true,
                  onSearch: () =>
                      AppRouter.route.pushNamed(RoutePath.searchRecipe),
                  scaffoldKey: _scaffoldKey, // Use the instance variable
                  name: profileController.profileModel.value.name ?? '',
                  image: profileController
                              .profileModel.value.profileImage?.isNotEmpty ==
                          true
                      ? "${profileController.profileModel.value.profileImage!}"
                      : AppConstants.profile,
                  onTap: () =>
                      AppRouter.route.pushNamed(RoutePath.notificationScreen),
                );
              }),
            ),

            //===================== Banner =====================
            SliverToBoxAdapter(
              child: Obx(() {
                if (homeController.rxRequestStatus.value == Status.loading) {
                  return const CustomLoader();
                } else if (homeController.rxRequestStatus.value ==
                    Status.error) {
                  return CustomText(
                      text: AppStrings.issueFound.tr,
                      fontSize: 20.sp,
                      color: AppColors.black);
                } else if (homeController.rxRequestStatus.value ==
                    Status.internetError) {
                  return CustomText(
                      text: AppStrings.noInternetFound.tr,
                      fontSize: 20.sp,
                      color: AppColors.black);
                }

                if (homeController.bannerList.isEmpty) {
                  return Center(
                      child: CustomText(
                          text: AppStrings.noDataFound.tr,
                          fontSize: 20.sp,
                          color: AppColors.black));
                }

                return SlidersWidgets(homeController: homeController);
              }),
            ),

            //===================== Diet goals Title =====================
            SliverToBoxAdapter(
              child: _buildSectionHeader(AppStrings.dietGoals.tr),
            ),

            //===================== Diet goals Widget =====================
            const SliverToBoxAdapter(
              child: DietGoals(),
            ),

            SliverToBoxAdapter(
              child: SizedBox(height: 16.h),
            ),

            //===================== Recipes for you Title =====================
            SliverToBoxAdapter(
              child: _buildSectionHeader(AppStrings.recipesForYou.tr),
            ),

            //===================== Recipes for you List =====================
            SliverToBoxAdapter(
              child: Obx(() {
                if (homeController.recipeForYouList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: CustomText(
                        text: AppStrings.noRecipesFound.tr,
                        fontSize: 16.sp,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: 225.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: homeController.recipeForYouList.length,
                    itemBuilder: (context, index) {
                      final data = homeController.recipeForYouList[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 14.w),
                        child: GestureDetector(
                          onTap: () {
                            context.pushNamed(
                              RoutePath.recipeDetails,
                              extra: {
                                "id": data.id ?? "",
                                "isExist": myRecipeController.favorites[data.id]?.value ?? false,
                              },
                            );
                          },
                          child: RecipeCard(
                            name: data.name ?? "",
                            description: data.category?.join(", ") ?? "",
                            imageUrl: data.image ?? "",
                            rating: (data.ratting ?? 0).toDouble(),
                            prepTime: data.prepTime.toString(),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),

            SliverToBoxAdapter(
              child: SizedBox(height: 12.h),
            ),

            //===================== Category Title =====================
            SliverToBoxAdapter(
              child: _buildSectionHeader(AppStrings.category.tr),
            ),

            // ===================== Category Grid =====================
            Obx(() {
              if (homeController.rxRequestStatus.value == Status.loading) {
                return const SliverToBoxAdapter(child: CustomLoader());
              } else if (homeController.rxRequestStatus.value == Status.error) {
                return SliverToBoxAdapter(
                  child: CustomText(
                      text: AppStrings.issueFound.tr,
                      fontSize: 20.sp,
                      color: AppColors.black),
                );
              } else if (homeController.rxRequestStatus.value ==
                  Status.internetError) {
                return SliverToBoxAdapter(
                  child: CustomText(
                      text: AppStrings.noInternetFound.tr,
                      fontSize: 20.sp,
                      color: AppColors.black),
                );
              }
              if (homeController.categoryList.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: CustomText(
                        text: AppStrings.noDataFound.tr,
                        fontSize: 20.sp,
                        color: AppColors.black),
                  ),
                );
              }
              return SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var category = homeController.categoryList[index];

                      return GestureDetector(
                        onTap: () {
                          homeController.selectedCategory =
                              category.name ?? "N/A";
                          AppRouter.route.pushNamed(
                            RoutePath.categoryScreen,
                            extra: category.slug.toString(),
                          );
                        },
                        child: CustomHomeCard(
                          title: category.name ?? "",
                          image: category.image ?? "",
                          color: Colors.white,
                          elevation: 2.0,
                        ),
                      );
                    },
                    childCount: homeController.categoryList.length,
                  ),
                ),
              );
            }),
            SliverToBoxAdapter(
              child: SizedBox(height: 50.w),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 18.h,
            decoration: BoxDecoration(
              color: AppColors.bottomNabColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(width: 8.w),
          CustomText(
            textAlign: TextAlign.start,
            text: title,
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ],
      ),
    );
  }
}
