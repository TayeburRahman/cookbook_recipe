import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/global/controller/genarel_controller.dart';
import 'package:recipe_app/app/global/helper/validators/validators.dart';
import 'package:recipe_app/app/models/my_recipe/my_recipe_model.dart'
    show MyRecipeList;
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:recipe_app/app/view/common_widgets/custom_drop_down/custom_drop_down.dart';
import 'package:recipe_app/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:recipe_app/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:recipe_app/app/view/common_widgets/custom_radio_group/custom_radio_group.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:recipe_app/app/view/screens/profile_screen/my_recipe/controller/my_recipe_controller.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({
    super.key,
    required this.data,
  });

  final MyRecipeList? data;

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final MyRecipeController controller = Get.find<MyRecipeController>();

  final GeneralController generalController = Get.find<GeneralController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Initialize ALL controllers to prevent LateInitializationError

    // ... initialize others like category, flavor, etc.

    if (widget.data != null) {
      controller.recipeNameController.text = widget.data?.name ?? '';
      controller.instructionsController.text = widget.data?.instructions ?? '';
      controller.caloriesController.text =
          widget.data?.nutritional?.calories?.toString() ?? '';
      controller.fatController.text =
          widget.data?.nutritional?.fat?.toString() ?? '';
      controller.proteinController.text =
          widget.data?.nutritional?.protein?.toString() ?? '';
      controller.fiberController.text =
          widget.data?.nutritional?.fiber?.toString() ?? '';
      controller.carbsController.text =
          widget.data?.nutritional?.carbs?.toString() ?? '';
      controller.prepTimeController.text =
          widget.data?.prepTime?.toString() ?? "";
      controller.recipeTipsController.text =
          widget.data?.recipeTips?.toString() ?? "";
      // oils
      controller.selectedOption.value = widget.data?.oils ?? "";
      controller.selectedTemperature.value =
          widget.data?.servingTemperature ?? "";
      controller.selectedFlavor.value = widget.data?.flavor ?? "";
      controller.lossGain.value = widget.data?.weightAndMuscle ?? "";
      controller.foodType.value = widget.data?.wholeFoodType ?? "";
      controller.selectedSizeTime.value =
          widget.data?.servingSize.toString() ?? "";
      if (widget.data?.category?.isNotEmpty ?? false) {
        controller.selectedCategory.value = widget.data!.category!.join(", ");
        // Try to find the ID of the first category for the dropdown state
        final firstCat = widget.data!.category!.first;
        final catObj = controller.allCategoryList.firstWhereOrNull(
          (e) => e.name == firstCat || e.slug == firstCat || e.id == firstCat,
        );
        controller.selectedCategoryId.value = catObj?.id ?? "";
      }
      controller.selectedHolidayRecipes.value =
          widget.data?.holidayRecipes.toString() ?? "";

      // Api Send Value Set
      controller.categoryController.text =
          widget.data?.category?.join(", ") ?? "";
      controller.holidayRecipesController.text =
          widget.data?.holidayRecipes.toString() ?? "";
      controller.oilsController.text = widget.data?.oils.toString() ?? "";
      controller.servingTemperatureController.text =
          widget.data?.servingTemperature.toString() ?? "";
      controller.flavorController.text = widget.data?.flavor.toString() ?? "";
      controller.weightLossController.text =
          widget.data?.weightAndMuscle.toString() ?? "";
      controller.wholeFoodTypeController.text =
          widget.data?.wholeFoodType.toString() ?? "";
      controller.servingSizeController.text =
          widget.data?.servingSize.toString() ?? "";
      controller.prepTimeController.text =
          widget.data?.prepTime.toString() ?? "";
      controller.recipeTipsController.text =
          widget.data?.recipeTips.toString() ?? "";

      if (widget.data?.image != null) {
        // Set the string path variable that the update function uses
        generalController.imageFile.value = File("");
      }
      if (widget.data?.ingredients?.isNotEmpty ?? false) {
        controller.ingredientsList.assignAll(widget.data!.ingredients!);
      }
    }
  }

  @override
  void dispose() {
    // Dispose of the controller properly only in the widget's lifecycle
    // controller.recipeNameController.dispose();
    controller.resetControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "Name==========================================> ${widget.data?.name ?? ""}");
    debugPrint(
        "Id==========================================> ${widget.data?.id ?? ""}");

    debugPrint(
        "Image==========================================> ${widget.data?.image ?? ""}");
    debugPrint("Image Path: ${generalController.imageFile.value.path}");

    return Scaffold(
      backgroundColor: AppColors.white,

      ///============================ Header ===============================
      appBar: CustomAppBar(
        appBarContent:
            widget.data == null ? AppStrings.addRecipe : "Edit Recipe".tr,
        iconData: Icons.arrow_back,
        appBarBgColor: AppColors.white,
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Obx(() {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: AppStrings.photos.tr,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.green,
                    bottom: 10.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      generalController.selectImage();
                      generalController.update();
                      debugPrint(
                          "============${generalController.selectImage()}");
                      log("Ajay Value Check ${generalController.imageFile.value}");
                    },
                    child: SizedBox(
                      width: 100.w,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(15.r),
                        color: AppColors.gray,
                        strokeWidth: 2,
                        padding: EdgeInsets.all(20.r),
                        child: Center(
                          child: generalController
                                  .imageFile.value.path.isNotEmpty
                              ? Image.file(
                                  generalController.imageFile.value,
                                  fit: BoxFit.cover,
                                )
                              : (widget.data?.image != null &&
                                      widget.data!.image!.isNotEmpty)
                                  ? Image.network(
                                      "${widget.data!.image}",
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image),
                                    )
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.add),
                                        CustomText(
                                          text: AppStrings.add.tr,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.green,
                                        ),
                                      ],
                                    ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10.h,
                  ),

                  ///================Recipe Name==================
                  CustomFromCard(
                      title: AppStrings.recipeName.tr,
                      hinText: "Enter recipe name",
                      controller: controller.recipeNameController,
                      validator: Validators.recipeName),

                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Ingredient Input Field
                          Expanded(
                            flex: 3,
                            child: CustomTextField(
                              inputTextStyle:
                                  const TextStyle(color: AppColors.black),
                              hintText: "Enter Ingredient",
                              textEditingController:
                                  controller.ingredientsController,
                            ),
                          ),
                          const SizedBox(width: 20),

                          /// Add Ingredient Button
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: AppColors.gray,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                textStyle: const TextStyle(fontSize: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                              onPressed: controller.addIngredient,
                              child: const Icon(
                                Icons.add,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: controller.ingredientsList.map((ingredient) {
                          return Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Container(
                                    height: 64,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.gray,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      ingredient,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 18),

                              /// Remove Ingredient Button
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: AppColors.gray,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    textStyle: const TextStyle(fontSize: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                  onPressed: () {
                                    controller.removeIngredient(ingredient);
                                  },
                                  child: const Icon(
                                    Icons.remove,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                  ///================Instructions==================
                  CustomFromCard(
                      hinText: "Enter instruction",
                      title: AppStrings.instructions.tr,
                      maxLine: 8,
                      controller: controller.instructionsController,
                      validator: Validators.instructions),

                  DataTable(
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Unit/Gram')),
                    ],
                    rows: [
                      _buildDataRow("Calories", controller.caloriesController),
                      _buildDataRow("Fat", controller.fatController),
                      _buildDataRow("Protein", controller.proteinController),
                      _buildDataRow("Fiber", controller.fiberController),
                      _buildDataRow("Carbs", controller.carbsController),
                    ],
                  ),
                  SizedBox(
                    height: 12.h,
                  ),

                  ///================Category==================
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(AppStrings.category.tr,
                  //         style: const TextStyle(
                  //             fontSize: 18,
                  //             fontWeight: FontWeight.w400,
                  //             color: Colors.black)),
                  //     const SizedBox(height: 8),
                  //     Obx(() => GestureDetector(
                  //           onTap: () {
                  //             controller.toggleDropdown(controller.isCategory);
                  //           },
                  //           child: TextField(
                  //             decoration: InputDecoration(
                  //               hintText: controller.selectedCategory.value,
                  //               suffixIcon: IconButton(
                  //                 onPressed: () {
                  //                   controller
                  //                       .toggleDropdown(controller.isCategory);
                  //                 },
                  //                 icon: const Icon(Icons.arrow_drop_down_sharp),
                  //               ),
                  //               border: OutlineInputBorder(
                  //                   borderRadius: BorderRadius.circular(10)),
                  //             ),
                  //             readOnly: true,
                  //           ),
                  //         )),
                  //     Obx(() => controller.isCategory.value
                  //         ? Container(
                  //             margin: const EdgeInsets.only(top: 8),
                  //             padding: const EdgeInsets.all(8),
                  //             decoration: BoxDecoration(
                  //               color: Colors.white,
                  //               border: Border.all(color: Colors.grey),
                  //               borderRadius: BorderRadius.circular(10),
                  //               boxShadow: const [
                  //                 BoxShadow(
                  //                     color: Colors.black26,
                  //                     blurRadius: 4,
                  //                     offset: Offset(0, 2)),
                  //               ],
                  //             ),
                  //             child: Column(
                  //               children: controller.category
                  //                   .map((item) => InkWell(
                  //                         onTap: () {
                  //                           controller.selectItem(
                  //                             item.name ?? "",
                  //                             controller.selectedCategory,
                  //                             controller.isCategory,
                  //                             controller.categoryController,
                  //                           );
                  //                         },
                  //                         child: Padding(
                  //                           padding: const EdgeInsets.symmetric(
                  //                               vertical: 8),
                  //                           child: Column(
                  //                             children: [
                  //                               Text(item.name ?? "",
                  //                                   style: const TextStyle(
                  //                                       fontSize: 16,
                  //                                       fontWeight:
                  //                                           FontWeight.w500)),
                  //                               if (controller.category
                  //                                       .indexOf(item) !=
                  //                                   controller.category.length -
                  //                                       1)
                  //                                 const Divider(),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ))
                  //                   .toList(),
                  //             ),
                  //           )
                  //         : const SizedBox()),
                  //   ],
                  // ),
                  if (controller.category.isNotEmpty)
                    CustomDropdown(
                      title: AppStrings.category.tr,
                      selectedValue: controller.selectedCategory,
                      isDropdownOpen: controller.isCategory,
                      items: controller.category,
                      onToggle: () {
                        controller.toggleDropdown(controller.isCategory);
                      },
                      onSelect: (item) {
                        controller.selectItem(
                          item,
                          controller.selectedCategory,
                          controller.isCategory,
                          controller.categoryController,
                        );
                      },
                    ),
                  if (controller.category.isEmpty)
                    const CustomText(
                      // text: "Ajay ${controller.allCategoryList.length}",
                      text: AppStrings.noDataFound,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  SizedBox(height: 20.h),

                  ///================Ethnic/Holiday Recipes==================
                  CustomDropdown(
                    title: "Ethnic/Holiday Recipes",
                    selectedValue: controller.selectedHolidayRecipes,
                    isDropdownOpen: controller.isHoliday,
                    items: controller.holidays,
                    onToggle: () =>
                        controller.toggleDropdown(controller.isHoliday),
                    onSelect: (item) => controller.selectItem(
                      item,
                      controller.selectedHolidayRecipes,
                      controller.isHoliday,
                      controller.holidayRecipesController,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  ///================Oils==================
                  // Oils Radio Group
                  CustomRadioGroup<String>(
                    title: "Oils",
                    selectedValue: controller.selectedOption,
                    options: controller.oils,
                    onSelectionChanged: (value) {
                      controller.changeSelection(value);
                    },
                  ),

                  ///================Serving Temperature==================
                  CustomRadioGroup<String>(
                    title: "Serving Temperature",
                    selectedValue: controller.selectedTemperature,
                    options: controller.servingTemperature,
                    onSelectionChanged: (value) {
                      controller.changeTemperatureSelection(value);
                    },
                  ),

                  ///================Flavor==================
                  CustomRadioGroup<String>(
                    title: "Flavor",
                    selectedValue: controller.selectedFlavor,
                    options: controller.servingFlavor,
                    onSelectionChanged: (value) {
                      controller.changeFlavorSelection(value);
                    },
                  ),

                  ///================Weight Loss vs. Muscle Gain==================
                  CustomRadioGroup<String>(
                    title: "Weight Loss vs. Muscle Gain",
                    selectedValue: controller.lossGain,
                    options: controller.lossGainList,
                    onSelectionChanged: (value) {
                      controller.changeLossSelection(value);
                    },
                  ),

                  ///================Whole Food Type==================
                  CustomRadioGroup<String>(
                    title: "Whole Food Type",
                    selectedValue: controller.foodType,
                    options: controller.foodTypeList,
                    onSelectionChanged: (value) {
                      controller.changeFoodType(value);
                    },
                  ),

                  ///================Serving Size==================
                  CustomDropdown(
                    title: "Serving Size",
                    selectedValue: controller.selectedSizeTime,
                    isDropdownOpen: controller.isSizeDropdownOpen,
                    items: controller.sizes,
                    onToggle: () => controller
                        .toggleDropdown(controller.isSizeDropdownOpen),
                    onSelect: (item) => controller.selectItem(
                      item,
                      controller.selectedSizeTime,
                      controller.isSizeDropdownOpen,
                      controller.servingSizeController,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  ///================Prep Tips==================
                  CustomFromCard(
                      isKeyBordType: true,
                      hinText: "Enter your prep Time",
                      title: "Prep Time",
                      controller: controller.prepTimeController,
                      validator: Validators.prepTime),
                  SizedBox(height: 20.h),

                  ///================Recipe Tips==================
                  CustomFromCard(
                      hinText: "Enter your tips",
                      title: 'Recipe Tips',
                      maxLine: 8,
                      controller: controller.recipeTipsController,
                      validator: Validators.recipeTips),

                  SizedBox(
                    height: 20.h,
                  ),
                  widget.data == null
                      ? controller.isRecipeCreate.value
                          ? const CustomLoader()
                          : Padding(
                              padding: const EdgeInsets.all(15),
                              child: CustomButton(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    controller.recipeCreate(context);
                                  }
                                },
                                title: AppStrings.save.tr,
                              ),
                            )
                      : controller.isRecipeEdit.value
                          ? const CustomLoader()
                          : Padding(
                              padding: const EdgeInsets.all(15),
                              child: CustomButton(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    controller.recipeUpdate(
                                        id: widget.data?.id ?? "",
                                        context: context);
                                  }
                                },
                                title: "Update".tr,
                              ),
                            )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  // A function to build each row dynamically
  DataRow _buildDataRow(String name, TextEditingController controller) {
    return DataRow(
      cells: [
        DataCell(Text(
          name,
          style: const TextStyle(color: AppColors.green, fontSize: 22),
        )),
        DataCell(
          TextField(
            controller: controller,
            keyboardType: TextInputType.number, // Ensures numeric input
            decoration: const InputDecoration(
              hintText: 'Enter grams',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 0, horizontal: 36), // Adjust padding here
            ),
          ),
        ),
      ],
    );
  }
}
