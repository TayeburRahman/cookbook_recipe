import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_app/app/global/helper/local_db/local_db.dart';
import 'package:recipe_app/app/utils/app_constants/app_constants.dart';

import '../../../../services/app_url.dart';

class DeleteApiClient {
  static const int timeoutInSeconds = 30;

  /// Preferred: Real DELETE
  static Future<Response> delete(String uri,
      {Map<String, String>? headers}) async {
    debugPrint('====> DELETE API: Entered delete() method');

    try {
      final bearerToken =
          await SharePrefsHelper.getString(AppConstants.bearerToken);
      final defaultHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearerToken',
      };

      final mergedHeaders = {
        ...defaultHeaders,
        ...?headers,
      };

      final fullUrl = ApiUrl.baseUrl + uri;
      debugPrint('====> Full URL: $fullUrl');

      final http.Response rawResponse = await http
          .delete(Uri.parse(fullUrl), headers: mergedHeaders)
          .timeout(const Duration(seconds: timeoutInSeconds));

      dynamic body;
      try {
        body =
            rawResponse.body.isNotEmpty ? jsonDecode(rawResponse.body) : null;
      } catch (e) {
        body = rawResponse.body;
      }

      final response = Response(
        statusCode: rawResponse.statusCode,
        body: body,
        statusText: rawResponse.reasonPhrase ?? 'Unknown',
      );
      return response;
    } on TimeoutException {
      debugPrint('====> DELETE API TimeoutException occurred');
      return const Response(statusCode: 1, statusText: "Request timed out");
    } on SocketException {
      debugPrint('====> DELETE API SocketException occurred');
      return const Response(
          statusCode: 1, statusText: "No Internet Connection");
    } catch (e) {
      debugPrint('====> DELETE API Unexpected Exception: $e');
      return const Response(statusCode: 1, statusText: "Something went wrong");
    }
  }
}
