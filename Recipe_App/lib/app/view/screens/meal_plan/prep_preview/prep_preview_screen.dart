import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:recipe_app/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:recipe_app/app/view/screens/meal_plan/models/weekly_meal_plan_model.dart';
import 'package:recipe_app/app/view/screens/weekend_prep/models/weekend_prep_model.dart';

class PrepPreviewScreen extends StatelessWidget {
  final Map<String, dynamic>? extraData;
  const PrepPreviewScreen({super.key, this.extraData});

  String _getPlanName(dynamic plan) {
    if (plan == null) return "PREP PLAN";
    try {
      if (plan is Map) {
        return plan['name']?.toString() ??
            plan['weekName']?.toString() ??
            plan['week_name']?.toString() ??
            "PREP PLAN";
      }
      // Use dynamic access with a try-catch for safety across different model types
      return (plan.name as String?) ??
          (plan.weekName as String?) ??
          "PREP PLAN";
    } catch (e) {
      return "PREP PLAN";
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = extraData ?? {};
    final plan = args['plan'];
    final List<dynamic>? rawMeals = args['meals'];
    final List<Datum> meals = rawMeals?.whereType<Datum>().toList() ?? [];
    final dynamic rawWeekendData = args['weekendPrepData'];
    final WeekendPrepData? weekendPrepData = rawWeekendData is WeekendPrepData
        ? rawWeekendData
        : (rawWeekendData != null
            ? WeekendPrepData.fromJson(rawWeekendData is String
                ? jsonDecode(rawWeekendData)
                : rawWeekendData)
            : null);

    final String planTitle = _getPlanName(plan);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: "PREP PREVIEW",
        iconData: Icons.arrow_back_ios_new,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    CustomText(
                      text: planTitle.toUpperCase(),
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
                    if (meals.isEmpty && weekendPrepData == null)
                      Center(
                        child: CustomText(
                          text: "No prep data available",
                          top: 50.h,
                          fontSize: 16.sp,
                        ),
                      )
                    else if (meals.isNotEmpty)
                      ...meals.map((Datum dayData) {
                        final List<RecipeElement> validRecipes = dayData.recipes
                                ?.where((el) =>
                                    el.recipe != null &&
                                    el.recipe!.prep != null &&
                                    el.recipe!.prep!.trim().isNotEmpty)
                                .toList() ??
                            [];

                        if (validRecipes.isEmpty) return const SizedBox();

                        final Map<String, List<RecipeElement>>
                            groupedByCategory = {};
                        for (var element in validRecipes) {
                          final category =
                              element.recipe!.category?.join(", ").capitalize ??
                                  "N/A";
                          if (!groupedByCategory.containsKey(category)) {
                            groupedByCategory[category] = [];
                          }
                          groupedByCategory[category]!.add(element);
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...groupedByCategory.entries.map((entry) {
                              final categoryName = entry.key;
                              final recipesInCategory = entry.value;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 8.h),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffEDF4ED),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: CustomText(
                                      text: categoryName
                                          .toString()
                                          .replaceAll('-', ' ')
                                          .replaceAll('_', ' ')
                                          .toUpperCase(),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.sp,
                                      color: const Color(0xff1B3B4A),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  ...recipesInCategory
                                      .map((RecipeElement element) {
                                    final RecipeRecipe recipe = element.recipe!;
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 12.h, left: 16.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            fontWeight: FontWeight.w600,
                                            text: recipe.name ?? "",
                                            color: const Color(0xff1B3B4A),
                                            fontSize: 14.sp,
                                            bottom: 6.h,
                                          ),
                                          CustomText(
                                            textAlign: TextAlign.start,
                                            maxLines: 100,
                                            text: recipe.prep!,
                                            color: AppColors.black,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  SizedBox(height: 12.h),
                                ],
                              );
                            }),
                          ],
                        );
                      })
                    else if (weekendPrepData != null) ...[
                      if (weekendPrepData.sections != null &&
                          weekendPrepData.sections!.isNotEmpty)
                        ...weekendPrepData.sections!.map((section) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 8.h),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffEDF4ED),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: CustomText(
                                    text: (section.title ?? "").toUpperCase(),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp,
                                    color: const Color(0xff1B3B4A),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                if (section.items != null)
                                  ...section.items!.map((item) => Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 12.h, left: 16.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              fontWeight: FontWeight.w600,
                                              text: item.name ?? "",
                                              color: const Color(0xff1B3B4A),
                                              fontSize: 14.sp,
                                              bottom: 4.h,
                                            ),
                                            if (item.amount != null &&
                                                item.amount!.isNotEmpty)
                                              CustomText(
                                                text: "Amount: ${item.amount}",
                                                fontSize: 13.sp,
                                                bottom: 2.h,
                                              ),
                                            CustomText(
                                              textAlign: TextAlign.start,
                                              maxLines: 100,
                                              text: item.instruction ?? "",
                                              color: AppColors.black,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ],
                                        ),
                                      )),
                                SizedBox(height: 12.h),
                              ],
                            )),
                      if (weekendPrepData.speedPrep != null &&
                          weekendPrepData.speedPrep!.isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: const Color(0xffEDF4ED),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: CustomText(
                            text: "SPEED PREP",
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                            color: const Color(0xff1B3B4A),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ...weekendPrepData.speedPrep!.map((speed) => Padding(
                              padding:
                                  EdgeInsets.only(bottom: 15.h, left: 16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: speed.ingredient?.toUpperCase() ?? "",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp,
                                    bottom: 5.h,
                                    color: AppColors.grey1,
                                  ),
                                  if (speed.steps != null)
                                    ...speed.steps!.map((step) => Padding(
                                          padding: EdgeInsets.only(bottom: 4.h),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.check_box_outline_blank,
                                                size: 14.sp,
                                                color: AppColors.grey1,
                                              ),
                                              SizedBox(width: 8.w),
                                              Expanded(
                                                  child: CustomText(
                                                text: step.text ?? "",
                                                fontSize: 12.sp,
                                                textAlign: TextAlign.start,
                                                color: AppColors.grey1,
                                              )),
                                            ],
                                          ),
                                        )),
                                ],
                              ),
                            )),
                      ],
                      if (weekendPrepData.prepNotes != null &&
                          weekendPrepData.prepNotes!.isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: const Color(0xffEDF4ED),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: CustomText(
                            text: "PREP NOTES",
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                            color: const Color(0xff1B3B4A),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ...weekendPrepData.prepNotes!.map((note) => Padding(
                              padding: EdgeInsets.only(bottom: 8.h, left: 16.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                      text: "• ",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp),
                                  Expanded(
                                      child: CustomText(
                                          text: note,
                                          fontSize: 13.sp,
                                          textAlign: TextAlign.start,
                                          maxLines: 10)),
                                ],
                              ),
                            )),
                      ],
                    ]
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              ElevatedButton.icon(
                onPressed: () =>
                    _generatePdf(planTitle, meals, weekendPrepData),
                icon: const Icon(Icons.print, color: Colors.white, size: 18),
                label: Text("PRINT PREP PLAN",
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
      ),
    );
  }

  Future<void> _generatePdf(String planName, List<Datum>? meals,
      [dynamic weekendPrepData]) async {
    final pdf = pw.Document();

    pw.MemoryImage? logoImage;
    try {
      final ByteData logoData =
          await rootBundle.load('assets/icons/cover image-01.jpg');
      final Uint8List logoBytes = logoData.buffer.asUint8List();
      logoImage = pw.MemoryImage(logoBytes);
    } catch (e) {
      debugPrint("Logo asset load error for PDF: $e");
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        footer: (pw.Context context) {
          if (logoImage == null) return pw.SizedBox();
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            child: pw.Image(logoImage, width: 80, height: 80),
          );
        },
        build: (pw.Context context) {
          final List<pw.Widget> content = [];

          content.add(
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
          );

          content.add(
              pw.Divider(thickness: 2, color: PdfColor.fromHex("#10AF99")));
          content.add(pw.SizedBox(height: 20));

          if (meals != null && meals.isNotEmpty) {
            for (var dayData in meals) {
              final List<RecipeElement> validRecipes = dayData.recipes
                      ?.where((element) =>
                          element.recipe != null &&
                          element.recipe!.prep != null &&
                          element.recipe!.prep!.trim().isNotEmpty)
                      .toList() ??
                  [];

              if (validRecipes.isEmpty) continue;

              final Map<String, List<RecipeElement>> groupedByCategory = {};
              for (var element in validRecipes) {
                final category =
                    element.recipe!.category?.join(", ").toUpperCase() ?? "N/A";
                final capitalizedCategory = category.isEmpty
                    ? category
                    : "${category[0].toUpperCase()}${category.substring(1).toLowerCase()}";

                if (!groupedByCategory.containsKey(capitalizedCategory)) {
                  groupedByCategory[capitalizedCategory] = [];
                }
                groupedByCategory[capitalizedCategory]!.add(element);
              }

              for (var entry in groupedByCategory.entries) {
                final categoryName = entry.key;
                final recipesInCategory = entry.value;

                content.add(
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex("#EDF4ED"),
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Text(
                      categoryName
                          .toUpperCase()
                          .replaceAll('-', ' ')
                          .replaceAll('_', ' '),
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex("#1B3B4A"),
                        fontSize: 10,
                      ),
                    ),
                  ),
                );

                content.add(pw.SizedBox(height: 10));

                for (var element in recipesInCategory) {
                  final recipe = element.recipe!;
                  content.add(
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 15, bottom: 15),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            recipe.name ?? "",
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 12,
                              color: PdfColor.fromHex("#1B3B4A"),
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            recipe.prep!,
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                content.add(pw.SizedBox(height: 10));
              }
            }
          } else if (weekendPrepData != null) {
            final WeekendPrepData data = weekendPrepData is WeekendPrepData
                ? weekendPrepData
                : WeekendPrepData.fromJson(weekendPrepData);

            if (data.sections != null) {
              for (var section in data.sections!) {
                content.add(
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex("#EDF4ED"),
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Text(
                      (section.title ?? "").toUpperCase(),
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex("#1B3B4A"),
                        fontSize: 10,
                      ),
                    ),
                  ),
                );
                content.add(pw.SizedBox(height: 10));
                if (section.items != null) {
                  for (var item in section.items!) {
                    content.add(
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 15, bottom: 15),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              item.name ?? "",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 12,
                                color: PdfColor.fromHex("#1B3B4A"),
                              ),
                            ),
                            if (item.amount != null && item.amount!.isNotEmpty)
                              pw.Text(
                                "Amount: ${item.amount}",
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontStyle: pw.FontStyle.italic),
                              ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              item.instruction ?? "",
                              style: const pw.TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
              }
            }

            if (data.speedPrep != null && data.speedPrep!.isNotEmpty) {
              content.add(
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex("#EDF4ED"),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    "SPEED PREP",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex("#1B3B4A"),
                      fontSize: 10,
                    ),
                  ),
                ),
              );
              content.add(pw.SizedBox(height: 10));
              for (var speed in data.speedPrep!) {
                content.add(
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 15, bottom: 10),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(speed.ingredient?.toUpperCase() ?? "",
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 11)),
                        if (speed.steps != null)
                          ...speed.steps!.map((step) => pw.Padding(
                                padding:
                                    const pw.EdgeInsets.only(top: 4, left: 10),
                                child: pw.Row(
                                  children: [
                                    pw.Container(
                                        width: 8,
                                        height: 8,
                                        decoration: pw.BoxDecoration(
                                            shape: pw.BoxShape.circle,
                                            border: pw.Border.all(width: 1))),
                                    pw.SizedBox(width: 5),
                                    pw.Expanded(
                                        child: pw.Text(step.text ?? "",
                                            style: const pw.TextStyle(
                                                fontSize: 9))),
                                  ],
                                ),
                              )),
                      ],
                    ),
                  ),
                );
              }
            }

            if (data.prepNotes != null && data.prepNotes!.isNotEmpty) {
              content.add(pw.SizedBox(height: 10));
              content.add(
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex("#EDF4ED"),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    "PREP NOTES",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex("#1B3B4A"),
                      fontSize: 10,
                    ),
                  ),
                ),
              );
              content.add(pw.SizedBox(height: 10));
              for (var note in data.prepNotes!) {
                content.add(
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 15, bottom: 5),
                    child: pw.Text("• $note",
                        style: const pw.TextStyle(fontSize: 10)),
                  ),
                );
              }
            }
          }

          return content;
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: "${planName.replaceAll(' ', '_')}_Prep_Plan.pdf",
    );
  }
}
