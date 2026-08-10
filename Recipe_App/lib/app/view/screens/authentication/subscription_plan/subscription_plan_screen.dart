import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/core/route_path.dart';
import 'package:recipe_app/app/core/routes.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/custom_assets/assets.gen.dart';
import 'package:recipe_app/app/utils/enums/status.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:recipe_app/app/view/common_widgets/custom_payment_card/custom_payment_card.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/common_widgets/genarel_error_screen/genarel_error_screen.dart';
import 'package:recipe_app/app/view/common_widgets/no_internet_screen/no_internet_screen.dart';

import '../../../common_widgets/custom_button/custom_button.dart';
import 'controller/payment_controller.dart';

class SubscriptionPlanScreen extends StatelessWidget {
  SubscriptionPlanScreen({super.key});

  final PaymentController controller = Get.find<PaymentController>();

  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        //=====================Appbar=====================
        appBar: CustomAppBar(
          appBarContent: AppStrings.subscriptionPlan.tr,
          appBarBgColor: AppColors.white,
          iconData: Icons.arrow_back,
          skipButton: true,
          skipButtonTap: () {
            AppRouter.route.goNamed(
              RoutePath.homeScreen,
            );
          },
        ),
        body: Obx(() {
          switch (controller.rxRequestStatus.value) {
            case Status.loading:
              return const CustomLoader(); // Show loading indicator

            case Status.internetError:
              return NoInternetScreen(onTap: () {
                controller.getSubscription();
              });

            case Status.error:
              return GeneralErrorScreen(
                onTap: () {
                  controller.getSubscription();
                },
              );

            case Status.completed:
              // Banner Section
              if (controller.subscriptionList.isEmpty) {
                return Center(
                    child: CustomText(
                        text: "No Data Found",
                        fontSize: 20.sp,
                        color: AppColors.black));
              }
              return ListView.builder(
                  itemCount: controller.subscriptionList.length,
                  itemBuilder: (context, index) {
                    final data = controller.subscriptionList[index];
                    return Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.white, AppColors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 20.h),
                          child: Column(
                            children: [
                              Obx(() {
                                final isLoading =
                                    controller.loadingSubscriptionId.value ==
                                        data.id;
                                return CustomSubscriptionCard(
                                  planName: data.name ?? "",
                                  description: data.description ?? "",
                                  price: data.fee.toString(),
                                  iconAsset: Assets.images.silver.path,
                                  cardColor: AppColors.normalHover,
                                  textColor: AppColors.black,
                                  iconBgColor: AppColors.green,
                                  borderColor: Colors.grey,
                                  button: isLoading
                                      ? const CustomLoader()
                                      : CustomButton(
                                          onTap: () {
                                            controller.createPayment(
                                              subscriptionId: data.id ?? "",
                                              context: context,
                                            );
                                          },
                                          borderColor: Colors.grey,
                                          fillColor: AppColors.normalHover,
                                          textColor: AppColors.black,
                                          title: 'Subscribe',
                                        ),
                                );
                              }),
                            ],
                          ),
                        ));
                  });
          }
        }));
  }
}

// SizedBox(height: 12.h),
// CustomSubscriptionCard(
//   planName: "",
//   price: "£34.99",
//   description: 'g',
//   iconAsset: Assets.images.gold.path,
//   cardColor: AppColors.green,
//   textColor: AppColors.white,
//   iconBgColor: AppColors.white,
//   borderColor: AppColors.grey1,
//   onTap: () {
//     debugPrint("Gold plan selected");
//   },
// ),
// SizedBox(height: 12.h),
// CustomSubscriptionCard(
//   planName: "",
//   price: "€ 49.99",
//   description: 'g',
//   iconAsset: Assets.images.diamond.path,
//   cardColor: AppColors.greenLight,
//   textColor: AppColors.black,
//   iconBgColor: AppColors.black300,
//   borderColor: AppColors.secondery20,
//   onTap: () {
//     debugPrint("Diamond plan selected");
//   },
// ),
