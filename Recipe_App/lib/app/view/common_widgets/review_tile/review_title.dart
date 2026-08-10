import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors/app_colors.dart';
import '../custom_network_image/custom_network_image.dart';
import '../custom_text/custom_text.dart';

class ReviewTile extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final String timeAgo;
  final double starCount;

  const ReviewTile({
    super.key,
    required this.imageUrl,
    required this.userName,
    required this.timeAgo,
    this.starCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomNetworkImage(
              imageUrl: imageUrl,
              height: 40.h,
              width: 40.w,
              boxShape: BoxShape.circle,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 3,
                        child: CustomText(
                          textAlign: TextAlign.start,
                          text: userName,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                          color: AppColors.black500,
                          bottom: 8,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        flex: 4,
                        child: CustomText(
                          textAlign: TextAlign.end,
                          text: timeAgo,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          color: AppColors.black500,
                          bottom: 8,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      if (index < starCount.floor()) {
                        return const Icon(Icons.star,
                            color: Colors.amber, size: 16);
                      } else if (index < starCount && starCount % 1 != 0) {
                        return const Icon(Icons.star_half,
                            color: Colors.amber, size: 16);
                      } else {
                        return const Icon(Icons.star_border,
                            color: Colors.amber, size: 16);
                      }
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
