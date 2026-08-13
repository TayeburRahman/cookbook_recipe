import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/common_filter_box/common_filter_box.dart';
import 'package:recipe_app/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/screens/meal_plan/controller/meal_plan_controller.dart';
import 'package:recipe_app/app/view/screens/profile_screen/my_recipe/recipe_details/controller/recipe_details_controller.dart';
import 'package:recipe_app/app/view/screens/profile_screen/my_recipe/controller/my_recipe_controller.dart';
import 'package:recipe_app/app/utils/enums/status.dart';
import '../../../../common_widgets/custom_button/custom_button.dart';
import '../../../../common_widgets/review_tile/review_title.dart';
import 'inner_widgets/ingredient_section.dart';

class RecipeDetails extends StatefulWidget {
  const RecipeDetails({super.key});

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  final RecipeDetailsController controller =
      Get.find<RecipeDetailsController>();
  final MealPlanController mealPlanController = Get.find<MealPlanController>();
  final MyRecipeController myRecipeController =
      Get.find<MyRecipeController>();

  String? id;
  bool _isInitialized = false;

  bool isExist = false;
  String? planName;
  String? planId;
  String? day;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final extra = GoRouterState.of(context).extra;
      if (extra is Map<String, dynamic>) {
        id = extra['id'] as String?;
        isExist = extra['isExist'] ?? false;
        planName = extra['planName'] as String?;
        planId = extra['planId'] as String?;
        day = extra['day'] as String?;

        if (id != null && id!.isNotEmpty) {
          controller.detailsRecipe(id: id!);
          controller.getReview(id: id!);
        }

        debugPrint("Id======================$id");
        debugPrint("isExist=================$isExist");
        debugPrint("planName==================$planName");
        debugPrint("planID==================$planId");
        debugPrint("day=====================$day");

        if (id != null && id!.isNotEmpty) {
          myRecipeController.initFavorite(id!, isExist);
        }
        _isInitialized = true;
      } else {
        debugPrint("❌ Invalid or missing 'id' in route extras.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() {
        final status = controller.rxRequestStatus.value;
        final data = controller.detailsData.value;

        if (status == Status.loading || (id != null && data.id != id)) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        }

        if (status == Status.error || status == Status.internetError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: status == Status.internetError
                      ? "No Internet Connection"
                      : "Failed to load recipe details",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 12.h),
                ElevatedButton(
                  onPressed: () {
                    if (id != null && id!.isNotEmpty) {
                      controller.detailsRecipe(id: id!);
                      controller.getReview(id: id!);
                    }
                  },
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        if (data.image == null) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            /// ============================ Sliver App Bar ===============================
            SliverAppBar(
              surfaceTintColor: Colors.transparent,
              expandedHeight: 300.h,
              pinned: true,
              backgroundColor: AppColors.white,
              leading: IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.arrow_back, color: Colors.black),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                Obx(() {
                  final isFav =
                      myRecipeController.favorites[id]?.value ?? isExist;
                  return GestureDetector(
                    onTap: () {
                      if (id != null) {
                        myRecipeController.favoriteAdd(id!);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 16.w),
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isFav ? const Color(0xFFFFEBEE) : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? const Color(0xFFE53935) : const Color(0xFF334155),
                        size: 22.r,
                      ),
                    ),
                  );
                }),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomNetworkImage(
                      imageUrl: data.image ?? "",
                      height: 300.h,
                      width: double.infinity,
                    ),
                    // Gradient overlay for better text contrast
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.4),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.2),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// ============================ Title & Summary Bar ===============================
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Wrap(
                            spacing: 6.w,
                            runSpacing: 6.h,
                            alignment: WrapAlignment.spaceBetween,
                            children: (data.category ?? [])
                                .map((cat) => Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.green
                                            .withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                        border: Border.all(
                                            color: AppColors.green
                                                .withValues(alpha: 0.2)),
                                      ),
                                      child: CustomText(
                                        text: cat
                                                .replaceAll('-', ' ')
                                                .replaceAll('_', ' ')
                                                .capitalizeFirst ??
                                            cat,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11.sp,
                                        color: AppColors.green,
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),
                    CustomText(
                      text: (data.name ?? "")
                              .replaceAll('-', ' ')
                              .replaceAll('_', ' ')
                              .capitalize ??
                          "",
                      fontWeight: FontWeight.w600,
                      fontSize: 22.sp,
                      color: AppColors.black,
                      textAlign: TextAlign.start,
                      maxLines: 100,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 24.sp),
                        SizedBox(width: 8.w),
                        CustomText(
                          text: data.ratting?.toStringAsFixed(1) ?? "0.0",
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                          color: AppColors.black200,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    /// ============= Nutritional Chips =============
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildNutrientChip(
                            AppStrings.calories.tr,
                            data.nutritional?.calories?.toString() ?? "0",
                            Icons.local_fire_department_outlined,
                            Colors.orange,
                          ),
                          _buildNutrientChip(
                            AppStrings.protein.tr,
                            data.nutritional?.protein?.toString() ?? "0g",
                            Icons.fitness_center_outlined,
                            Colors.blue,
                          ),
                          _buildNutrientChip(
                            AppStrings.fat.tr,
                            data.nutritional?.fat?.toString() ?? "0g",
                            Icons.opacity_outlined,
                            Colors.red,
                          ),
                          _buildNutrientChip(
                            AppStrings.carbs.tr,
                            data.nutritional?.carbs?.toString() ?? "0g",
                            Icons.bakery_dining_outlined,
                            Colors.amber,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    /// ============= Add to Plan Button =============
                    GestureDetector(
                      onTap: () => _showAddToPlanDialog(),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.green.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8.w),
                            CustomText(
                              text: AppStrings.addToPlan.tr,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    /// =============== Ingredients Section ================
                    _buildSectionHeader(
                      AppStrings.ingredients.tr,
                      Icons.shopping_basket_outlined,
                    ),
                    IngredientSection(list: data.ingredients),
                    SizedBox(height: 20.h),

                    ///=================== Instructions Section ================
                    _buildSectionHeader(
                      AppStrings.instructions.tr,
                      Icons.menu_book_outlined,
                    ),
                    IngredientSection(list: data.instructions),
                    SizedBox(height: 20.h),

                    /// ========================= Recipe Attributes ==================
                    _buildSectionHeader(
                      "Recipe Details",
                      Icons.info_outline,
                    ),
                    _buildAttributeRow(
                        AppStrings.oils.tr, data.oils.toString()),
                    _buildAttributeRow(AppStrings.servingTemperature.tr,
                        data.servingTemperature.toString()),
                    _buildAttributeRow(
                        AppStrings.flavor.tr, data.flavor.toString()),
                    _buildAttributeRow(AppStrings.weightLossVs.tr,
                        data.weightAndMuscle.toString()),
                    _buildAttributeRow(AppStrings.wholeFoodType.tr,
                        data.wholeFoodType.toString()),
                    _buildAttributeRow(AppStrings.prepTime.tr,
                        "${data.prepTime.toString()} min"),
                    _buildAttributeRow(AppStrings.holidayRecipe.tr,
                        data.holidayRecipes.toString()),
                    SizedBox(height: 20.h),

                    /// ========================= Recipe Tips ==================
                    _buildSectionHeader(
                      AppStrings.recipeTips.tr,
                      Icons.lightbulb_outline,
                    ),
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.green.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (data.recipeTips ?? [])
                            .where((tip) => tip.trim().isNotEmpty)
                            .map((tip) => Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 4.h, right: 12.w),
                                        padding: EdgeInsets.all(4.r),
                                        decoration: const BoxDecoration(
                                          color: AppColors.green,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.check,
                                            color: Colors.white, size: 10.sp),
                                      ),
                                      Expanded(
                                        child: CustomText(
                                          textAlign: TextAlign.start,
                                          text: tip,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.sp,
                                          color: AppColors.black300,
                                          maxLines: 100,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 30.h),

                    /// ========================= Tabs Section ==================
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TabBar(
                            labelColor: AppColors.green,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: AppColors.green,
                            indicatorWeight: 3,
                            labelStyle: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            tabs: [
                              Tab(text: AppStrings.review.tr),
                              Tab(text: AppStrings.satietyScore.tr),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          SizedBox(
                            height: 600.h,
                            child: TabBarView(
                              children: [
                                _buildReviewTab(),
                                _buildScoreTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50.h),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Icon(icon, color: AppColors.green, size: 22.sp),
          SizedBox(width: 8.w),
          CustomText(
            text: title,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
            color: AppColors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientChip(
      String label, String value, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: AppColors.bg500),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(height: 8.h),
          CustomText(
            text: value,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: AppColors.black,
          ),
          CustomText(
            text: label,
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: AppColors.black200,
          ),
        ],
      ),
    );
  }

  Widget _buildAttributeRow(String label, String value) {
    if (value == "null" || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: CustomText(
              text: label,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: AppColors.black200,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),
          CustomText(
            text: value.toString().replaceAll('-', ' ').replaceAll('_', ' '),
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            color: AppColors.black300,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewTab() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          ...List.generate(
            controller.reviewList.length,
            (index) {
              final data = controller.reviewList[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: ReviewTile(
                  imageUrl: data.userId?.profileImage ?? "",
                  userName: data.userId?.name ?? "",
                  timeAgo: data.feedback ?? "",
                  starCount: data.ratting ?? 0,
                ),
              );
            },
          ),
          SizedBox(height: 24.h),
          CustomButton(
            onTap: () {
              CommonFilterBox.reviewDialog(context, id ?? "");
            },
            title: AppStrings.addReview.tr,
            fillColor: AppColors.white,
            borderColor: AppColors.green900,
            textColor: AppColors.green900,
          ),
        ],
      ),
    );
  }

  Widget _buildScoreTab() {
    final scoreList = controller.detailsData.value.scoreReview;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          if (scoreList != null && scoreList.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: scoreList.length,
              itemBuilder: (context, index) {
                final score = scoreList[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    children: [
                      CustomNetworkImage(
                        imageUrl: score.userId?.profileImage ?? '',
                        height: 50.w,
                        width: 50.w,
                        boxShape: BoxShape.circle,
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: score.userId?.name ?? "No name",
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: AppColors.black,
                          ),
                          Row(
                            children: [
                              Icon(Icons.star,
                                  color: Colors.amber, size: 16.sp),
                              SizedBox(width: 4.w),
                              CustomText(
                                text: score.ratting?.toString() ?? "0",
                                fontWeight: FontWeight.w400,
                                fontSize: 13.sp,
                                color: AppColors.black,
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            )
          else
            Padding(
              padding: EdgeInsets.all(20.r),
              child: CustomText(
                text: AppStrings.noScoreRatingAvailable.tr,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          SizedBox(height: 24.h),
          CustomButton(
            onTap: () {
              CommonFilterBox.score(context, id ?? "");
            },
            title: AppStrings.addScore.tr,
            fillColor: AppColors.white,
            borderColor: AppColors.green900,
            textColor: AppColors.green900,
          ),
        ],
      ),
    );
  }

  /// Shows a dialog to pick a plan (Weekly or Custom) then a day.
  Future<void> _showAddToPlanDialog() async {
    // Ensure both lists are loaded
    if (mealPlanController.weeklyPlanData.value.plans == null ||
        mealPlanController.weeklyPlanData.value.plans!.isEmpty) {
      await mealPlanController.getWeeklyPlan();
    }
    if (mealPlanController.customPlanList.isEmpty) {
      await mealPlanController.getCustomPlan();
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => _AddToPlanDialog(
        recipeId: id ?? "",
        mealPlanController: mealPlanController,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Add-to-Plan Dialog  (Weekly | Custom tabs)
// ─────────────────────────────────────────────────────────────────────────────

class _AddToPlanDialog extends StatefulWidget {
  final String recipeId;
  final MealPlanController mealPlanController;

  const _AddToPlanDialog({
    required this.recipeId,
    required this.mealPlanController,
  });

  @override
  State<_AddToPlanDialog> createState() => _AddToPlanDialogState();
}

class _AddToPlanDialogState extends State<_AddToPlanDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Shared state: selected plan id & name, and selected day
  String? _selectedPlanId;
  String? _selectedPlanName;
  // null  → showing plan list
  // set   → showing day picker for that plan

  bool _showDayPicker = false;

  final List<String> _days = [
    'Day-1',
    'Day-2',
    'Day-3',
    'Day-4',
    'Day-5',
    'Day-6',
    'Day-7',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Reset plan selection when tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _showDayPicker = false;
          _selectedPlanId = null;
          _selectedPlanName = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onPlanTapped(String planId, String planName) {
    setState(() {
      _selectedPlanId = planId;
      _selectedPlanName = planName;
      _showDayPicker = true;
    });
  }

  void _onBackTapped() {
    setState(() {
      _showDayPicker = false;
      _selectedPlanId = null;
      _selectedPlanName = null;
    });
  }

  Future<void> _onDayTapped(BuildContext ctx, String day) async {
    Navigator.of(ctx).pop(); // close dialog first
    try {
      await widget.mealPlanController.addRecipe(
        planId: _selectedPlanId ?? '',
        recipeId: widget.recipeId,
        day: day,
      );
    } catch (e) {
      log('Error adding recipe to plan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      child: Obx(() {
        final isLoading = widget.mealPlanController.isAddLoading.value;
        return Stack(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 0.75.sh),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Header ──────────────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 16.h, 8.w, 0),
                    child: Row(
                      children: [
                        if (_showDayPicker)
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: AppColors.black),
                            onPressed: _onBackTapped,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        if (_showDayPicker) SizedBox(width: 8.w),
                        Expanded(
                          child: CustomText(
                            text: _showDayPicker
                                ? 'Select Day – $_selectedPlanName'
                                : 'Add to Plan',
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.black),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),

                  // ── TabBar (hidden when showing day picker) ────────────
                  if (!_showDayPicker)
                    TabBar(
                      controller: _tabController,
                      labelColor: AppColors.green,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: AppColors.green,
                      tabs: const [
                        Tab(text: 'Weekly'),
                        Tab(text: 'Custom'),
                      ],
                    ),

                  Divider(height: 1, color: Colors.grey[200]),

                  // ── Body ────────────────────────────────────────────────
                  Flexible(
                    child: _showDayPicker
                        ? _buildDayList(context)
                        : TabBarView(
                            controller: _tabController,
                            children: [
                              _buildWeeklyPlanList(),
                              _buildCustomPlanList(),
                            ],
                          ),
                  ),
                ],
              ),
            ),

            // ── Loading overlay ──────────────────────────────────────────
            if (isLoading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  // ── Weekly plan list ────────────────────────────────────────────────────────
  Widget _buildWeeklyPlanList() {
    final plans = widget.mealPlanController.weeklyPlanData.value.plans ?? [];
    if (plans.isEmpty) {
      return _emptyState('No weekly plans found.');
    }
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: plans.length,
      separatorBuilder: (_, __) => Divider(color: Colors.grey[200], height: 1),
      itemBuilder: (_, index) {
        final plan = plans[index];
        return _planTile(
          name: plan.weekName ?? 'Unnamed Plan',
          onTap: () => _onPlanTapped(plan.id ?? '', plan.weekName ?? ''),
        );
      },
    );
  }

  // ── Custom plan list ────────────────────────────────────────────────────────
  Widget _buildCustomPlanList() {
    final plans = widget.mealPlanController.customPlanList;
    if (plans.isEmpty) {
      return _emptyState('No custom plans found.');
    }
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: plans.length,
      separatorBuilder: (_, __) => Divider(color: Colors.grey[200], height: 1),
      itemBuilder: (_, index) {
        final plan = plans[index];
        return _planTile(
          name: plan.name ?? 'Unnamed Plan',
          onTap: () => _onPlanTapped(plan.id ?? '', plan.name ?? ''),
        );
      },
    );
  }

  // ── Day list ────────────────────────────────────────────────────────────────
  Widget _buildDayList(BuildContext ctx) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: _days.length,
      separatorBuilder: (_, __) => Divider(color: Colors.grey[200], height: 1),
      itemBuilder: (_, index) {
        final day = _days[index];
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
          title: CustomText(
            text: day,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.start,
            color: AppColors.black,
          ),
          trailing:
              const Icon(Icons.add_circle_outline, color: AppColors.green),
          onTap: () => _onDayTapped(ctx, day),
        );
      },
    );
  }

  // ── Shared plan tile ────────────────────────────────────────────────────────
  Widget _planTile({required String name, required VoidCallback onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      title: CustomText(
        text: name,
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
        textAlign: TextAlign.start,
        color: AppColors.black,
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey),
      onTap: onTap,
    );
  }

  // ── Empty state ─────────────────────────────────────────────────────────────
  Widget _emptyState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: CustomText(
          text: message,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
