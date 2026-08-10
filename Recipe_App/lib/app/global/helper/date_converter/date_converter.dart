import 'package:intl/intl.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';

class DateConverter {
  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static String estimatedDates(DateTime? dateTime) {
    if (dateTime == null) {
      return AppStrings.noDateProvided; // Or any default message
    }
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  ///=============== Calculate Time of Day ===============

  static String getTimePeriod() {
    // Get the current hour of the day
    int currentHour = DateTime.now().hour;

    // Define the boundaries for morning, noon, and evening
    int morningBoundary = 6;
    int noonBoundary = 12;
    int eveningBoundary = 18;

    // Determine the time period based on the current hour
    if (currentHour >= morningBoundary && currentHour < noonBoundary) {
      return AppStrings.goodMorning;
    } else if (currentHour >= noonBoundary && currentHour < eveningBoundary) {
      return AppStrings.goodNoon;
    } else {
      return AppStrings.goodEvening;
    }
  }

  static String getGreetingMessage() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return AppStrings.goodMorning;
    } else if (hour < 17) {
      return AppStrings.goodAfternoon;
    } else {
      return AppStrings.goodEvening;
    }
  }

  static String formatDateTimeToGmtPlus6(String isoDateString) {
    DateTime utcDateTime = DateTime.parse(isoDateString).toUtc();

    DateTime gmtPlus6DateTime = utcDateTime.add(const Duration(hours: 6));

    String formattedTime = DateFormat.jm().format(gmtPlus6DateTime);

    return formattedTime;
  }
}
