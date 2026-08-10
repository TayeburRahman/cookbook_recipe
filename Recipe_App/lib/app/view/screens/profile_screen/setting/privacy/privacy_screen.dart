import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/common_widgets/genarel_error_screen/genarel_error_screen.dart';
import 'package:recipe_app/app/view/common_widgets/no_internet_screen/no_internet_screen.dart';
import 'package:recipe_app/app/view/screens/profile_screen/setting/controller/info_controller.dart';
import '../../../../../utils/enums/status.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  PrivacyPolicyScreen({super.key});

  final InfoController controller = Get.find<InfoController>();

  @override
  Widget build(BuildContext context) {
    controller.getPrivacy(); // Fetch privacy data

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        appBarBgColor: AppColors.white,
        appBarContent: AppStrings.privacyPolicy.tr,
        iconData: Icons.arrow_back,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.privacyData.value.description == null) {
            return const Center(
                child: CustomText(
              text: AppStrings.noDataFound,
              color: AppColors.black,
            ));
          }
          switch (controller.rxRequestStatus.value) {
            case Status.loading:
              return const CustomLoader();

            case Status.internetError:
              return NoInternetScreen(onTap: controller.getPrivacy);

            case Status.error:
              return GeneralErrorScreen(onTap: controller.getPrivacy);

            case Status.completed:
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Html(
                  data: controller.privacyData.value.description ?? "",
                  style: {
                    "body": Style(
                      fontSize: FontSize(16.sp),
                      color: AppColors.black,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.start,
                    ),
                  },
                ),
              );
          }
        }),
      ),
    );
  }
}
