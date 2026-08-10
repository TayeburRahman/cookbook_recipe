import 'package:flutter/material.dart';
import 'package:recipe_app/app/services/app_url.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../core/route_path.dart';
import '../../../../../core/routes.dart';
import 'package:http/http.dart' as http;

class WebViewScreen extends StatefulWidget {
  final String url;
  final String? title;

  const WebViewScreen({super.key, required this.url, this.title});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  var loadingPercentage = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    debugPrint("WebViewScreen initialized with URL: ${widget.url}");

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            debugPrint("Page loading started: $url");
            setState(() {
              _isLoading = true;
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            debugPrint("Page loading progress: $progress%");
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            debugPrint("Page loading finished: $url");
            setState(() {
              _isLoading = false;
              loadingPercentage = 100;
            });
          },
          onHttpError: (error) {
            // debugPrint("HTTP error occurred: ${error.statusCode} on ${error.url}");
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (error) {
            debugPrint("Web resource error: ${error.description}");
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (request) async {
            debugPrint("Navigation request to: ${request.url}");

            if (request.url.startsWith("${ApiUrl.baseUrl}/payment/stripe-webhooks") && request.url.contains("session_id=")) {
              debugPrint("Webhook URL detected, sending GET request...");

              try {
                // GET request to webhook URL
                final response = await http.get(Uri.parse(request.url));
                if (response.statusCode == 200) {
                  debugPrint("==================Webhook GET request successful.${response.body}");

                } else {
                  debugPrint("=================Webhook GET request failed with status: ${response.statusCode}");
                }
              } catch (e) {
                debugPrint("===================Error during webhook GET request: $e");
              }

              _showRedirectDialog();
              return NavigationDecision.prevent;
            }

            if (request.url.contains("success")) {
              debugPrint("Success URL detected, showing redirect dialog.");
              _showRedirectDialog();
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },

        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _showRedirectDialog() {
    debugPrint("Showing success redirect dialog");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text(
              'Your Payment is Complete. Click below to return to the home page.'),
          actions: [
            TextButton(
              onPressed: () {
                debugPrint("User clicked Go to Home");
                AppRouter.route.goNamed(RoutePath.homeScreen);
              },
              child: const Text(
                'Go to Home',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    debugPrint("Building WebViewScreen UI");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.title ?? 'Stripe',
          style: const TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            debugPrint("Back button pressed");
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            LinearProgressIndicator(
              value: loadingPercentage / 100,
              backgroundColor: Colors.grey[200],
              minHeight: 3,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
        ],
      ),
    );
  }
}
