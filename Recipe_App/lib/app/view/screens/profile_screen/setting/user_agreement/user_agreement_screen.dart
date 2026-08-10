import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/common_widgets/genarel_error_screen/genarel_error_screen.dart';
import 'package:recipe_app/app/view/common_widgets/no_internet_screen/no_internet_screen.dart';
import 'package:recipe_app/app/view/screens/profile_screen/setting/controller/info_controller.dart';
import '../../../../../utils/enums/status.dart';

class UserAgreementScreen extends StatelessWidget {
  UserAgreementScreen({super.key});

  final InfoController controller = Get.find<InfoController>();

  @override
  Widget build(BuildContext context) {
    final extraData = GoRouter.of(context).state.extra;

    if (extraData is Map<String, bool>) {
      final isTermsValue = extraData['isTerms'] ?? false;
      return Scaffold(
          backgroundColor: AppColors.white,
          appBar: CustomAppBar(
            appBarBgColor: AppColors.white,
            appBarContent: isTermsValue ? "True" : AppStrings.privacyPolicy.tr,
            iconData: Icons.arrow_back,
          ),
          body: Obx(() {
            switch (controller.rxRequestStatus.value) {
              case Status.loading:
                return const CustomLoader();
              case Status.internetError:
                return NoInternetScreen(onTap: () {
                  controller.getTerms();
                });
              case Status.error:
                return GeneralErrorScreen(
                  onTap: () {
                    controller.getTerms();
                  },
                );
              case Status.completed:
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: CustomText(
                    textAlign: TextAlign.start,
                    maxLines: 100,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: AppColors.black,
                    text: controller.privacyData.value.description ?? "",
                  ),
                );
            }
          }));
    } else {
      return Scaffold(
          backgroundColor: AppColors.white,
          appBar: CustomAppBar(
            appBarBgColor: AppColors.white,
            appBarContent: AppStrings.termsAndConditions.tr,
            iconData: Icons.arrow_back,
          ),
          body: Obx(() {
            switch (controller.rxRequestStatus.value) {
              case Status.loading:
                return const CustomLoader();
              case Status.internetError:
                return NoInternetScreen(onTap: () {
                  controller.getTerms();
                });
              case Status.error:
                return GeneralErrorScreen(
                  onTap: () {
                    controller.getTerms();
                  },
                );
              case Status.completed:
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: CustomText(
                    textAlign: TextAlign.start,
                    maxLines: 100,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: AppColors.black,
                    text: controller.termsData.value.description ?? "",
                  ),
                );
            }
          }));
    }
  }
}
