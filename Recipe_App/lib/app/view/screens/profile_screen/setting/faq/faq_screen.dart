import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/enums/status.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/common_widgets/genarel_error_screen/genarel_error_screen.dart';
import 'package:recipe_app/app/view/common_widgets/no_internet_screen/no_internet_screen.dart';
import 'package:recipe_app/app/view/screens/profile_screen/setting/controller/info_controller.dart';

class FaqScreen extends StatelessWidget {
  FaqScreen({super.key});

  final InfoController infoController = Get.find<InfoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,

        ///============================ Header ===============================
        appBar: CustomAppBar(
          appBarBgColor: AppColors.white,
          appBarContent: AppStrings.faqs.tr,
          iconData: Icons.arrow_back,
        ),
        body: SafeArea(
          child: Obx(() {
            if (infoController.faqList.isEmpty) {
              return const Center(
                  child: CustomText(
                text: AppStrings.noDataFound,
                color: AppColors.black,
              ));
            }
            switch (infoController.rxRequestStatus.value) {
              case Status.loading:
                return const CustomLoader(); // Show loading indicator
              case Status.internetError:
                return NoInternetScreen(onTap: () {
                  infoController.getFaq();
                });
              case Status.error:
                return GeneralErrorScreen(
                  onTap: () {
                    infoController.getFaq();
                  },
                );
              case Status.completed:
                return ListView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  itemCount: infoController.faqList.length,
                  itemBuilder: (context, index) {
                    final data = infoController.faqList[index];
                    return Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.green),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          /// **Question**
                          ListTile(
                            title: CustomText(
                              maxLines: 2,
                              textAlign: TextAlign.start,
                              text: data.questions ?? "",
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            trailing: Obx(() {
                              final isSelected =
                                  infoController.selectedIndex.value == index;
                              return Icon(
                                isSelected
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.green,
                              );
                            }),
                            onTap: () => infoController.toggleItem(index),
                          ),

                          /// **Answer**
                          Obx(() {
                            final isSelected =
                                infoController.selectedIndex.value == index;
                            return AnimatedCrossFade(
                              firstChild: Container(),
                              secondChild: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: CustomText(
                                  maxLines: 50,
                                  textAlign: TextAlign.start,
                                  text: data.answer ?? "",
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              crossFadeState: isSelected
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 300),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                );
            }
          }),
        ));
  }
}
