import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/app/core/route_path.dart';
import 'package:recipe_app/app/core/routes.dart';
import 'package:recipe_app/app/global/controller/genarel_controller.dart';
import 'package:recipe_app/app/global/helper/local_db/local_db.dart';
import 'package:recipe_app/app/global/helper/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:recipe_app/app/models/profile_model/check_profile.dart';
import 'package:recipe_app/app/services/api_check.dart';
import 'package:recipe_app/app/services/api_client.dart';
import 'package:recipe_app/app/services/app_url.dart';
import 'package:recipe_app/app/utils/app_constants/app_constants.dart';
import '../../utils/enums/status.dart';

class AuthController extends GetxController {
  String countryNameCode = "BD";
  final TextEditingController emailForgetController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailSignUpController = TextEditingController();
  final TextEditingController passwordSignUpController =
      TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final relevantController = TextEditingController();
  final mailTypeController = TextEditingController();
  final dietGoalController = TextEditingController();
  TextEditingController resetPasswordController1 = TextEditingController();
  TextEditingController resetPasswordController2 = TextEditingController();

  // final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();

// tisavo1867@nab4.com

// Masum017

  void selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      String formattedDate = "${selectedDate.toLocal()}".split(' ')[0];
      dateOfBirthController.text = formattedDate;
      debugPrint(
          "Date==================================>>>>${dateOfBirthController.text}");
    }
  }

  RxBool isAgree = false.obs;
  RxBool isRemember = false.obs;
  RxBool isLoading = false.obs;

