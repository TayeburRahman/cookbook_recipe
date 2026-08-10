import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/core/route_path.dart';
import 'package:recipe_app/app/core/routes.dart';
import 'package:recipe_app/app/global/controller/auth_controller.dart';
import 'package:recipe_app/app/global/controller/genarel_controller.dart';
import 'package:recipe_app/app/global/helper/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_constants/app_constants.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/custom_assets/assets.gen.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:recipe_app/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

class SelectPhotoScreen extends StatelessWidget {
  SelectPhotoScreen({super.key});
  final AuthController controller = Get.find<AuthController>();
  final GeneralController generalController = Get.find<GeneralController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        appBarContent: AppStrings.selectPhoto.tr,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.w),
        child: SingleChildScrollView(
          child: Obx(() {
            return Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                      onTap: () {
                        generalController.selectImage();
                      },
                      child: generalController.image.isNotEmpty
                          ? Container(
                              height: 94.h,
                              width: 94.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: FileImage(
                                    File(generalController.image.value),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Stack(
                              children: [
                                CustomNetworkImage(
                                  boxShape: BoxShape.circle,
                                  imageUrl: AppConstants.profile,
                                  height: 94.h,
                                  width: 94.w,
                                ),
                                Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                        height: 30.h,
                                        width: 30.w,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle),
                                        child: Assets.icons.camera
                                            .svg(color: AppColors.black)))
                              ],
                            )),
                ),
                CustomText(
                  text: AppStrings.uploadYourPhoto.tr,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.green,
                  top: 10.h,
                ),
                SizedBox(
                  height: 400.h,
                ),
                CustomButton(
                  onTap: () {
                    if (generalController.image.isEmpty) {
                      toastMessage(message: "Please select an image");
                    } else {
                      AppRouter.route.pushNamed(RoutePath.dietaryPreferences);
                    }
                  },
                  title: AppStrings.continues.tr,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
