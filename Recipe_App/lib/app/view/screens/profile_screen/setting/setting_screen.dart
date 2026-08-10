import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/app/core/route_path.dart';
import 'package:recipe_app/app/core/routes.dart';
import 'package:recipe_app/app/global/helper/local_db/local_db.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_constants/app_constants.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/custom_assets/assets.gen.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_dialoge_alart/custom_dialoge_alart.dart';
import 'package:recipe_app/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:recipe_app/app/view/common_widgets/custom_menu_card/custom_menu_card.dart';
import 'package:recipe_app/app/view/screens/profile_screen/setting/controller/info_controller.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({
    super.key,
  });

  final InfoController controller = Get.find<InfoController>();

  // Update getId() to return the userId
  Future<String> getId() async {
    String userId = await SharePrefsHelper.getString(AppConstants.userId);
    debugPrint('Retrieved userId:=============== $userId');
    return userId;
  }

  @override
  Widget build(BuildContext context) {
    // Use Obx or other method to ensure that data is fetched before UI is displayed
    return Scaffold(
      backgroundColor: AppColors.white,

      ///============================ Header ===============================
      appBar: CustomAppBar(
        appBarBgColor: AppColors.white,
        appBarContent: AppStrings.settings.tr,
        iconData: Icons.arrow_back,
      ),

      ///============================ body ===============================
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //=====faqs====
            CustomMenuCard(
              onTap: () {
                AppRouter.route.pushNamed(
                  RoutePath.faqScreen,
                );
              },
              isContainerCard: true,
              text: AppStrings.faqs.tr,
              icon: Assets.icons.faqs.svg(color: AppColors.black),
            ),

            //===== termsAndConditions ====
            CustomMenuCard(
              onTap: () {
                AppRouter.route.pushNamed(
                  RoutePath.termsScreen,
                  // Pass as a Map
                );
              },
              isContainerCard: true,
              text: AppStrings.termsAndConditions.tr,
              icon: Assets.icons.terms.svg(),
            ),

            //===== privacy ====
            CustomMenuCard(
              onTap: () {
                AppRouter.route.pushNamed(
                  RoutePath.privacyPolicyScreen,
                  // This is fine as a bool map
                );
              },
              isContainerCard: true,
              text: AppStrings.privacyPolicy.tr,
              icon: Assets.icons.privacy.svg(),
            ),

            //=====changePassword====
            CustomMenuCard(
              onTap: () {
                AppRouter.route.pushNamed(
                  RoutePath.changePasswordScreen,
                );
              },
              isContainerCard: true,
              text: AppStrings.changePassword.tr,
              icon: Assets.icons.key.svg(),
            ),

            //=====deleteAccount====
            CustomMenuCard(
              onTap: () async {
                // Retrieve userId before showing the dialog
                String userId = await getId();
                CustomDialogAlert.showDeleteDialog(context, Obx(() {
                  return controller.isDeleteLoading.value
                      ? const CustomLoader()
                      : ElevatedButton(
                          onPressed: () {
                            controller.delete(id: userId);
                            context.pop();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: Text(
                            AppStrings.deleteAccount.tr,
                            style: const TextStyle(color: AppColors.white),
                          ),
                        );
                }), AppStrings.doYouWantToDeleteProfile);
              },
              isArrow: true,
              isContainerCard: true,
              text: AppStrings.deleteAccount.tr,
              icon: Assets.icons.delete.svg(),
            ),
          ],
        ),
      ),
    );
  }
}
