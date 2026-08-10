import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:recipe_app/app/global/helper/validators/validators.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_constants/app_constants.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:recipe_app/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:recipe_app/app/view/common_widgets/custom_gender_button/custom_gender_button.dart';
import 'package:recipe_app/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:recipe_app/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:recipe_app/app/view/screens/profile_screen/personal_info/controller/profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  void initState() {
    profileController.nameController.text =
        profileController.profileModel.value.name ?? '';
    profileController.phoneNumberController.text =
        profileController.profileModel.value.phoneNumber ?? '';

    profileController.genderController.text =
        profileController.profileModel.value.gender ?? '';

    profileController.dateOfController.text = getNextMonthDate(
        profileController.profileModel.value.dateOfBirth.toString());
    profileController.locationController.text =
        profileController.profileModel.value.location ?? '';
    profileController.countryNameCode.value =
        profileController.profileModel.value.countryName ?? 'BD';
    profileController.image.value =
        profileController.profileModel.value.profileImage ?? '';
    // print("Received Image: =============${profileController.image.value}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      ///============================ Header ===============================
      appBar: CustomAppBar(
        appBarContent: AppStrings.editProfile.tr,
        iconData: Icons.arrow_back,
        appBarBgColor: AppColors.white,
      ),

      ///============================ body ===============================
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      profileController.selectImage();
                    },
                    child: Obx(() {
                      if (profileController.image.value.isNotEmpty) {
                        String imagePath = profileController.image.value;

                        if (imagePath.startsWith('/data') ||
                            imagePath.startsWith('/storage')) {
                          return ClipOval(
                            child: Image.file(
                              File(imagePath),
                              height: 128.h,
                              width: 128.w,
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          return CustomNetworkImage(
                            boxShape: BoxShape.circle,
                            imageUrl: imagePath.toString() != ""
                                ? imagePath
                                : AppConstants.profile,
                            height: 128.h,
                            width: 128.w,

                            // fit: BoxFit.cover
                          );

                          //  ClipOval(
                          //   child: Image.network(
                          //     "/$imagePath",
                          //     height: 128.h,
                          //     width: 128.w,
                          //     fit: BoxFit.cover,
                          //   ),
                          // );
                        }
                      } else {
                        return Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ClipOval(
                                child: CustomNetworkImage(
                                    imageUrl: AppConstants.profile,
                                    height: 94,
                                    width: 94)),
                            const Positioned(
                              right: 5,
                              bottom: 5,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child:
                                    Icon(Icons.camera_alt, color: Colors.black),
                              ),
                            ),
                          ],
                        );
                      }
                    }),
                  ),
                ),

                CustomFromCard(
                    hinText: "Enter Your Name",
                    title: AppStrings.name.tr,
                    controller: profileController.nameController,
                    validator: (f) {
                      return;
                    }),
                //Date Of Birth
                CustomText(
                  color: AppColors.black,
                  text: AppStrings.dateOfBirth.tr,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  bottom: 8,
                ),
                CustomTextField(
                  readOnly: true,
                  hintText: "Please Select",
                  inputTextStyle: const TextStyle(color: Colors.black),
                  textEditingController: profileController.dateOfController,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: () => profileController.selectDate(context),
                  ),
                  fieldBorderColor: AppColors.greenNormal,
                  validator: Validators.dateOFBirth,
                ),
                CustomText(
                  color: AppColors.black,
                  text: AppStrings.gender.tr,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  bottom: 8.h,
                ),
                // Gender
                CustomGenderButtonRow(
                  genderController: profileController.genderController,
                ),
                //======================Phone Number=================
                CustomText(
                  color: AppColors.black,
                  text: AppStrings.phoneNumber.tr,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  bottom: 8.h,
                ),

                InternationalPhoneNumberInput(
                  initialValue: PhoneNumber(
                      isoCode: profileController.countryNameCode.value),
                  onFieldSubmitted: (value) {
                    log("Value OF OnFeild Submit $value");
                  },
                  onInputChanged: (PhoneNumber number) {
                    profileController.countryNameCode.value =
                        number.isoCode ?? "";
                    log("Value Of Country Code ${number.phoneNumber}");

                    debugPrint('Phone number: ${number.phoneNumber}');
                  },
                  onInputValidated: (bool value) {
                    debugPrint('Is phone number valid: $value');
                  },
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    useBottomSheetSafeArea: true,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  selectorTextStyle: const TextStyle(color: Colors.black),
                  textFieldController: profileController.phoneNumberController,
                  formatInput: true,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputBorder: const OutlineInputBorder(),
                  onSaved: (PhoneNumber number) {
                    debugPrint('Saved phone number: ${number.phoneNumber}');
                  },
                ),
                //location
                CustomFromCard(
                    isBorderColor: true,
                    title: AppStrings.location.tr,
                    hinText: "Add Location",
                    controller: profileController.locationController,
                    validator: (f) {
                      return;
                    }),

                SizedBox(
                  height: 20.h,
                ),

                //========================Save Button===============

                profileController.isUpdateLoading.value
                    ? const CustomLoader()
                    : CustomButton(
                        onTap: () {
                          profileController.updateProfile(context);
                        },
                        title: AppStrings.save.tr,
                      ),
                SizedBox(
                  height: 100.h,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// Time Convert Function
String getNextMonthDate(String input) {
  // Parse the ISO string into a DateTime object
  DateTime date = DateTime.parse(input).toUtc();

  // Create a new DateTime by incrementing the month
  // Dart's DateTime constructor automatically handles year rollover
  DateTime nextMonth = DateTime.utc(
    date.year,
    date.month,
    date.day,
  );

  // Format to YYYY-MM-DD
  String year = nextMonth.year.toString();
  String month = nextMonth.month.toString().padLeft(2, '0');
  String day = nextMonth.day.toString().padLeft(2, '0');

  return "$year-$month-$day";
}
