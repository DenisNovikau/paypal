import 'dart:core';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'PaypalServices.dart';

class PaypalPayment extends StatelessWidget {
  PaypalServices services = PaypalServices();

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  PaypalPayment({Key? key}) : super(key: key);

  Future<Map<String, String>?> getFuture() {
    return services.createPaypalPayment({
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
    }, services.getAccessToken());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, String>?>(
          future: getFuture(),
          builder: (context, snapshot) {
            return (snapshot.hasData)
                ? WebView(
                    initialUrl: snapshot.data!["approvalUrl"],
                    javascriptMode: JavascriptMode.unrestricted,
                    navigationDelegate: (NavigationRequest request) {
                      if (request.url.contains(returnURL)) {
                        final uri = Uri.parse(request.url);
                        final payerID = uri.queryParameters['PayerID'];
                        if (payerID != null) {
                          services
                              .executePayment(snapshot.data!["executeUrl"],
                                  payerID, services.getAccessToken())
                              .then((id) {
                            Navigator.of(context).pop();
                          });
                        } else {
                          Navigator.of(context).pop();
                        }
                        Navigator.of(context).pop();
                      }
                      if (request.url.contains(cancelURL)) {
                        Navigator.of(context).pop();
                      }
                      return NavigationDecision.navigate;
                    },
                  )
                : const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
