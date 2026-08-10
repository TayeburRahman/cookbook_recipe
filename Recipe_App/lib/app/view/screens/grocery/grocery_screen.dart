import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/models/grocery_advice_model/grocery_advice_model.dart';
import 'package:recipe_app/app/models/grocery_model/grocery_model.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/common_filter_box/common_filter_box.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_nav_bar/custom_nav_bar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/screens/grocery/controller/grocery_controller.dart';
import 'package:recipe_app/app/view/screens/meal_plan/controller/meal_plan_controller.dart';
import 'package:recipe_app/app/utils/custom_assets/assets.gen.dart';
import '../../../global/helper/string_converter/string_converter.dart';
import 'package:recipe_app/app/core/route_path.dart';
import '../../../utils/enums/status.dart';
import '../../common_widgets/tab_selector/tab_selector.dart';
import '../profile_screen/my_recipe/controller/my_recipe_controller.dart';
import 'inner_widgets/weekly_box.dart';
import 'package:recipe_app/app/global/helper/show_custom_snackbar/show_custom_snackbar.dart';

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  int selectedIndex = -1;
  int selectedTabIndex = 0;

  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = "".obs;
  final RxList<GroceryItem> customItems = <GroceryItem>[].obs;

  final MealPlanController controller = Get.find<MealPlanController>();
  final GroceryController groceryController = Get.find<GroceryController>();
  final MyRecipeController myRecipeController = Get.find<MyRecipeController>();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeDefaultPlan();
    });
  }

  Future<void> _initializeDefaultPlan() async {
    if (controller.selectedPlan != null) {
      setState(() {
        selectedIndex = 0;
      });
      groceryController.getWeeklyGrocery(id: controller.selectedPlan!.id ?? "");
      groceryController.getGroceryListAdvice(id: controller.selectedPlan!.id ?? "");
      return;
    }

    await controller.getWeeklyPlan();
    final plans = controller.weeklyPlanData.value.plans;
    if (plans != null && plans.isNotEmpty) {
      final defaultPlan = plans.first;
      setState(() {
        selectedIndex = 0;
        controller.selectedPlan = defaultPlan;
      });
      groceryController.getWeeklyGrocery(id: defaultPlan.id ?? "");
      groceryController.getGroceryListAdvice(id: defaultPlan.id ?? "");
    } else {
      _showWeeklyBoxDialog();
    }
  }

  void _showWeeklyBoxDialog() {
    GroceryDialog.weeklyBox(context, (plan) {
      setState(() {
        selectedIndex = 0;
        controller.selectedPlan = plan;
      });
      groceryController.getWeeklyGrocery(id: plan.id ?? "");
      groceryController.getGroceryListAdvice(id: plan.id ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: const CustomNavBar(currentIndex: 2),
      appBar: CustomAppBar(appBarContent: AppStrings.grocery.tr.toUpperCase()),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTabSelector(),
              SizedBox(height: 20.h),
              SizedBox(width: double.infinity, child: _buildTabContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTab(AppStrings.weekly.tr, 0, _showWeeklyBoxDialog,
              isWeekly: true),
          _buildTab(AppStrings.custom.tr, 1, _showCustomDialog, isSelect: true),
          _buildTab(AppStrings.featured.tr, 2, _showFeaturedDialog,
              isSelect: true),
        ],
      ),
    );
  }

  //===================3 tab title===========
  Widget _buildTab(String title, int index, VoidCallback onTap,
      {bool isWeekly = false, bool isSelect = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        onTap();
      },
      child: Row(
        children: [
          if (isWeekly)
            Assets.icons.calender.svg(
              colorFilter: ColorFilter.mode(
                selectedIndex == index ? AppColors.green : AppColors.black500,
                BlendMode.srcIn,
              ),
            ),
          CustomText(
            left: isWeekly ? 4 : 0,
            text: title.toUpperCase(),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color:
                selectedIndex == index ? AppColors.green : AppColors.black500,
          ),
          if (isWeekly || isSelect)
            Icon(
              Icons.arrow_drop_down,
              size: 20.sp,
              color:
                  selectedIndex == index ? AppColors.green : AppColors.black500,
            ),
          SizedBox(width: 8.w),
        ],
      ),
    );
  }

  //==============Custom Dialog============
  void _showCustomDialog() {
    GroceryDialog.showCustomDialog(context, (customPlanList) {
      setState(() {
        selectedIndex = 1;
        controller.selectedCustomPlanList = customPlanList;
      });
      groceryController.getWeeklyGrocery(id: customPlanList.id ?? '');
      groceryController.getGroceryListAdvice(id: customPlanList.id ?? '');
    });
  }

  //==============Feature Dialog============
  void _showFeaturedDialog() {
    CommonFilterBox.featureBox(context, (selectedPlan) {
      setState(() {
        selectedIndex = 2;
        controller.selectedFeaturePlanList = selectedPlan;
      });
      groceryController.getWeeklyGrocery(id: selectedPlan.id ?? '');
      groceryController.getGroceryListAdvice(id: selectedPlan.id ?? '');
    });
  }

  //==============3 tab===========
  Widget _buildTabContent() {
    switch (selectedIndex) {
      case 0:
        return _buildWeeklyContent();
      case 1:
        return _buildCustomContent();
      case 2:
        return _buildFeaturedContent();
      default:
        return const SizedBox();
    }
  }

  Widget _buildWeeklyContent() {
    return Obx(() {
      final status = groceryController.rxRequestStatus.value;
      final weeklyMealPlan = groceryController.groceryData.value;

      if (status == Status.loading) {
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.black,
        ));
      } else if (status == Status.error) {
        return Center(child: Text(AppStrings.failedToLoadWeeklyMealPlan.tr));
      } else if (status == Status.internetError) {
        return Center(child: Text(AppStrings.noInternetFound.tr));
      }

      if (weeklyMealPlan.data == null || weeklyMealPlan.data!.isEmpty) {
        return Center(
            child: Text(
          AppStrings.noMealPlanDataAvailable.tr,
          style: const TextStyle(color: AppColors.black),
        ));
      }

      return _buildMealPlanContent(weeklyMealPlan, isWeekly: true);
    });
  }

  Widget _buildCustomContent() {
    return Obx(() {
      final status = groceryController.rxRequestStatus.value;
      final weeklyMealPlan = groceryController.groceryData.value;

      if (status == Status.loading) {
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.black,
        ));
      } else if (status == Status.error) {
        return Center(child: Text(AppStrings.failedToLoadWeeklyMealPlan.tr));
      } else if (status == Status.internetError) {
        return Center(child: Text(AppStrings.noInternetFound.tr));
      }

      if (weeklyMealPlan.data == null || weeklyMealPlan.data!.isEmpty) {
        return Center(
            child: Text(
          AppStrings.noMealPlanDataAvailable.tr,
          style: const TextStyle(color: AppColors.black),
        ));
      }

      return _buildMealPlanContent(weeklyMealPlan, isCustom: true);
    });
  }

  Widget _buildFeaturedContent() {
    return Obx(() {
      final status = groceryController.rxRequestStatus.value;
      final weeklyMealPlan = groceryController.groceryData.value;

      if (status == Status.loading) {
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.black,
        ));
      } else if (status == Status.error) {
        return Center(child: Text(AppStrings.failedToLoadWeeklyMealPlan.tr));
      } else if (status == Status.internetError) {
        return Center(child: Text(AppStrings.noInternetFound.tr));
      }

      if (weeklyMealPlan.data == null || weeklyMealPlan.data!.isEmpty) {
        return Center(
            child: Text(
          AppStrings.noMealPlanDataAvailable.tr,
          style: const TextStyle(color: AppColors.black),
        ));
      }

      return _buildMealPlanContent(weeklyMealPlan, isFeatured: true);
    });
  }

  Widget _buildMealPlanContent(weeklyMealPlan,
      {bool isCustom = false, bool isFeatured = false, bool isWeekly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabSelector(
          selectedIndex: selectedTabIndex,
          onTabSelected: (index) {
            setState(() {
              selectedTabIndex = index;
            });
          },
        ),
        SizedBox(height: 12.h),
        _buildAddItemInputField(),
        SizedBox(height: 12.h),
        if (isWeekly && controller.selectedPlan != null)
          _buildSelectedPlanText(controller.selectedPlan?.weekName ?? ""),
        if (isCustom && controller.selectedCustomPlanList != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSelectedPlanText(controller.selectedCustomPlanList?.name),
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: GestureDetector(
                  onTap: () {
                    context.pushNamed(RoutePath.groceryPreview, extra: {
                      'plan': controller.selectedCustomPlanList,
                      'meals': weeklyMealPlan.data,
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.print, color: Colors.white, size: 16),
                        SizedBox(width: 4.w),
                        CustomText(
                          text: "Print Grocery Plan".toUpperCase(),
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        if (isFeatured && controller.selectedFeaturePlanList != null)
          _buildSelectedPlanText(formatPlanName(
              controller.selectedFeaturePlanList?.name ?? "Custom Plan")),
        selectedTabIndex == 0
            ? _buildAisleList()
            : _buildRecipesList(weeklyMealPlan),
      ],
    );
  }

  Widget _buildAddItemInputField() {
    return Container(
      width: double.infinity,
      height: 46.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _addCustomItem,
            child: Icon(Icons.add_circle_outline_rounded,
                color: const Color(0xFF00A896), size: 22.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: (val) {
                searchQuery.value = val.trim();
              },
              onSubmitted: (_) {
                _addCustomItem();
              },
              decoration: InputDecoration(
                hintText: "Type to search or add your own items...",
                hintStyle: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Obx(() {
            if (searchQuery.value.isNotEmpty) {
              return GestureDetector(
                onTap: () {
                  searchController.clear();
                  searchQuery.value = "";
                },
                child: Icon(Icons.close_rounded,
                    color: const Color(0xFF94A3B8), size: 18.sp),
              );
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }

  void _addCustomItem() {
    final text = searchController.text.trim();
    if (text.isEmpty) return;

    customItems.insert(
      0,
      GroceryItem(
        name: text,
        amountToPurchase: "1",
        isPurchased: false,
      ),
    );

    searchController.clear();
    searchQuery.value = "";
    toastMessage(message: "'$text' added to your grocery list!");
  }

  Widget _buildSelectedPlanText(String? planName) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, top: 4.h),
      child: CustomText(
        textAlign: TextAlign.start,
        maxLines: 5,
        text: planName ?? AppStrings.selectedWeek.tr,
        fontSize: 17.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF0F172A),
      ),
    );
  }

  // ============== By Aisle view ==============
  Widget _buildAisleList() {
    return Obx(() {
      final status = groceryController.rxAdviceStatus.value;
      final adviceData = groceryController.groceryAdviceData.value;

      if (status == Status.loading) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF00A896)),
        );
      } else if (status == Status.error) {
        return Center(child: Text(AppStrings.failedToLoadWeeklyMealPlan.tr));
      } else if (status == Status.internetError) {
        return Center(child: Text(AppStrings.noInternetFound.tr));
      }

      if (adviceData == null) {
        return Center(
          child: CustomText(
            top: 20.h,
            textAlign: TextAlign.center,
            text: AppStrings.noIngredientsAvailable.tr,
            fontSize: 18.sp,
            color: AppColors.black,
          ),
        );
      }

      if ((adviceData.completeGroceryList != null &&
              adviceData.completeGroceryList!.isNotEmpty) ||
          customItems.isNotEmpty) {
        return _buildConsolidatedAisleContent(adviceData);
      }

      if (adviceData.days != null && adviceData.days!.isNotEmpty) {
        return _buildDayWiseContent(adviceData);
      }

      return Center(
        child: CustomText(
          top: 20.h,
          textAlign: TextAlign.center,
          text: AppStrings.noIngredientsAvailable.tr,
          fontSize: 18.sp,
          color: AppColors.black,
        ),
      );
    });
  }

  Widget _buildConsolidatedAisleContent(GroceryAdviceData adviceData) {
    final departments = adviceData.completeGroceryList ?? [];

    return Obx(() {
      final query = searchQuery.value.toLowerCase();

      // Collect all visible items across custom & department lists
      final allCustom = customItems.toList();
      final allDeptItems = departments
          .expand((d) => d.items ?? <GroceryItem>[])
          .toList();
      final allItems = [...allCustom, ...allDeptItems];

      final totalCount = allItems.length;
      final completedCount =
          allItems.where((item) => item.isPurchased.value).length;
      final progressRatio =
          totalCount > 0 ? (completedCount / totalCount) : 0.0;

      // Filter custom items
      final filteredCustom = customItems.where((item) {
        if (query.isEmpty) return true;
        return (item.name ?? "").toLowerCase().contains(query);
      }).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Progress Card
          if (totalCount > 0 && query.isEmpty)
            Container(
              margin: EdgeInsets.only(bottom: 14.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00A896), Color(0xFF028090)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00A896).withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "GROCERY PROGRESS",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withValues(alpha: 0.9),
                          letterSpacing: 0.8,
                        ),
                      ),
                      Text(
                        "$completedCount / $totalCount Items",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.r),
                    child: LinearProgressIndicator(
                      value: progressRatio,
                      minHeight: 7.h,
                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
            ),

          // Render Custom Items Department if present
          if (filteredCustom.isNotEmpty)
            _buildDepartmentCard("MY CUSTOM ITEMS", filteredCustom),

          ...departments.map<Widget>((dept) {
            if (dept.items == null || dept.items!.isEmpty) {
              return const SizedBox();
            }

            final matchingItems = dept.items!.where((item) {
              if (query.isEmpty) return true;
              final name = (item.name ?? "").toLowerCase();
              final amt = (item.amountToPurchase ?? "").toLowerCase();
              return name.contains(query) || amt.contains(query);
            }).toList();

            if (matchingItems.isEmpty) {
              return const SizedBox();
            }

            return _buildDepartmentCard(
                dept.department ?? "GROCERY", matchingItems);
          }).toList(),
        ],
      );
    });
  }

  Widget _buildDepartmentCard(String departmentName, List<GroceryItem> items) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Aisle Header Banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(9.r),
                topRight: Radius.circular(9.r),
              ),
              border: const Border(
                left: BorderSide(color: Color(0xFF00A896), width: 4),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  textAlign: TextAlign.start,
                  text: departmentName.toUpperCase(),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
                Obx(() {
                  final purchasedCount =
                      items.where((item) => item.isPurchased.value).length;
                  if (purchasedCount == 0) return const SizedBox();
                  return Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00A896).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_rounded,
                            size: 12.sp, color: const Color(0xFF00A896)),
                        SizedBox(width: 4.w),
                        CustomText(
                          text:
                              "$purchasedCount of ${items.length} purchased",
                          fontSize: 11.sp,
                          color: const Color(0xFF00A896),
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          // Items in this department
          ...items.map<Widget>((item) {
            return InkWell(
              onTap: () {
                item.isPurchased.value = !item.isPurchased.value;
                _syncPurchasedStateToRecipes(item);
                if (controller.selectedPlan?.id != null) {
                  groceryController.toggleAisleItem(
                    planId: controller.selectedPlan!.id!,
                    itemName: item.name ?? "",
                    isPurchased: item.isPurchased.value,
                  );
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                child: Row(
                  children: [
                    // Checkbox
                    Obx(() {
                      final isDone = item.isPurchased.value;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 22.w,
                        height: 22.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDone
                              ? const Color(0xFF00A896)
                              : Colors.transparent,
                          border: Border.all(
                            color: isDone
                                ? const Color(0xFF00A896)
                                : const Color(0xFFCBD5E1),
                            width: 1.8,
                          ),
                        ),
                        child: isDone
                            ? Icon(Icons.check_rounded,
                                size: 14.sp, color: Colors.white)
                            : null,
                      );
                    }),
                    SizedBox(width: 12.w),
                    // Item Name & Amount
                    Expanded(
                      child: Obx(() {
                        final isDone = item.isPurchased.value;
                        final text =
                            "${item.amountToPurchase ?? ''} ${item.name ?? ''}"
                                .trim();
                        return Text(
                          text,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight:
                                isDone ? FontWeight.w400 : FontWeight.w500,
                            color: isDone
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF0F172A),
                            decoration: isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationColor: const Color(0xFF94A3B8),
                          ),
                        );
                      }),
                    ),
                    // Options menu
                    Icon(Icons.more_horiz_rounded,
                        color: const Color(0xFF94A3B8), size: 20.sp),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildDayWiseContent(GroceryAdviceData adviceData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: adviceData.days!.map<Widget>((adviceDay) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Day header ──────────────────────────────────────
            Padding(
              padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
              child: Row(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: CustomText(
                        text: "${adviceDay.day ?? ""}",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  CustomText(
                    text: "Day ${adviceDay.day ?? ""}",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff1B3B4A),
                  ),
                ],
              ),
            ),

            // ── Meal cards for this day ──────────────────────────
            ...(adviceDay.meals ?? []).map<Widget>((meal) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      tilePadding:
                          EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                      childrenPadding:
                          EdgeInsets.symmetric(horizontal: 14.w, vertical: 0),
                      trailing: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.green,
                        size: 22.sp,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category chip
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: _mealCategoryColor(meal.category)
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: CustomText(
                              text: (meal.category ?? "").toUpperCase(),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: _mealCategoryColor(meal.category),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          // Recipe name
                          CustomText(
                            textAlign: TextAlign.start,
                            maxLines: 3,
                            text: meal.recipeName ?? "",
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff1B3B4A),
                          ),
                        ],
                      ),
                      children: [
                        // ── Ingredients ──────────────────────
                        if ((meal.ingredients ?? []).isNotEmpty) ...[
                          _buildSectionLabel(
                              "Ingredients", Icons.shopping_basket_outlined),
                          SizedBox(height: 6.h),
                          ...(meal.ingredients!).map<Widget>((ing) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 6.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 5.h),
                                    child: Icon(
                                      Icons.fiber_manual_record,
                                      size: 7.sp,
                                      color: AppColors.green,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: CustomText(
                                      textAlign: TextAlign.start,
                                      maxLines: 10,
                                      text: ing,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.black500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          SizedBox(height: 10.h),
                        ],

                        // ── Instructions ──────────────────────
                        if ((meal.instructions ?? []).isNotEmpty) ...[
                          _buildSectionLabel(
                              "Instructions", Icons.list_alt_outlined),
                          SizedBox(height: 6.h),
                          ...(meal.instructions!)
                              .asMap()
                              .entries
                              .map<Widget>((entry) {
                            final stepNum = entry.key + 1;
                            final step = entry.value;
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 20.w,
                                    height: 20.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: CustomText(
                                        text: "$stepNum",
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: CustomText(
                                      textAlign: TextAlign.start,
                                      maxLines: 10,
                                      text: step,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.black500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          SizedBox(height: 10.h),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSectionLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: AppColors.green),
        SizedBox(width: 6.w),
        CustomText(
          text: label,
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.green,
        ),
      ],
    );
  }

  Color _mealCategoryColor(String? category) {
    switch ((category ?? "").toLowerCase()) {
      case "breakfast":
        return const Color(0xFFE87C2A);
      case "lunch":
        return const Color(0xFF2A7CE8);
      case "dinner":
        return const Color(0xFF7C2AE8);
      default:
        return AppColors.green;
    }
  }

  void _syncPurchasedStateToRecipes(GroceryItem item) {
    final nameClean = (item.name ?? "").toLowerCase();
    if (nameClean.isEmpty) return;

    final weeklyMealPlan = groceryController.groceryData.value;
    if (weeklyMealPlan.data == null) return;

    for (var dayData in weeklyMealPlan.data!) {
      if (dayData.recipes == null) continue;
      for (var recipeElem in dayData.recipes!) {
        if (recipeElem.ingredients == null) continue;
        for (var ing in recipeElem.ingredients!) {
          final ingNameClean = (ing.ingredient ?? "").toLowerCase();
          if (ingNameClean.contains(nameClean) ||
              nameClean.contains(ingNameClean)) {
            ing.buy.value = item.isPurchased.value;
          }
        }
      }
    }
  }

  void _syncPurchasedStateToAisle(Ingredient ing) {
    final ingNameClean = (ing.ingredient ?? "").toLowerCase();
    if (ingNameClean.isEmpty) return;

    final adviceData = groceryController.groceryAdviceData.value;
    if (adviceData == null || adviceData.completeGroceryList == null) return;

    for (var dept in adviceData.completeGroceryList!) {
      if (dept.items == null) continue;
      for (var item in dept.items!) {
        final itemNameClean = (item.name ?? "").toLowerCase();
        if (itemNameClean.contains(ingNameClean) ||
            ingNameClean.contains(itemNameClean)) {
          item.isPurchased.value = ing.buy.value;
        }
      }
    }
  }

  Widget _buildRecipesList(weeklyMealPlan) {
    if (weeklyMealPlan.data == null || weeklyMealPlan.data!.isEmpty) {
      return Center(
        child: CustomText(
          top: 20.h,
          textAlign: TextAlign.center,
          text: AppStrings.noIngredientsAvailable.tr,
          fontSize: 18.sp,
          color: AppColors.black,
        ),
      );
    }

    return Column(
      children: weeklyMealPlan.data!.map<Widget>((dayData) {
        if (dayData.recipes == null || dayData.recipes!.isEmpty) {
          return const SizedBox();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: dayData.recipes!.map<Widget>((recipeElement) {
            return _buildRecipeCard(recipeElement);
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildRecipeCard(recipeElement) {
    if (recipeElement.recipe == null) {
      return const SizedBox();
    }

    final List<Ingredient> ingredients =
        List<Ingredient>.from(recipeElement.ingredients ?? []);
    if (ingredients.isEmpty) {
      return const SizedBox();
    }

    final query = searchQuery.value.toLowerCase();
    final matchingIngredients = ingredients.where((Ingredient ing) {
      if (query.isEmpty) return true;
      return (ing.ingredient ?? "").toLowerCase().contains(query);
    }).toList();

    if (matchingIngredients.isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipe header - image + name
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CustomNetworkImage(
                  imageUrl: "${recipeElement.recipe?.image ?? ""}",
                  height: 50.h,
                  width: 50.h,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomText(
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  text: recipeElement.recipe?.name ?? "",
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          SizedBox(height: 6.h),
          // All ingredients for this recipe
          ...matchingIngredients.map<Widget>((ingredient) {
            return _buildIngredientRow2(ingredient);
          }).toList(),
        ],
      ),
    );
  }

  //=============Ingredient for Recipe Tab=============
  Widget _buildIngredientRow2(ingredient) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: InkWell(
        onTap: () async {
          ingredient.buy.value = !ingredient.buy.value;
          _syncPurchasedStateToAisle(ingredient);
          groceryController.toggleIngredient(ingredientObj: ingredient);
        },
        child: Obx(() {
          final isDone = ingredient.buy.value;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 22.w,
                height: 22.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? const Color(0xFF00A896) : Colors.transparent,
                  border: Border.all(
                    color: isDone
                        ? const Color(0xFF00A896)
                        : const Color(0xFFCBD5E1),
                    width: 1.8,
                  ),
                ),
                child: isDone
                    ? Icon(Icons.check_rounded,
                        size: 14.sp, color: Colors.white)
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  ingredient.ingredient ?? "",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: isDone ? FontWeight.w400 : FontWeight.w500,
                    color: isDone
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF0F172A),
                    decoration: isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
