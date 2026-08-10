import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:recipe_app/app/global/controller/auth_controller.dart';
import 'package:recipe_app/app/global/helper/validators/validators.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:recipe_app/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:recipe_app/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:recipe_app/app/view/common_widgets/custom_rich_text/custom_rich_text.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:recipe_app/app/core/route_path.dart';
import 'package:recipe_app/app/core/routes.dart';
import 'package:recipe_app/app/global/helper/show_custom_snackbar/show_custom_snackbar.dart';
import 'inherited_widget/signup_top_element.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final AuthController authController = Get.find<AuthController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      //======================Appbar================
      appBar: const CustomAppBar(
        // appBarContent: AppStrings.signUp.tr,
        iconData: Icons.arrow_back,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
            child: Form(
              key: _formKey,
              child: Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 22.h),
                    const SignUpTopElement(),
                    SizedBox(height: 38.h),

                    /// fullName
                    CustomFromCard(
                      hinText: AppStrings.enterYourNameHere.tr,
                      title: AppStrings.fullName.tr,
                      controller: authController.fullNameController,
                      validator: Validators.nameValidator,
                    ),

                    /// Email Field
                    CustomFromCard(
                      hinText: AppStrings.enterYourEmailHere.tr,
                      title: AppStrings.email.tr,
                      controller: authController.emailSignUpController,
                      validator: Validators.emailValidator,
                    ),

                    /// phoneNumber Field
                    CustomText(
                      color: AppColors.black,
                      text: AppStrings.phoneNumber.tr,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      bottom: 8,
                    ),

                    InternationalPhoneNumberInput(
                      initialValue:
                          PhoneNumber(isoCode: authController.countryNameCode),
                      onFieldSubmitted: (value) {
                        log("Value OF OnFeild Submit $value");
                      },
                      onInputChanged: (PhoneNumber number) {
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
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      textFieldController: authController.phoneNumberController,
                      formatInput: true,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputDecoration: InputDecoration(
                        hintText: AppStrings.enterYourPhoneNumber.tr,
                        hintStyle: const TextStyle(color: AppColors.gray),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                              color: AppColors.greenNormal, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                              color: AppColors.greenNormal, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                              color: AppColors.greenNormal, width: 1),
                        ),
                      ),
                      onSaved: (PhoneNumber number) {
                        debugPrint('Saved phone number: ${number.phoneNumber}');
                      },
                    ),
                    SizedBox(height: 12.h),

                    /// Date of Birth Field
                    CustomText(
                      color: AppColors.black,
                      text: AppStrings.dateOfBirth.tr,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      bottom: 8,
                    ),
                    CustomTextField(
                      onTap: () {
                        authController.selectDate(context);
                      },
                      readOnly: true,
                      hintText: "Please Select",
                      inputTextStyle: const TextStyle(color: Colors.black),
                      textEditingController: authController
                          .dateOfBirthController, // Attach the controller to the text field
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: () => authController.selectDate(
                            context), // Show date picker on icon click
                      ),
                      fieldBorderColor: AppColors.greenNormal,
                      validator: Validators.dateOFBirth,
                    ),

                    /// Password Field
                    CustomFromCard(
                      isPassword: true,
                      hinText: AppStrings.enterYourPassword.tr,
                      title: AppStrings.password.tr,
                      controller: authController.passwordSignUpController,
                      validator: Validators.passwordValidator,
                    ),

                    /// confirmPassword Field
                    CustomFromCard(
                      isPassword: true,
                      hinText: AppStrings.enterYourPassword.tr,
                      title: AppStrings.confirmPassword.tr,
                      controller: authController.confirmPasswordController,
                      validator: (value) {
                        // Pass the password value for confirmation check
                        return Validators.confirmPasswordValidator(value,
                            authController.passwordSignUpController.text);
                      },
                    ),

                    SizedBox(height: 10.h),

                    /// Disclaimer Checkbox
                    Row(
                      children: [
                        Obx(() => Checkbox(
                              value: authController.isAgree.value,
                              onChanged: (value) {
                                authController.isAgree.value = value!;
                              },
                              activeColor: AppColors.green,
                              checkColor: AppColors.white,
                            )),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              AppRouter.route
                                  .pushNamed(RoutePath.disclaimerScreen);
                            },
                            child: RichText(
                              text: TextSpan(
                                text: AppStrings.iAgreeWithThe,
                                style: TextStyle(
                                    color: AppColors.black, fontSize: 13.sp),
                                children: [
                                  TextSpan(
                                    text: AppStrings.termsAndDisclaimer,
                                    style: TextStyle(
                                      color: AppColors.green,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    ///>>>>>>>✅✅continues Button✅✅<<<<<<<<
                    authController.isSignUpLoading.value
                        ? const CustomLoader()
                        : CustomButton(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                if (authController.isAgree.value) {
                                  authController.signUp();
                                }
                              }
                              if (authController.isAgree.value == false) {
                                toastMessage(
                                    message: "Please agree to the disclaimer",
                                    isError: true);
                                return;
                              }
                            },
                            title: AppStrings.continues.tr,
                          ),

                    SizedBox(height: 50.h),

                    /// Don't have an account? Sign Up
                    CustomRichText(
                      firstText: AppStrings.alreadyHaveAnAccount.tr,
                      secondText: AppStrings.signIn.tr,
                      onTapAction: () {
                        context.pop();
                      },
                    ),
                    SizedBox(height: 30.h),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
