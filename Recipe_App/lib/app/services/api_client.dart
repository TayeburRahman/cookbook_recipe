import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'app_url.dart';
import 'error_response.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio_package;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:recipe_app/app/global/helper/local_db/local_db.dart';
import 'package:recipe_app/app/utils/app_constants/app_constants.dart';

class ApiClient extends GetxService {
  static var client = http.Client();
  static const String noInternetMessage = "Can't connect to the internet!";
  static const int timeoutInSeconds = 30;
  static String bearerToken = "";

  ///================================================================Get Method============================///
  static Future<Response> getData(String uri,
      {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };

    try {
      http.Response response = await client
          .get(
            Uri.parse(ApiUrl.baseUrl + uri),
            headers: headers ?? mainHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  ///================================================================patch Method============================///
  static Future<Response> patchData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
    bool isBody = true,
  }) async {
    bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };

    try {
      http.Response response = await client
          .patch(
            Uri.parse(ApiUrl.baseUrl + uri),
            body: isBody ? body : null,
            headers: headers ?? mainHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  ///================================================================PostMethod============================///
  static Future<Response> postData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };

    try {
      http.Response response = await client
          .post(
            Uri.parse(ApiUrl.baseUrl + uri),
            body: body,
            headers: headers ?? mainHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Post Multipart✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  static Future<Response> postMultipartData(
      String uri, Map<String, dynamic> body,
      {List<MultipartBody>? multipartBody,
      Map<String, String>? headers}) async {
    return _dioMultipartRequest(uri, body, multipartBody, "POST", headers);
  }

  //>>>>>>>>>>>>>>>>>>✅✅Patch Multipart✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  static Future<Response> patchMultipart(String uri, Map<String, dynamic> body,
      {List<MultipartBody>? multipartBody,
      Map<String, String>? headers}) async {
    return _dioMultipartRequest(uri, body, multipartBody, "PATCH", headers);
  }

  static Future<Response> _dioMultipartRequest(
      String uri,
      Map<String, dynamic> body,
      List<MultipartBody>? multipartBody,
      String method,
      Map<String, String>? headers) async {
    dio_package.Dio dio = dio_package.Dio();

    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        compact: false,
      ));
    }

    try {
      String? bearerToken =
          await SharePrefsHelper.getString(AppConstants.bearerToken);
      var mainHeaders = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $bearerToken',
        ...?headers
      };

      dynamic requestData;

      if (multipartBody != null && multipartBody.isNotEmpty) {
        dio_package.FormData formData = dio_package.FormData.fromMap(body);

        for (var element in multipartBody) {
          formData.files.add(MapEntry(
            element.key,
            await dio_package.MultipartFile.fromFile(element.file.path),
          ));
        }

        formData.fields.add(MapEntry("_method", method.toUpperCase()));

        requestData = formData;
      } else {
        requestData = body;
      }

      final response = await dio.request(
        ApiUrl.baseUrl + uri,
        data: requestData,
        options: dio_package.Options(
          method: method,
          headers: mainHeaders,
          contentType: (multipartBody == null || multipartBody.isEmpty)
              ? 'application/json'
              : null,
        ),
      );

      return Response(
          statusCode: response.statusCode,
          statusText: response.statusMessage,
          body: response.data);
    } catch (e) {
      log("Dio Error: $e");
      return const Response(statusCode: 1, statusText: "Connection Error");
    }
  }

  ///=============================Put data===================

  static Future<Response> putData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);
    var mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };

    try {
      http.Response response = await client
          .put(Uri.parse(ApiUrl.baseUrl + uri),
              body: jsonEncode(body), headers: headers ?? mainHeaders)
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  ///=============================Delete data===================

  static Future<Response> deleteData(String uri,
      {Map<String, String>? headers}) async {
    bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);
    var mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };

    try {
      http.Response response = await client
          .delete(Uri.parse(ApiUrl.baseUrl + uri),
              headers: headers ?? mainHeaders)
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  ///=============================Handle Response (Structural Logging)===================

  static Response handleResponse(http.Response response, String uri) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      body = response.body;
    }

    // Creating structural output for the console
    if (kDebugMode) {
      print("┌---------------------------------------------------------------");
      print("| API Response: [${response.statusCode}] $uri");
      try {
        // This converts the JSON body into a "Pretty" Indented String
        var encoder = const JsonEncoder.withIndent('  ');
        print("| Body: ${encoder.convert(body)}");
      } catch (e) {
        print("| Body: $body");
      }
      print("└---------------------------------------------------------------");
    }

    Response response0 = Response(
      body: body,
      bodyString: response.body.toString(),
      request: Request(
          headers: response.request!.headers,
          method: response.request!.method,
          url: response.request!.url),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );

    if (response0.statusCode != 200 &&
        response0.body != null &&
        response0.body is! String) {
      ErrorResponse errorResponse = ErrorResponse.fromJson(response0.body);
      response0 = Response(
          statusCode: response0.statusCode,
          body: response0.body,
          statusText: errorResponse.message);
    }

    return response0;
  }
}

class MultipartBody {
  String key;
  File file;
  MultipartBody(this.key, this.file);
}
