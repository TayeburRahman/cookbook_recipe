import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/global/helper/validators/validators.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:recipe_app/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:recipe_app/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:recipe_app/app/view/screens/profile_screen/setting/controller/info_controller.dart';

class ContactScreen extends StatelessWidget {
  ContactScreen({super.key});

  final InfoController controller = Get.find<InfoController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      ///============================ Header ===============================
      appBar: CustomAppBar(
        appBarContent: AppStrings.contactUs.tr,
        iconData: Icons.arrow_back,
        appBarBgColor: AppColors.white,
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Obx(() {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //======================Name================
                  CustomFromCard(
                      hinText: AppStrings.yourName.tr,
                      title: AppStrings.name.tr,
                      controller: controller.nameController,
                      validator: Validators.nameValidator),

                  //======================Email================
                  CustomFromCard(
                      hinText: AppStrings.email.tr,
                      title: AppStrings.email.tr,
                      controller: controller.emailController,
                      validator: Validators.emailValidator),

                  //======================Subject================
                  CustomFromCard(
                      hinText: AppStrings.writeYourSubject.tr,
                      title: AppStrings.subject.tr,
                      controller: controller.subjectController,
                      validator: Validators.subject),
                  //======================Your Message================
                  CustomFromCard(
                      maxLine: 5,
                      hinText: AppStrings.writeYourSubject.tr,
                      title: AppStrings.yourMessage.tr,
                      controller: controller.messageController,
                      validator: Validators.subject),

                  SizedBox(
                    height: 20.h,
                  ),

                  controller.isContact.value
                      ? const CustomLoader()
                      : CustomButton(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              controller.contact(context);
                            }
                          },
                          title: AppStrings.submit.tr,
                          fillColor: AppColors.green,
                        )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
