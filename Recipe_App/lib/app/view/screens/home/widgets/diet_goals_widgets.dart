import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/core/route_path.dart' show RoutePath;
import 'package:recipe_app/app/core/routes.dart' show AppRouter;
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart'
    show AppStrings;
import 'package:recipe_app/app/view/common_widgets/custom_diet_card/custom_diet_card.dart'
    show CustomDietCard;

class DietGoals extends StatelessWidget {
  const DietGoals({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                AppRouter.route.pushNamed(RoutePath.dietGoalesScreen,
                    extra: "weight_loss");
              },
              child: CustomDietCard(
                title: AppStrings.weightLose.tr,
                icon: "assets/images/loss.png",
                color: AppColors.white,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: GestureDetector(
              onTap: () {
                AppRouter.route.pushNamed(RoutePath.dietGoalesScreen,
                    extra: "muscle_gain");
              },
              child: CustomDietCard(
                title: AppStrings.muscleGain.tr,
                icon: "assets/images/muscle.png",
                color: AppColors.white,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: GestureDetector(
              onTap: () {
                AppRouter.route.pushNamed(RoutePath.dietGoalesScreen,
                    extra: "maintain_weight");
              },
              child: CustomDietCard(
                title: AppStrings.maintainWeight.tr,
                icon: "assets/images/mantain.png",
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
