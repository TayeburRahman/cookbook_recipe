import 'package:flutter/material.dart';

import '../../../utils/app_colors/app_colors.dart';

class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final double padding;
  final double iconSize;
  final VoidCallback? onTap;

  const CircularIconButton({
    super.key,
    required this.icon,
    this.iconColor = Colors.white,
    this.padding = 8,
    this.iconSize = 24,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.green,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(padding),
        child: Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}
