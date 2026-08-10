import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/core/route_path.dart';
import 'package:recipe_app/app/core/routes.dart';
import 'package:recipe_app/app/global/helper/date_converter/date_converter.dart';
import 'package:recipe_app/app/services/app_url.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_constants/app_constants.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/custom_assets/assets.gen.dart';
import 'package:recipe_app/app/utils/enums/status.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:recipe_app/app/view/common_widgets/custom_menu_card/custom_menu_card.dart';
import 'package:recipe_app/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/common_widgets/genarel_error_screen/genarel_error_screen.dart';
import 'package:recipe_app/app/view/common_widgets/no_internet_screen/no_internet_screen.dart';
import 'package:recipe_app/app/view/screens/profile_screen/personal_info/controller/profile_controller.dart';

class PersonalInfo extends StatelessWidget {
  PersonalInfo({
    super.key,
  });

  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,

        ///============================ Header ===============================
        appBar: CustomAppBar(
          appBarContent: AppStrings.profile.tr,
          iconData: Icons.arrow_back,
          isIcon: true,
          onTap: () {
            AppRouter.route.pushNamed(
              RoutePath.editProfileScreen,
            );
            //  AppRouter.route.pushNamed(
            //   RoutePath.editProfileScreen,
            // );
          },
          appBarBgColor: AppColors.white,
        ),

        ///============================ body ===============================
        body: Obx(() {
          var data = profileController.profileModel.value;
          switch (profileController.rxRequestStatus.value) {
            case Status.loading:
              return const CustomLoader(); // Show loading indicator

            case Status.internetError:
              return NoInternetScreen(onTap: () {
                profileController.getProfile();
              });

            case Status.error:
              return GeneralErrorScreen(
                onTap: () {
                  profileController
                      .getProfile(); // Retry fetching data on error
                },
              );

            case Status.completed:
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //TOdo=====Header====
                    Center(
                        child: Column(
                      children: [
                        CustomNetworkImage(
                          boxShape: BoxShape.circle,
                          imageUrl: (data.profileImage != null &&
                                  data.profileImage!.isNotEmpty)
                              ? (data.profileImage!.startsWith('https')
                                  ? data.profileImage!
                                  : "${ApiUrl.baseUrl}/${data.profileImage!}")
                              : AppConstants.profile,
                          height: 102.h,
                          width: 102.h,
                        ),
                        CustomText(
                          top: 8.h,
                          text: data.name ?? "",
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.black,
                        ),
                        CustomText(
                          top: 8.h,
                          text: data.email ?? '',
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          color: AppColors.black,
                        ),
                        SizedBox(height: 25.h),
                      ],
                    )),
                    //TOdo=====name====
                    CustomMenuCard(
                      onTap: () {},
                      isArrow: true,
                      text: data.name ?? "",
                      icon: Assets.icons.person.svg(color: AppColors.black),
                    ),
                    //=====date====
                    CustomMenuCard(
                      isArrow: true,
                      text: DateConverter.estimatedDates(data.dateOfBirth),
                      icon: Assets.images.date.image(color: AppColors.black),
                    ),
                    //=====gender====
                    CustomMenuCard(
                      isArrow: true,
                      text: data.gender ?? "",
                      icon: Assets.icons.gender.svg(color: AppColors.black),
                    ),
                    //=========phone===
                    CustomMenuCard(
                      text: data.phoneNumber ?? "",
                      icon: Assets.images.phone.image(color: AppColors.black),
                      isArrow: true,
                    ),
                    //=====location====
                    CustomMenuCard(
                      isArrow: true,
                      text: data.location ?? "",
                      icon:
                          Assets.images.location.image(color: AppColors.black),
                    ), //=====addService====
                  ],
                ),
              );
          }
        }));
  }
}
