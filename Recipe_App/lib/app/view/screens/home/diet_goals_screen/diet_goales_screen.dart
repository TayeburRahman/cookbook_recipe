import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:recipe_app/app/view/common_widgets/recipe_box_card/recipe_box_card.dart';
import 'package:recipe_app/app/view/screens/home/controller/home_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/app/core/route_path.dart';
import '../../../../utils/enums/status.dart';
import '../../profile_screen/my_recipe/controller/my_recipe_controller.dart';

class DietGoalesScreen extends StatefulWidget {
  const DietGoalesScreen({super.key});

  @override
  State<DietGoalesScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<DietGoalesScreen> {
  final HomeController controller = Get.find<HomeController>();
  final MyRecipeController myRecipeController = Get.find<MyRecipeController>();
  final ScrollController _scrollController = ScrollController();
  String? roleString;

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
      if (roleString != null) {
        controller.getGaol(name: roleString!, loadMore: true);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (roleString == null) {
      roleString = GoRouterState.of(context).extra as String?;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await controller.getGaol(name: roleString ?? "");

        final resultList = controller.getGoalData.value.result ?? [];

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
        appBarContent: roleString
                ?.replaceAll('_', ' ') // maintain weight
                .split(' ') // [maintain, weight]
                .map((word) => word[0].toUpperCase() + word.substring(1))
                .join(' ') ??
            "Category",
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
                return const Center(child: Text("Error loading category data"));
              } else if (status == Status.internetError) {
                return const Center(child: Text("No internet connection"));
              }

              final resultList = controller.getGoalData.value.result;
              if (resultList == null || resultList.isEmpty) {
                return const Center(child: Text("No data found"));
              }

              return ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16.r),
                itemCount:
                    resultList.length + (controller.goalHasMoreData ? 1 : 0),
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
                            "isExist": true,
                            // "planName": planName ?? "",
                            // "planId": planId ?? "",
                            // "day": day ?? "",
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
