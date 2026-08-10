import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/common_widgets/selected_radio_button/selected_radio_button.dart';

class LabeledRadioButton<T> extends StatelessWidget {
  final String labelText;
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;

  const LabeledRadioButton({
    super.key,
    required this.labelText,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          top: 10,
          bottom: 12,
          text: labelText,
          fontWeight: FontWeight.w700,
          fontSize: 16.sp,
          color: AppColors.green,
        ),
        SelectedRadioButton(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          label: groupValue.toString().split('_').join(' ').capitalize ?? "N/A",
        ),
      ],
    );
  }
}
