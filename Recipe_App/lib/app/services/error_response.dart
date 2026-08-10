import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';

class ErrorResponse {
  final String? status;
  final int? statusCode;
  final String? message;

  ErrorResponse({
    this.status,
    this.statusCode,
    this.message,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        status: json["status"],
        statusCode: json["statusCode"],
        message: json["message"],
      );
}

class ErrorResponseNew {
  final String message;

  ErrorResponseNew({required this.message});

  factory ErrorResponseNew.fromJson(Map<String, dynamic> json) {
    return ErrorResponseNew(message: json['message'] ?? 'Something went wrong');
  }
}

void snackBar(String message, {bool isError = true}) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: isError ? Colors.red : AppColors.green,
    textColor: Colors.white,
    gravity: ToastGravity.BOTTOM,
    toastLength: Toast.LENGTH_LONG,
  );
}
