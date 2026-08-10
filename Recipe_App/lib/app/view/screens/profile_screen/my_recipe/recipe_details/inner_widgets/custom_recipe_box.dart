// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../../../../utils/app_colors/app_colors.dart';
// import '../../../../../common_widgets/custom_network_image/custom_network_image.dart';
// import '../../../../../common_widgets/custom_text/custom_text.dart';
// import '../../../../../common_widgets/rating_star/rating_star.dart';
//
//
// class CustomRecipeBox extends StatelessWidget {
//   final String imageUrl;
//   final String title;
//   final String category;
//   final double? rating;
//   final VoidCallback onCardTap;
//   final VoidCallback onMoreTap;
//   final VoidCallback onFavoriteTap;
//   final RxBool isFavorite;
//
//   const CustomRecipeBox({
//     super.key,
//     required this.imageUrl,
//     required this.title,
//     required this.category,
//     this.rating,
//     required this.onCardTap,
//     required this.onMoreTap,
//     required this.onFavoriteTap,
//     required this.isFavorite,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onCardTap,
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
//         decoration: BoxDecoration(
//           color: AppColors.greenLight,
//           borderRadius: BorderRadius.circular(16.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomNetworkImage(
//               imageUrl: Uri.encodeFull(imageUrl),
//               height: 130.h,
//               width: 120.w,
//               borderRadius: BorderRadius.circular(12.r),
//             ),
//             SizedBox(width: 10.w),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title & More
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: CustomText(
//                           textAlign: TextAlign.start,
//                           text: title.isNotEmpty ? title : "No Name",
//                           maxLines: 4,
//                           fontSize: 20.sp,
//                           bottom: 4,
//                           fontWeight: FontWeight.w500,
//                           color: AppColors.black600,
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: onMoreTap,
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             color: AppColors.green,
//                             shape: BoxShape.circle,
//                           ),
//                           padding: const EdgeInsets.all(8),
//                           child: const Icon(
//                             Icons.more_horiz,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   // Category
//                   CustomText(
//                     fontSize: 14.sp,
//                     maxLines: 10,
//                     fontWeight: FontWeight.w500,
//                     color: AppColors.black200,
//                     text: category.isNotEmpty ? category : "Uncategorized",
//                   ),
//
//                   SizedBox(height: MediaQuery.of(context).size.height / 18),
//
//                   // Rating & Favorite
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       RatingStar(
//                         rating: rating,
//                         textColor: AppColors.black200,
//                       ),
//                       Obx(
//                             () => GestureDetector(
//                           onTap: onFavoriteTap,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: isFavorite.value ? Colors.red : Colors.white, // red when true, white when false
//                               shape: BoxShape.circle,
//                             ),
//                             padding: EdgeInsets.all(8.h),
//                             child: Icon(
//                               isFavorite.value
//                                   ? Icons.favorite
//                                   : Icons.favorite_border,
//                               color: isFavorite.value ? Colors.white : Colors.black,
//                               size: 20,
//                             ),
//                           ),
//                         ),
//                       ),
//
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