//>>>>>>>>>>>>>>>>>>✅✅SIgn In Method✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  RxBool isSignInLoading = false.obs;

  Future<void> signIn() async {
    try {
      isSignInLoading.value = true;
      refresh();
      Map<String, String> body = {
        "email": emailController.text,
        "password": passwordController.text
      };
      var response = await ApiClient.postData(
        ApiUrl.login,
        jsonEncode(body),
      );
      if (response.statusCode == 200) {
        if (isRemember.value) {
          setRememberMe();
        } else {
          removeRememberMe();
        }

        SharePrefsHelper.setString(
            AppConstants.bearerToken, response.body['data']["accessToken"]);

        debugPrint(
            '======================token   ${response.body['data']['accessToken']}');

        SharePrefsHelper.setString(
            AppConstants.userId, response.body['data']["id"]);

        debugPrint('======================id ${response.body['data']['id']}');
        await checkProfile();

        clearMethod();

        toastMessage(
          message: response.body["message"],
        );
      } else if (response.statusCode == 500) {
        toastMessage(
          message: "Your Server Is Off",
        );
      } else {
        toastMessage(
          message: response.body["message"],
        );
      }
    } catch (e) {
      log("error from signIn method $e");
    } finally {
      isSignInLoading.value = false;
      refresh();
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Forget In Method✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  RxBool isForget = false.obs;

  Future<void> forget() async {
    try {
      isForget.value = true;
      refresh();
      Map<String, String> body = {
        "email": emailForgetController.text,
      };
      var response = await ApiClient.postData(
        ApiUrl.forgotPassword,
        jsonEncode(body),
      );
      if (response.statusCode == 200) {
        AppRouter.route.pushNamed(
          RoutePath.otpScreen,
          extra: {
            "isForget": false,
            "email": emailForgetController.text,
          },
        );
        toastMessage(
          message: response.body["message"],
        );
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      log("error from forget method $e");
    } finally {
      isForget.value = false;
      refresh();
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Sign Up Method✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  RxBool isSignUpLoading = false.obs;
  final GeneralController generalController = Get.find<GeneralController>();

  Future<void> signUp() async {
    try {
      isSignUpLoading.value = true;
      refresh();
      Map<String, String> body = {
        "name": fullNameController.text,
        "email": emailSignUpController.text,
        "password": passwordSignUpController.text,
        "confirmPassword": confirmPasswordController.text,
        "phone_number": phoneNumberController.text,
        "date_of_birth": dateOfBirthController.text,
        "role": "USER",
        "country_name": countryNameCode,
        // "country_code": "+880"
      };
      log("body $body");
      var response = await ApiClient.postData(
        ApiUrl.register,
        jsonEncode(body),
      );
      if (response.statusCode == 200) {
        AppRouter.route.pushNamed(
          RoutePath.otpScreen,
          extra: {
            "isForget": true,
            "email": emailSignUpController.text,
          },
        );
        toastMessage(message: response.body["message"]);
      } else {
        toastMessage(
          message: response.body["message"],
        );
      }
    } catch (e) {
      log("error from signUp method $e");
    } finally {
      isSignUpLoading.value = false;
      refresh();
    }
  }

  RxBool isUpdateInfo = false.obs;

  Future<void> updateInfo() async {
    try {
      isUpdateInfo.value = true;
      refresh();
      Map<String, String> body = {
        "mail_types": mailTypeController.text,
        "relevant_dielary": relevantController.text,
        "helgth_goal": dietGoalController.text,
      };
      var response = await ApiClient.patchMultipart(
        ApiUrl.profileEdit,
        body,
        multipartBody: [
          MultipartBody("profile_image", File(generalController.image.value)),
        ],
      );

      // Decode response body if it's a string
      var responseData = response.body;

      if (response.statusCode == 200) {
        AppRouter.route.pushNamed(RoutePath.subscriptionPlanScreen);
        toastMessage(message: responseData["message"]);
      } else if (response.statusCode == 400) {
        toastMessage(message: responseData["message"]);
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      log("error from updateInfo method $e");
    } finally {
      isUpdateInfo.value = false;
      refresh();
    }
  }

  // ===========✅ available dietary ✅===============
  List<String> relevant = [
    "Gluten-Free",
    "Vegan",
    "Vegetarian",
    "Keto",
    "Paleo",
  ].obs;

  RxList<String> selectedPreferences = <String>[].obs;

  void togglePreference(String preference, bool isSelected) {
    if (isSelected) {
      selectedPreferences.add(preference);
    } else {
      selectedPreferences.remove(preference);
    }

    relevantController.text = selectedPreferences.isEmpty
        ? "[]" // If no preference selected, show empty list "[]"
        : "[${selectedPreferences.map((e) => '"$e"').join(", ")}]";
    relevantController.selection =
        TextSelection.collapsed(offset: relevantController.text.length);
  }

  // ===========✅ Mail Preference ✅===============
  List<String> mailPrefarence = [
    "breakfast",
    "lunches-and-dinners",
    "appetizers",
    "salads",
    "soups",
    "desserts",
    "smoothies/shakes",
    "salad-dressings",
    "jams/marmalades",
    "sides",
  ].obs;

  RxList<String> selectedMealPreferences = <String>[].obs;

  void toggleMealPreference(String preference, bool isSelected) {
    if (isSelected) {
      selectedMealPreferences.add(preference);
    } else {
      selectedMealPreferences.remove(preference);
    }

    mailTypeController.text = selectedMealPreferences.isEmpty
        ? "[]"
        : "[${selectedMealPreferences.map((e) => '"$e"').join(", ")}]";
    mailTypeController.selection =
        TextSelection.collapsed(offset: mailTypeController.text.length);
  }

  // ===========✅ Goal ✅===============
  List<String> goal = [
    "weight_loss",
    "muscle_gain",
    "maintain_weight",
  ].obs;
  RxList<String> selectGoal = <String>[].obs;

  void toggleGoalPreference(String preference, bool isSelected) {
    if (isSelected) {
      selectGoal.clear();
      selectGoal.add(preference);
    } else {
      selectGoal.remove(preference);
    }
    dietGoalController.text = selectGoal.isEmpty ? "" : selectGoal.first;
    dietGoalController.selection =
        TextSelection.collapsed(offset: dietGoalController.text.length);
  }

  //>>>>>>>>>>>>>>>>>>✅✅Sign Up Otp ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  String activationCode = "";
  RxBool isSignUpOtp = false.obs;

  Future<void> signUpVerifyOTP() async {
    try {
      if (activationCode.isEmpty) {
        toastMessage(message: "Please enter the activation code.");
        return;
      }

      isSignUpOtp.value = true;
      refresh();

      Map<String, String> body = {
        "activation_code": activationCode,
        "userEmail": emailSignUpController.text
      };
      log("body $body");
      var response =
          await ApiClient.postData(ApiUrl.activateAccount, jsonEncode(body));
      isSignUpOtp.value = false;
      refresh();

      if (response.statusCode == 201) {
        SharePrefsHelper.setString(
            AppConstants.bearerToken, response.body['data']["accessToken"]);

        // debugPrint(
        //     '======================token   ${response.body['data']['accessToken']}');

        await checkProfile();

        toastMessage(message: response.body["message"]);
      } else {
        toastMessage(message: response.body["message"]);
        // ApiChecker.checkApi(response);
        // print("Error: ${response.body["message"]}");
      }
    } catch (e) {
      log("error from signUpVerifyOTP method $e");
    } finally {
      isSignUpOtp.value = false;
      refresh();
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Forget Otp ✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  String resetCode = "";
  RxBool isForgetOtp = false.obs;

  Future<void> forgetOtp() async {
    try {
      if (resetCode.isEmpty) {
        toastMessage(message: "Please enter the activation code.");
        return;
      }

      isForgetOtp.value = true;
      refresh();

      Map<String, String> body = {
        "code": resetCode,
        "email": emailForgetController.text
      };
      var response =
          await ApiClient.postData(ApiUrl.forgotVerifyOtp, jsonEncode(body));
      isForgetOtp.value = false;
      refresh();

      if (response.statusCode == 200) {
        AppRouter.route.pushNamed(RoutePath.resetPasswordScreen);
        toastMessage(message: response.body["message"]);
      } else {
        toastMessage(message: response.body["message"]);
        // ApiChecker.checkApi(response);
        // debugPrint("Error: ${response.body["message"]}");
      }
    } catch (e) {
      log("error from forgetOtp method $e");
    } finally {
      isForgetOtp.value = false;
      refresh();
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Reset Password✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  RxBool isResetLoading = false.obs;

  Future<void> resetPassword({required String email}) async {
    try {
      isResetLoading.value = true;
      refresh();
      Map<String, String> body = {
        "newPassword": resetPasswordController1.text,
        "confirmPassword": resetPasswordController2.text
      };
      var response = await ApiClient.postData(
        ApiUrl.resetPassword(email: email),
        jsonEncode(body),
      );
      if (response.statusCode == 200) {
        clearMethod();
        AppRouter.route.goNamed(
          RoutePath.signInScreen,
        );
        toastMessage(
          message: response.body["message"],
        );
      } else {
        toastMessage(
          message: response.body["message"],
        );
      }
    } catch (e) {
      log("error from resetPassword method $e");
    } finally {
      isResetLoading.value = false;
      refresh();
    }
  }

  void clearMethod() {
    emailController.clear();
    pinCodeController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  //=============+Check Profile=============
  final Rx<Status> rxRequestStatus = Status.loading.obs;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;

  final Rx<CheckData> checkData = CheckData().obs; // Holds profile data

  Future<void> checkProfile() async {
    try {
      setRxRequestStatus(Status.loading);
      refresh();
      var response = await ApiClient.getData(ApiUrl.checkProfileInfo);
      setRxRequestStatus(Status.completed);
      if (response.statusCode == 200) {
        checkData.value = CheckData.fromJson(response.body["data"]);

        log("Ajay checkData.value.message ${checkData.value.message}");
        refresh();
        if (checkData.value.message == "Incomplete") {
          AppRouter.route.goNamed(RoutePath.selectPhotoScreen);
        } else if (checkData.value.message == "Complete") {
          AppRouter.route.goNamed(RoutePath.homeScreen);
        } else {
          debugPrint("Something Wrong");
        }
      } else {
        if (response.statusText == ApiClient.noInternetMessage) {
          setRxRequestStatus(Status.internetError);
        } else {
          setRxRequestStatus(Status.error);
        }
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      log("error from checkProfile method $e");
    } finally {
      setRxRequestStatus(Status.completed);
      refresh();
    }
  }

  Future<void> checkRememberMe() async {
    bool? isRememberMe =
        await SharePrefsHelper.getBool(AppConstants.rememberMe);

    log("Value OF is Remember Me is $isRememberMe");

    if (isRememberMe == null || isRememberMe == false) {
      removeRememberMe();
    } else {
      getRememberMe();
    }
  }

  Future<void> getRememberMe() async {
    String email = await SharePrefsHelper.getString(AppConstants.email);
    String password = await SharePrefsHelper.getString(AppConstants.password);

    if (email != "" || password != "") {
      emailController.text = email;
      passwordController.text = password;
      isRemember.value = true;
    }
  }

  Future<void> setRememberMe() async {
    if (isRemember.value) {
      await SharePrefsHelper.setBool(AppConstants.rememberMe, true);
      if (emailController.text != "" || passwordController.text != "") {
        await SharePrefsHelper.setString(
            AppConstants.email, emailController.text);
        await SharePrefsHelper.setString(
            AppConstants.password, passwordController.text);
      }
    }
  }

  Future<void> removeRememberMe() async {
    await SharePrefsHelper.remove(AppConstants.email);
    await SharePrefsHelper.remove(AppConstants.password);
  }

  @override
  void onInit() {
    checkRememberMe();
    super.onInit();
  }
}
