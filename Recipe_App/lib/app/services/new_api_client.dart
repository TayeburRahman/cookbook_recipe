// api_client.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_app/app/services/error_response.dart';

import '../global/helper/local_db/local_db.dart';
import '../utils/app_constants/app_constants.dart';

class NewApiClient extends GetxService {

  static String bearerToken = "";
  static Future<Response> delete(String uri) async {
    bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);

    try {
      final response = await http.delete(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
      ).timeout(const Duration(seconds: 30));

      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: "Can't connect to the internet!");
    }
  }

  static Response handleResponse(http.Response response, String uri) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      debugPrint('❌ JSON Decode Error: $e');
    }

    Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );



    if (response0.statusCode != 200 &&
        response0.body != null &&
        response0.body is! String) {
      ErrorResponseNew errorResponse = ErrorResponseNew.fromJson(response0.body as Map<String, dynamic>);
      response0 = Response(
          statusCode: response0.statusCode,
          body: response0.body,
          statusText: errorResponse.message);
    } else if (response0.statusCode != 200 && response0.body == null) {
      response0 = const Response(statusCode: 0, statusText: "No Internet!");
    }

    debugPrint('====> API Response: [${response0.statusCode}] $uri\n${response0.body}');
    return response0;
  }
}
