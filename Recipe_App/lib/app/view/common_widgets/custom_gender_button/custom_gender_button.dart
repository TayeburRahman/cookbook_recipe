import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/view/screens/profile_screen/personal_info/controller/profile_controller.dart';

class CustomGenderButtonRow extends StatelessWidget {
  final ProfileController controller =
      Get.put(ProfileController()); // GetX controller
  final TextEditingController genderController;

  CustomGenderButtonRow({super.key, required this.genderController});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildRadioButton("Male"),
        _buildRadioButton("Female"),
        _buildRadioButton("Other"),
      ],
    );
  }

  // Build individual radio buttons
  Widget _buildRadioButton(String value) {
    return Row(
      children: [
        Obx(() {
          return Radio<String>(
            activeColor: AppColors.green,
            value: value,
            groupValue: controller.selectedValue.value,
            onChanged: (String? newValue) {
              controller.updateSelection(newValue!,
                  genderController); // Update the value in GetX controller and TextEditingController
              // print(
              //     'Selected value: $newValue'); // Print the selected value to console
            },
          );
        }),
        Text(value),
      ],
    );
  }
}
