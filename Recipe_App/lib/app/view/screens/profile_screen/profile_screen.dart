import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:recipe_app/app/core/route_path.dart';
import 'package:recipe_app/app/core/routes.dart';
import 'package:recipe_app/app/global/controller/auth_controller.dart';
import 'package:recipe_app/app/global/helper/local_db/local_db.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_constants/app_constants.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/custom_assets/assets.gen.dart';
import 'package:recipe_app/app/view/common_widgets/custom_menu_card/custom_menu_card.dart';
import 'package:recipe_app/app/view/common_widgets/custom_nav_bar/custom_nav_bar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/common_widgets/permission_button/permission_button.dart';
import 'package:recipe_app/app/view/screens/profile_screen/personal_info/controller/profile_controller.dart';

import 'package:recipe_app/app/view/common_widgets/staggered_list_animation/staggered_list_animation.dart'
    show StaggeredListAnimation;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.find<ProfileController>();

  late final List<MenuItem> menuItems;

  @override
  void initState() {
    super.initState();

    menuItems = [
      MenuItem(
        text: AppStrings.personalInformation.tr,
        route: RoutePath.personalInfo,
        icon: Assets.icons.person.svg(color: Colors.black),
      ),
      // MenuItem(
      //   text: AppStrings.myRecipe.tr,
      //   route: RoutePath.myRecipeScreen,
      //   icon: Assets.icons.addRecipe.svg(color: Colors.black),
      // ),
      MenuItem(
        text: AppStrings.recipeBox.tr,
        route: RoutePath.recipeBox,
        icon: Assets.icons.recipeBox.svg(color: Colors.black),
      ),
      MenuItem(
        text: AppStrings.myFavorites.tr,
        route: RoutePath.myFavorites,
        icon: const Icon(Icons.favorite_border),
      ),
      MenuItem(
        text: AppStrings.settings.tr,
        route: RoutePath.settingScreen,
        icon: Assets.icons.setting.svg(color: Colors.black),
      ),
      MenuItem(
        text: AppStrings.contact.tr,
        route: RoutePath.contactScreen,
        icon: Assets.icons.contact.svg(color: Colors.black),
      ),
      MenuItem(
        text: AppStrings.language.tr,
        route: RoutePath.languageScreen,
        icon: Assets.icons.contact.svg(color: Colors.black),
      ),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: const CustomNavBar(currentIndex: 4),
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: CustomText(
          text: AppStrings.settings.tr,
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
      ),
      body: AnimationLimiter(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: menuItems.length + 2,
          itemBuilder: (context, index) {
            return StaggeredListAnimation(
              position: index,
              child: _buildItemByIndex(index),
            );
          },
        ),
      ),
    );
  }

  Widget _buildItemByIndex(int index) {
    if (index == 0) {
      // Profile Header
      return Center(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Obx(() => CustomNetworkImage(
                  boxShape: BoxShape.circle,
                  imageUrl: profileController.profileModel.value.profileImage
                              ?.toString() !=
                          ""
                      ? "${profileController.profileModel.value.profileImage}"
                      : AppConstants.profile,
                  height: 102.h,
                  width: 102.w,
                )),
            Obx(() => CustomText(
                  top: 8,
                  text: profileController.profileModel.value.name ?? "",
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  color: AppColors.black,
                )),
            Obx(() => CustomText(
                  top: 8,
                  text: profileController.profileModel.value.email ?? '',
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  color: AppColors.black,
                )),
            SizedBox(height: 25.h),
          ],
        ),
      );
    } else if (index == menuItems.length + 1) {
      // Logout button
      return CustomMenuCard(
        onTap: () {
          permissionPopUp(
            context: context,
            ontapNo: () {
              context.pop();
            },
            ontapYes: () async {
              await SharePrefsHelper.remove(AppConstants.bearerToken);
              AppRouter.route.goNamed(RoutePath.signInScreen);
              var controller = Get.find<AuthController>();
              controller.checkRememberMe();
            },
          );
        },
        isArrow: true,
        isTextRed: true,
        text: AppStrings.logOut.tr,
        icon: Assets.icons.logout.svg(),
      );
    } else {
      final item = menuItems[index - 1];
      return CustomMenuCard(
        onTap: () {
          AppRouter.route.pushNamed(item.route);
        },
        text: item.text,
        icon: item.icon,
      );
    }
  }
}

class MenuItem {
  final String text;
  final String route;
  final Widget icon;

  MenuItem({
    required this.text,
    required this.route,
    required this.icon,
  });
}
