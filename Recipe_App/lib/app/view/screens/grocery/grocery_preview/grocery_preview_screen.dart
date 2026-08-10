import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';

import '../../../../models/grocery_model/grocery_model.dart';

class GroceryPreviewScreen extends StatelessWidget {
  final Map<String, dynamic>? extraData;
  const GroceryPreviewScreen({super.key, this.extraData});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = extraData ?? {};
    final plan = args['plan'];
    final List<dynamic>? meals = args['meals'];

    // Collect all ingredients that are selected (buy.value == true)
    List<Ingredient> selectedIngredients = [];
    if (meals != null) {
      for (var dayData in meals) {
        if (dayData.recipes != null) {
          for (var recipeElement in dayData.recipes) {
            if (recipeElement.ingredients != null) {
              for (var i in recipeElement.ingredients) {
                if (i.buy.value) {
                  selectedIngredients.add(i);
                }
              }
            }
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: "GROCERY PREVIEW",
        iconData: Icons.arrow_back_ios_new,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  CustomText(
                    text: (plan?.name ?? "SHOPPING LIST").toUpperCase(),
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff1B3B4A),
                    bottom: 10.h,
                  ),
                  Container(
                    width: double.infinity,
                    height: 2.h,
                    color: AppColors.green,
                    margin: EdgeInsets.only(bottom: 20.h),
                  ),
                  if (selectedIngredients.isEmpty)
                    Center(
                      child: CustomText(
                        text: "No items selected for grocery list",
                        top: 50.h,
                        fontSize: 16.sp,
                      ),
                    )
                  else
                    ...selectedIngredients.map((ingredient) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: const Color(0xffF3F3F3),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_box_outline_blank,
                                  color: AppColors.green, size: 18.sp),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: CustomText(
                                  text: ingredient.ingredient ?? "",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  color: const Color(0xff1B3B4A),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            ElevatedButton.icon(
              onPressed: () => _generatePdf(
                  plan?.name ?? "Grocery List", selectedIngredients),
              icon: const Icon(Icons.print, color: Colors.white, size: 18),
              label: Text("PRINT GROCERY PLAN",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generatePdf(
      String planName, List<Ingredient> ingredients) async {
    final pdf = pw.Document();

    // Load the logo image
    final ByteData logoData =
        await rootBundle.load('assets/icons/cover image-01.jpg');
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final pw.MemoryImage logoImage = pw.MemoryImage(logoBytes);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Image(logoImage, width: 100, height: 100),
              ],
            ),
          );
        },
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                planName.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex("#1B3B4A"),
                ),
              ),
            ),
            pw.Divider(thickness: 2, color: PdfColor.fromHex("#10AF99")),
            pw.SizedBox(height: 20),

            // Group ingredients (For now, since we don't have categories, we list them)
            // If we had categories, we would group by category here.
            pw.Text(
              "SHOPPING LIST",
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromHex("#1B3B4A"),
              ),
            ),
            pw.SizedBox(height: 10),

            // Split ingredients into 2 columns if list is long
            pw.Wrap(
              spacing: 20,
              runSpacing: 10,
              children: ingredients.map((item) {
                return pw.Container(
                  width: 250, // Roughly half page width
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 10,
                        height: 10,
                        margin: const pw.EdgeInsets.only(top: 2, right: 8),
                        decoration: pw.BoxDecoration(
                          border:
                              pw.Border.all(color: PdfColors.grey, width: 1),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          item.ingredient ?? "",
                          style: const pw.TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: "${planName.replaceAll(' ', '_')}_Grocery_List.pdf",
    );
  }
}
