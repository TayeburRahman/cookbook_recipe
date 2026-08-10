import 'package:get/get.dart';

import 'english.dart';
import 'spanish.dart';

class Language extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "en_US": english,
        "es_ES": spanish,
      };
}
