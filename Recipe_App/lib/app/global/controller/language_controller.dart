import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/global/helper/local_db/local_db.dart';
import 'package:recipe_app/app/utils/app_constants/app_constants.dart';

class LanguageController extends GetxController {
  RxBool isLanguage = false.obs;
  RxInt selectedCategory = 0.obs;
  TextEditingController language = TextEditingController();

  // Lang Function
  Future<void> initLangCheck() async {
    String valueLang = await SharePrefsHelper.getString(AppConstants.language);
    if (valueLang.isNotEmpty) {
      if (valueLang == "en") {
        language.text = "English";
        selectedCategory.value = 0;
      } else if (valueLang == "es") {
        language.text = "Spanish";
        selectedCategory.value = 1;
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    initLangCheck();
  }
}
