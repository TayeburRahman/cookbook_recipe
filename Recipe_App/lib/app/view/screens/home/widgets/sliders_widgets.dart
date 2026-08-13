import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:recipe_app/app/view/screens/home/controller/home_controller.dart';

class SlidersWidgets extends StatelessWidget {
  const SlidersWidgets({
    super.key,
    required this.homeController,
  });

  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180.h,
          child: PageView.builder(
            itemCount: homeController.bannerList.length,
            controller: PageController(viewportFraction: 0.92),
            onPageChanged: (index) {
              homeController.currentIndex.value = index;
            },
            itemBuilder: (context, index) {
              final banner = homeController.bannerList[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.r),
                    child: GestureDetector(
                      onTap: () {
                        if (banner.link != null && banner.link!.isNotEmpty) {
                          debugPrint("Banner clicked: ${banner.link}");
                        }
                      },
                      child: CustomNetworkImage(
                        imageUrl: banner.image ?? '',
                        height: 180.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10.h),
        // Animated Page Indicator Dots
        Obx(() {
          if (homeController.bannerList.length <= 1) {
            return const SizedBox.shrink();
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              homeController.bannerList.length,
              (index) {
                final isSelected = homeController.currentIndex.value == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  height: 6.h,
                  width: isSelected ? 20.w : 6.w,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.bottomNabColor
                        : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
