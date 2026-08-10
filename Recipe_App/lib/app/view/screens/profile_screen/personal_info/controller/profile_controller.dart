import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/app/core/routes.dart';
import 'package:recipe_app/app/global/helper/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:recipe_app/app/models/profile_model/profile_model.dart';
import 'package:recipe_app/app/services/api_check.dart';
import 'package:recipe_app/app/services/api_client.dart';
import 'package:recipe_app/app/services/app_url.dart';
import 'package:recipe_app/app/utils/enums/status.dart';

class ProfileController extends GetxController {
// Edit Profile Country Code Logic
  String countryCode = "+880";
  RxString countryNameCode = "BD".obs;

////////////////////////////

  var selectedValue = ''.obs;

  void updateSelection(String value, TextEditingController controller) {
    selectedValue.value = value;
    controller.text = value;
  }

  final Rx<Status> rxRequestStatus = Status.loading.obs;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;

  //>>>>>>>>>>>>>>>>>>✅✅Profile Section✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  final Rx<ProfileData> profileModel = ProfileData().obs; // Holds profile data

  Future<void> getProfile() async {
    try {
      setRxRequestStatus(Status.loading);
      refresh();
      var response = await ApiClient.getData(ApiUrl.getProfile);
      // setRxRequestStatus(Status.completed);

      if (response.statusCode == 200) {
        profileModel.value = ProfileData.fromJson(response.body["data"]);
        selectedValue.value = profileModel.value.gender ?? "";
        refresh();
      } else {
        if (response.statusText == ApiClient.noInternetMessage) {
          setRxRequestStatus(Status.internetError);
        } else {
          setRxRequestStatus(Status.error);
        }
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      log("Error From Get Profile $e");
    } finally {
      setRxRequestStatus(Status.completed);
      refresh();
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Edit Profile✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  final nameController = TextEditingController();
  final dateOfController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final genderController = TextEditingController();
  final locationController = TextEditingController();

  RxString image = "".obs;

  Rx<File> imageFile = File("").obs;

  Future<void> selectImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? getImages =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 15);
      if (getImages != null) {
        imageFile.value = File(getImages.path);
        image.value = getImages.path;
      }
    } catch (e) {
      log("Error From Select Image $e");
    }
  }

  void selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      String formattedDate = "${selectedDate.toLocal()}".split(' ')[0];
      dateOfController.text = formattedDate;
      debugPrint(
          "Date==================================>>>>${dateOfController.text}");
    }
  }

  RxBool isUpdateLoading = false.obs;

  Future<void> updateProfile(BuildContext context) async {
    try {
      isUpdateLoading.value = true;
      refresh();

      Map<String, String> body = {
        "name": nameController.text,
        "date_of_birth": dateOfController.text,
        "gender": genderController.text,
        "phone_number": phoneNumberController.text,
        "location": locationController.text,
        "country_name": countryNameCode.value,
      };

      var response = await ApiClient.patchMultipart(
        ApiUrl.profileEdit,
        body,
        multipartBody: image.value.startsWith('/data') ||
                image.value.startsWith('/storage')
            ? [
                MultipartBody("profile_image", File(image.value)),
              ]
            : null,
      );

      // Decode response body if it's a string
      var responseData = response.body;
      // var responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        getProfile();
        AppRouter.route.pop();
        // context.pop();
        toastMessage(message: responseData["message"]);
      } else if (response.statusCode == 400) {
        toastMessage(message: responseData["message"]);
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      log("Error From Update Profile $e");
    } finally {
      isUpdateLoading.value = false;
      refresh();
    }
  }

  @override
  void onInit() {
    getProfile();
    super.onInit();
  }
}
