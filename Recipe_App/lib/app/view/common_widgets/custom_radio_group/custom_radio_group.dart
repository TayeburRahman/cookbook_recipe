import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/view/common_widgets/custom_radio_button/custom_radio_button.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

class CustomRadioGroup<T> extends StatelessWidget {
  final String title;
  final RxString selectedValue;
  final List<String> options;
  final ValueChanged<String> onSelectionChanged;

  const CustomRadioGroup({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.options,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        CustomText(
          text: title,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
          bottom: 8,
        ),
        // Radio Buttons
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options.map((option) {
              return Obx(() => CustomRadioButton(
                    value: option,
                    groupValue: selectedValue.value,
                    label: option.split('_').join(' ').capitalize ?? "N/A",
                    onChanged: (val) {
                      onSelectionChanged(val);
                      selectedValue.value = val; // Update the selected value
                      debugPrint("Selected: $val");
                    },
                  ));
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
