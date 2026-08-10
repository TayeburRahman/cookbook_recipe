import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/core/route_path.dart';
import 'package:recipe_app/app/core/routes.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_home_card/custom_home_card.dart';
import 'package:recipe_app/app/view/screens/home/controller/home_controller.dart';

class CategoryAllScreen extends StatelessWidget {
  CategoryAllScreen({super.key});
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.category,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            // mainAxisSpacing: 10,
            // childAspectRatio: 1.0,
          ),
          itemCount: controller.categoryList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                AppRouter.route.pushNamed(
                  RoutePath.categoryScreen,
                  extra: controller.categoryList[index].id.toString(),
                );
              },
              child: CustomHomeCard(
                title: controller.categoryList[index].name.toString(),
                image: controller.categoryList[index].image.toString(),
                color: Colors.white,
                elevation: 8.0,
              ),
            );
          },
        ),
      ),
    );
  }
}
