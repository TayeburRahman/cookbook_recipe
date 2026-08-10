import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/home/notification_model.dart';
import '../../../services/api_check.dart';
import '../../../services/api_client.dart';
import '../../../services/app_url.dart';
import '../../../utils/enums/status.dart';

class NotificationController extends GetxController{
  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  final Rx<Status> rxRequestStatus = Status.loading.obs;
  //>>>>>>>>>>>>>>>>>>✅✅getNotification✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxList<NotificationList> notificationList = <NotificationList>[].obs;

  getNotification() async {
    setRxRequestStatus(Status.loading);
    refresh();
    var response = await ApiClient.getData(ApiUrl.getNotification);

    if (response.statusCode == 200) {
      notificationList.value = List<NotificationList>.from(
          response.body["data"].map((x) => NotificationList.fromJson(x)));
      debugPrint("Total=================${notificationList.length}");

      setRxRequestStatus(Status.completed);
      refresh();
    } else {
      if (response.statusText == ApiClient.noInternetMessage) {
        setRxRequestStatus(Status.internetError);
      } else {
        setRxRequestStatus(Status.error);
      }
      ApiChecker.checkApi(response);
    }
  }


}