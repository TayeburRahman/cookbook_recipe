import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import '../controller/meal_plan_controller.dart';

class MealPlanPreviewScreen extends StatelessWidget {
  const MealPlanPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MealPlanController controller = Get.find<MealPlanController>();
    final plan = controller.selectedCustomPlanList;
    final meals = controller.weeklyMealPlanData.value.data;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: "PLAN PREVIEW",
        iconData: Icons.arrow_back_ios_new,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: meals?.length ?? 0,
                itemBuilder: (context, index) {
                  final dayData = meals![index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: const Color(0xffF3F3F3),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: CustomText(
                          text: dayData.day?.toUpperCase() ?? "",
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                          color: const Color(0xff1B3B4A),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      ...(dayData.recipes ?? []).where((e) => e.recipe != null).map((recipeElement) {
                            final recipe = recipeElement.recipe!;
                            return Padding(
                              padding:
                                  EdgeInsets.only(bottom: 12.h, left: 16.w),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xffF3F3F3),
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: recipe.name ?? "",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.sp,
                                      color: const Color(0xff1B3B4A),
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.visible,
                                    ),
                                    SizedBox(height: 4.h),
                                    () {
                                      final cats = (recipe.category ?? [])
                                          .where((s) => s.isNotEmpty)
                                          .toList();
                                      final displayedCats = cats.take(2).toList();
                                      final remaining =
                                          cats.length - displayedCats.length;

                                      return Wrap(
                                        spacing: 4.w,
                                        runSpacing: 4.h,
                                        children: [
                                          ...displayedCats.map((cat) =>
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.w,
                                                    vertical: 2.h),
                                                decoration: BoxDecoration(
                                                  color: AppColors.green
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  border: Border.all(
                                                      color: AppColors.green
                                                          .withValues(
                                                              alpha: 0.2)),
                                                ),
                                                child: CustomText(
                                                  text: cat
                                                          .replaceAll('-', ' ')
                                                          .replaceAll('_', ' ')
                                                          .capitalizeFirst ??
                                                      cat,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 8.sp,
                                                  color: AppColors.green,
                                                ),
                                              )),
                                          if (remaining > 0)
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 2.h),
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withValues(alpha: 0.05),
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                border: Border.all(
                                                    color: Colors.black
                                                        .withValues(
                                                            alpha: 0.1)),
                                              ),
                                              child: CustomText(
                                                text: "+$remaining more",
                                                fontWeight: FontWeight.w600,
                                                fontSize: 8.sp,
                                                color: Colors.black,
                                              ),
                                            ),
                                        ],
                                      );
                                    }(),
                                  ],
                                ),
                              ),
                            );
                          }),
                      SizedBox(height: 15.h),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 12.h),
            ElevatedButton.icon(
              onPressed: () => _generatePdf(plan?.name ?? "Meal Plan", meals),
              icon: const Icon(Icons.print, color: Colors.white, size: 18),
              label: Text("PRINT MEAL PLAN",
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

  Future<void> _generatePdf(String planName, List<dynamic>? meals,
      {bool isShare = false}) async {
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
            // margin: const pw.EdgeInsets.only(top: 0.5 * PdfPageFormat.cm),
            child: pw.Column(
              // mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Image(logoImage, width: 150, height: 150),
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
            ...(meals ?? []).map((dayData) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex("#EDF4ED"),
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Text(
                      dayData.day?.toUpperCase() ?? "",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                        color: PdfColor.fromHex("#1B3B4A"),
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  ...(dayData.recipes as List? ?? [])
                      .where((e) => e.recipe != null)
                      .map((recipeElement) {
                    final recipe = recipeElement.recipe;
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 15, bottom: 5),
                      child: pw.Row(
                        children: [
                          pw.Container(
                            width: 5,
                            height: 5,
                            margin: const pw.EdgeInsets.only(top: 5),
                            decoration: const pw.BoxDecoration(
                              color: PdfColors.green,
                              shape: pw.BoxShape.circle,
                            ),
                          ),
                          pw.SizedBox(width: 10),
                          pw.Expanded(
                            child: pw.Text(
                              "${recipe?.category?.join(", ").toUpperCase() ?? ""}: ${recipe?.name ?? ""}",
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  pw.SizedBox(height: 15),
                ],
              );
            }).toList(),
          ];
        },
      ),
    );

    if (isShare) {
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: "${planName.replaceAll(' ', '_')}_Meal_Plan.pdf",
      );
    } else {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: "${planName.replaceAll(' ', '_')}_Meal_Plan.pdf",
      );
    }
  }
}
