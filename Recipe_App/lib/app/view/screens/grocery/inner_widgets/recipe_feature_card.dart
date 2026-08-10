import 'package:flutter/material.dart';
import 'package:recipe_app/app/utils/app_constants/app_constants.dart';
import 'package:recipe_app/app/view/common_widgets/custom_network_image/custom_network_image.dart';

class RecipeCard extends StatefulWidget {
  const RecipeCard({super.key});

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool isFirstItemSelected = false;
  bool isSecondItemSelected = false;

  // Function to toggle the visibility of the selected item
  void toggleFirstItemSelection(bool? value) {
    setState(() {
      isFirstItemSelected = value ?? false;
    });
  }

  void toggleSecondItemSelection(bool? value) {
    setState(() {
      isSecondItemSelected = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                CustomNetworkImage(
                  imageUrl: AppConstants.demoImage,
                  height: 117,
                  width: 118,
                ),
                const SizedBox(width: 16),
                // Text Section
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Breakfast',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Tropical Protein',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12),
                      // Ingredients list (with checkboxes)
                    ],
                  ),
                ),
              ],
            ),

            // Animated Checkboxes for Ingredients
            AnimatedOpacity(
              opacity: isFirstItemSelected ? 0 : 1,
              duration: const Duration(milliseconds: 500),
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('1 Scoop Pea Protein Powder'),
                value: isFirstItemSelected,
                onChanged: toggleFirstItemSelection,
              ),
            ),

            AnimatedOpacity(
              opacity: isSecondItemSelected ? 0 : 1,
              duration: const Duration(milliseconds: 500),
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('1 Cup Unsweetened Coconut Water'),
                value: isSecondItemSelected,
                onChanged: toggleSecondItemSelection,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
