import 'package:flutter/material.dart';

import '../custom_text/custom_text.dart';

class RatingStar extends StatelessWidget {
  final double? rating;
  final double iconSize;
  final double textFontSize;
  final FontWeight textFontWeight;
  final Color iconColor;
  final Color textColor;
  final double spacing;

  const RatingStar({
    super.key,
    required this.rating,
    this.iconSize = 18,
    this.textFontSize = 14,
    this.textFontWeight = FontWeight.w500,
    this.iconColor = Colors.amber,
    this.textColor = Colors.black,
    this.spacing = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.star,
          color: iconColor,
          size: iconSize,
        ),
        CustomText(
          left: spacing,
          fontSize: textFontSize,
          fontWeight: textFontWeight,
          color: textColor,
          text: (rating ?? 0).toStringAsFixed(1),
        ),
      ],
    );
  }
}
