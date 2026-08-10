import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/global/controller/language_controller.dart';
import 'package:recipe_app/app/global/helper/local_db/local_db.dart';
import 'package:recipe_app/app/utils/app_constants/app_constants.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import '../../../../utils/app_colors/app_colors.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen({super.key});

  final LanguageController languageController = Get.find<LanguageController>();
  final List<String> languageList = ["English", "Spanish"];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(
          appBarContent: AppStrings.language.tr,
          iconData: Icons.arrow_back,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///===========================Select Your language==================
              CustomText(
                text: AppStrings.selectYourLanguage.tr,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                bottom: 10,
              ),

              /// Language selection row
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 44,
                      child: CustomTextField(
                        inputTextStyle: const TextStyle(color: AppColors.black),
                        onTap: () {
                          languageController.isLanguage.value =
                              !languageController.isLanguage.value;
                        },
                        readOnly: true,
                        textEditingController: languageController.language,
                        hintText: AppStrings.language.tr,
                        fillColor: AppColors.white,
                        fieldBorderColor: AppColors.black,
                        suffixIcon: Icon(
                          languageController.isLanguage.value
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    /// Dropdown options
                    if (languageController.isLanguage.value)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: languageList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                // Update locale and UI
                                final selectedLocale = index == 0
                                    ? const Locale("en", "US")
                                    : const Locale("es", "ES");
                                log("2 Ajay Value Check ${selectedLocale.languageCode}");
                                await SharePrefsHelper.setString(
                                    AppConstants.language,
                                    selectedLocale.languageCode);
                                Get.updateLocale(selectedLocale);

                                languageController.selectedCategory.value =
                                    index;
                                languageController.language.text =
                                    languageList[index];
                                languageController.isLanguage.value = false;
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: CustomText(
                                  text: languageList[index],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: languageController
                                              .selectedCategory.value ==
                                          index
                                      ? AppColors.black
                                      : Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
