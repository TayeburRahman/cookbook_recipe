import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/global/helper/date_converter/date_converter.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/utils/enums/status.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_loader/custom_loader.dart'
    show CustomLoader;
import 'package:recipe_app/app/view/common_widgets/no_internet_screen/no_internet_screen.dart';
import 'package:recipe_app/app/view/screens/notification/controller.dart';

import '../../common_widgets/custom_text/custom_text.dart';
import '../../common_widgets/genarel_error_screen/genarel_error_screen.dart';
import '../../common_widgets/notification_card/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    super.key,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController controller = Get.find<NotificationController>();

  @override
  void initState() {
    controller.getNotification();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,

        //========================Notification Appbar=================
        appBar: CustomAppBar(
          appBarContent: AppStrings.notification.tr,
          iconData: Icons.arrow_back,
        ),
        body: Obx(() {
          switch (controller.rxRequestStatus.value) {
            case Status.loading:
              return const CustomLoader(); // Show loading indicator

            case Status.internetError:
              return NoInternetScreen(onTap: () {
                controller.getNotification();
              });

            case Status.error:
              return GeneralErrorScreen(
                onTap: () {
                  controller.getNotification();
                },
              );

            case Status.completed:
              // Banner Section
              if (controller.notificationList.isEmpty) {
                return Center(
                    child: CustomText(
                        text: AppStrings.noDataFound.tr,
                        fontSize: 20.sp,
                        color: AppColors.black));
              }
              return ListView.builder(
                  itemCount: controller.notificationList.length,
                  itemBuilder: (context, index) {
                    final data = controller.notificationList[index];
                    return NotificationCard(
                      title: data.title ?? '',
                      message: data.message ?? "",
                      time: DateConverter.formatDateTimeToGmtPlus6(
                          data.createdAt.toString()),
                    );
                  });
          }
        }));
  }
}
