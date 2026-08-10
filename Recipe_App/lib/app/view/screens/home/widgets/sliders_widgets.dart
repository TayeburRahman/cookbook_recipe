import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:recipe_app/app/view/screens/home/controller/home_controller.dart'
    show HomeController;

class SlidersWidgets extends StatelessWidget {
  const SlidersWidgets({
    super.key,
    required this.homeController,
  });

  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0.h, // Set fixed height for PageView
      child: PageView.builder(
        itemCount: homeController.bannerList.length,
        controller: PageController(viewportFraction: 1.0),
        onPageChanged: (index) {
          homeController.currentIndex.value = index;
          debugPrint("Page changed to index: $index");
        },
        itemBuilder: (context, index) {
          final banner = homeController.bannerList[index];
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
                child: GestureDetector(
                  onTap: () {
                    if (banner.link != null && banner.link!.isNotEmpty) {
                      // Handle navigation if needed, for now just print or use dynamic routing
                      debugPrint("Banner clicked: ${banner.link}");
                    }
                  },
                  child: CustomNetworkImage(
                    imageUrl: banner.image ?? '',
                    height: 200.h,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
