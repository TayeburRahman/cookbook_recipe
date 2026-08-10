import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../custom_text/custom_text.dart';

class TabSelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const TabSelector({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    const navyColor = Color(0xFF1B3B4A);

    return Container(
      width: double.infinity,
      height: 44.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: navyColor, width: 1.5),
      ),
      child: Row(
        children: [
          // ✅ BY AISLE Tab
          Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(0),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: selectedIndex == 0 ? navyColor : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2.r),
                    bottomLeft: Radius.circular(2.r),
                  ),
                ),
                child: Center(
                  child: CustomText(
                    textAlign: TextAlign.center,
                    text: "BY AISLE",
                    fontWeight:
                        selectedIndex == 0 ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 13.sp,
                    color: selectedIndex == 0 ? Colors.white : navyColor,
                  ),
                ),
              ),
            ),
          ),

          // Divider between tabs
          Container(
            width: 1,
            color: navyColor,
          ),

          // ✅ BY RECIPE Tab
          Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(1),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: selectedIndex == 1 ? navyColor : Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(2.r),
                    bottomRight: Radius.circular(2.r),
                  ),
                ),
                child: Center(
                  child: CustomText(
                    textAlign: TextAlign.center,
                    text: "BY RECIPE",
                    fontWeight:
                        selectedIndex == 1 ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 13.sp,
                    color: selectedIndex == 1 ? Colors.white : navyColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
