import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:trreu/views/res/commonWidgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class PayDunyaPaymentPage extends StatefulWidget {
  final double amount;
  final String description;
  final String customerName;
  final String customerEmail;
  final List<Map<String, dynamic>> iteams;
  final String customerPhone;

  const PayDunyaPaymentPage({
    Key? key,
    required this.amount,

    required this.description,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.iteams,
  }) : super(key: key);

  @override
  _PayDunyaPaymentPageState createState() => _PayDunyaPaymentPageState();
}

class _PayDunyaPaymentPageState extends State<PayDunyaPaymentPage> {
  late final WebViewController controller;
  String? paymentUrl;

  @override
  void initState() {
    super.initState();
    createInvoice();
  }

  Future<void> createInvoice() async {
    try {
      final masterKey = dotenv.env['PAYDUNYA_MASTER_KEY'];
      final privateKey = dotenv.env['PAYDUNYA_PRIVATE_KEY'];
      final token = dotenv.env['PAYDUNYA_TOKEN'];

      final response = await http.post(
        Uri.parse(
          'https://app.paydunya.com/sandbox-api/v1/checkout-invoice/create',
        ),
        headers: {
          'Content-Type': 'application/json',
          'PAYDUNYA-MASTER-KEY': masterKey!,
          'PAYDUNYA-PRIVATE-KEY': privateKey!,
          'PAYDUNYA-TOKEN': token!,
        },
        body: jsonEncode({
          'invoice': {
            'total_amount': widget.amount,
            'description': widget.description,
            'customer': {
              'name': widget.customerName,
              'email': widget.customerEmail,
              'phone': widget.customerPhone,
            },
            "items": widget.iteams,
            "store": {"name": "Teeru"},

            "channels": ["card", "mtn-benin", "orange-money-senegal", "wave"],
          },
          'store': {'name': 'Teeru'},
          'actions': {
            // Custom scheme URLs to detect inside the WebView
            'return_url': 'myapp://payment-success',
            'cancel_url': 'myapp://payment-cancel',
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log("Invoice creation response: $data");
        final url = data['response_text'];
        final transactionId = data['token'];
        log("1." + transactionId.toString());

        if (url != null) {
          setState(() {
            paymentUrl = url;
          });
          // Initialize the WebView controller once URL is ready
          setupWebView(url, transactionId);
        } else {
          log('No payment URL received');
        }
      } else {
        log(
          'Failed to create invoice. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      log('Error creating invoice: $e');
    }
  }

  void setupWebView(String url, String transactionId) {
    // Initialize WebViewController with platform-specific params
    late final PlatformWebViewControllerCreationParams params;

    params = const PlatformWebViewControllerCreationParams();

    controller =
        WebViewController.fromPlatformCreationParams(params)
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (NavigationRequest request) {
                log('Navigating to ${request.url}');

                // Detect success or cancellation URL inside WebView navigation
                if (request.url.startsWith('myapp://payment-success')) {
                  log(1.toString());
                  Navigator.of(context).pop({
                    'status': 'success',
                    'transactionId': transactionId.toString(),
                  });
                  return NavigationDecision.prevent;
                }
                if (request.url.startsWith('myapp://payment-cancel')) {
                  Navigator.of(context).pop({'status': 'cancelled'});
                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
              },
              onPageStarted: (url) => log('Page started loading: $url'),
              onPageFinished: (url) => log('Page finished loading: $url'),
              onWebResourceError:
                  (error) => log('WebView error: ${error.description}'),
            ),
          )
          ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar('PayDunya Payment'),
      body:
          paymentUrl == null
              ? Center(child: CircularProgressIndicator())
              : WebViewWidget(controller: controller),
    );
  }
}
