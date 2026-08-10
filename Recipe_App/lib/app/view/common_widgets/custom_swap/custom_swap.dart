import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../custom_text/custom_text.dart';


class OptionItem {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  OptionItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });
}

Future<void> showOptionDialog({
  required BuildContext context,
  required List<OptionItem> options,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map(
                  (option) => OptionTile(
                    icon: option.icon,
                    text: option.text,
                    onTap: () {

                      option.onTap();
                    },
                  ),
            )
                .toList(),
          ),
        ),
      );
    },
  );
}



class OptionTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: AppColors.green.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.green, size: 20.sp),
      ),
      title: CustomText(
        text: text,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
        textAlign: TextAlign.start,
      ),
      onTap: onTap,
    );
  }
}
