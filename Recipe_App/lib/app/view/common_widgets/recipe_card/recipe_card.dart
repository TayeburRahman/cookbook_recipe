import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

class RecipeCard extends StatelessWidget {
  final String name;
  final String description;
  final String prepTime;
  final String imageUrl;
  final double rating;

  const RecipeCard({
    super.key,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.prepTime,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Card Container
        _buildCardContainer(),
        // Positioned Image
        _buildImage(),
      ],
    );
  }

  // Container for the Recipe Card Content
  Widget _buildCardContainer() {
    return Container(
      width: 231,
      margin: const EdgeInsets.only(top: 60),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRecipeTitle(),
          _prep(),
          const SizedBox(height: 12),
          _buildRecipeDetails(),
        ],
      ),
    );
  }

  // Title Widget
  Widget _buildRecipeTitle() {
    return CustomText(
      top: 50,
      text: name,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.black,
    );
  }

  Widget _prep() {
    final timeStr = prepTime.replaceAll(RegExp(r'[^0-9]'), '');
    final display = timeStr.isNotEmpty ? "$timeStr mins" : prepTime;
    return Row(
      children: [
        const Icon(Icons.access_time_rounded, size: 12, color: Color(0xFF00A896)),
        const SizedBox(width: 4),
        CustomText(
          text: display,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF64748B),
        ),
      ],
    );
  }

  // Recipe Description and Rating Widget
  Widget _buildRecipeDetails() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildDescription(),
        ),
        const SizedBox(width: 8), // Space between description and rating
        _buildRating(),
      ],
    );
  }

  // Recipe Description Widget
  Widget _buildDescription() {
    final categories =
        description.split(', ').where((s) => s.isNotEmpty).toList();
    final displayedCategories = categories.take(2).toList();
    final remainingCount = categories.length - displayedCategories.length;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        ...displayedCategories.map((cat) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: AppColors.green.withValues(alpha: 0.2)),
              ),
              child: CustomText(
                text: cat
                        .replaceAll('-', ' ')
                        .replaceAll('_', ' ')
                        .capitalizeFirst ??
                    cat,
                fontWeight: FontWeight.w600,
                fontSize: 8,
                color: AppColors.green,
              ),
            )),
        if (remainingCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
            ),
            child: CustomText(
              text: "+$remainingCount more",
              fontWeight: FontWeight.w600,
              fontSize: 8,
              color: Colors.black,
            ),
          ),
      ],
    );
  }

  // Rating Widget
  Widget _buildRating() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 60),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: const BoxDecoration(
        color: AppColors.secondery20,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.orange, size: 16),
          const SizedBox(width: 4),
          Flexible(
            child: CustomText(
              textAlign: TextAlign.start,
              text: rating.toString(),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.black500,
            ),
          ),
        ],
      ),
    );
  }

  // Positioned Image Widget
  Widget _buildImage() {
    return Positioned(
      top: 0,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CustomNetworkImage(
            imageUrl: imageUrl,
            height: 123,
            width: 123,
            boxShape: BoxShape.circle,
          ),
        ],
      ),
    );
  }
}
