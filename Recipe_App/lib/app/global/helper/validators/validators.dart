import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:intl/intl.dart';

class Validators {
  //>>>>>>>✅✅ EmailValidator ✅✅ <<<<<<<<=============
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!GetUtils.isEmail(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  //>>>>>>>✅✅ PasswordValidator ✅✅ <<<<<<<<=============
  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  //>>>>>>>✅✅ Confirm PasswordValidator ✅✅ <<<<<<<<=============
  static String? confirmPasswordValidator(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    } else if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  //>>>>>>>✅✅ NameValidator ✅✅ <<<<<<<<=============
  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Only alphabetic characters and spaces are allowed';
    }
    return null;
  }

  //>>>>>>>✅✅ Subject ✅✅ <<<<<<<<=============
  static String? subject(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Subject';
    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Only alphabetic characters and spaces are allowed';
    }
    return null;
  }

  //>>>>>>>✅✅ PhoneNumberValidator ✅✅ <<<<<<<<=============
  static String? phoneNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    } else if (!RegExp(r'^(?:\+88|88)?01[1-9]\d{8}$').hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  //>>>>>>>✅✅ Date of Birth ✅✅ <<<<<<<<=============
  static String? dateOFBirth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your date of birth';
    }
    // Validate if the entered text is a valid date
    try {
      DateFormat('yyyy-MM-dd').parseStrict(value); // Example date format
    } catch (e) {
      return 'Please enter a valid date in the format yyyy-MM-dd';
    }
    return null;
  }

  //>>>>>>>✅✅ RecipeName ✅✅ <<<<<<<<=============
  static String? recipeName(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Recipe Name";
    }
    return null;
  }

  //>>>>>>>✅✅ instructions ✅✅ <<<<<<<<=============
  static String? instructions(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter instructions Name";
    }
    return null;
  }

  //>>>>>>>✅✅ Prep Time ✅✅ <<<<<<<<=============
  static String? prepTime(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Prep Time";
    }
    return null;
  }

  //>>>>>>>✅✅ Recipe Tips ✅✅ <<<<<<<<=============
  static String? recipeTips(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter your tips";
    }
    return null;
  }
}
