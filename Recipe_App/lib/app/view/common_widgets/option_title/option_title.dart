import 'package:flutter/material.dart';

import '../../../utils/app_colors/app_colors.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.green),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.green,
            ),
          ),
        ],
      ),
    );
  }
}
