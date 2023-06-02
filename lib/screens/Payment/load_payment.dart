import 'dart:convert';
import 'dart:typed_data';
import 'package:binary_app/provider/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../utils/util_functions.dart';
import '../courselist.dart';

class LoadPaymnet extends StatelessWidget {
  const LoadPaymnet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formatDate = DateFormat('yyyyMMddhhmm').format(now);

    return Scaffold(
        // appBar: _appBar(),
        // body: WebView(
        //   initialUrl:
        //       'https://bxladmin.monthekristho.com/onepay-php-main/payment.php',
        //   javascriptMode: JavascriptMode.unrestricted,
        // ),
        body: Consumer<PaymentProvider>(
      builder: (context, value, child) {
        return Container(
          margin: const EdgeInsets.only(top: 38),
          child: InAppWebView(
            initialUrlRequest: URLRequest(
              url: Uri.parse(
                  "https://bxladmin.monthekristho.com/onepay-php-main/payment.php"),
              method: 'POST',
              body: Uint8List.fromList(utf8.encode(
                  "firstname=${value.getPaymentModel!.firstname}&lastname=${value.getPaymentModel!.lastname}&email=${value.getPaymentModel!.email}&tele=${value.getPaymentModel!.phone}&stuid=${value.getPaymentModel!.uid}&pay=${value.getPaymentModel!.amount}&ref=$formatDate")),
              headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            ),
            onReceivedClientCertRequest: (controller, challenge) async {
              return null;
            },

            onConsoleMessage: (controller, message) {
              Map<dynamic, dynamic> res = message.toJson();
              Map<dynamic, dynamic> ress;

              if (message.message == "goback") {
                print('################# : ');
                UtilFuntions.pageTransition(
                    context,
                    courseList(
                      status: false,
                    ),
                    const LoadPaymnet());
              }
            },

            // onWebViewCreated: (controller) {},
          ),
        );
      },
    ));
  }
}

AppBar _appBar() {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    title: const Text(
      "Course Details",
      style: TextStyle(color: Colors.black),
    ),
    leading: Container(
      margin: const EdgeInsets.all(10),
      // height: 25,
      // width: 25,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      // child: Builder(
      //   builder: (BuildContext context) {
      //     return IconButton(
      //       padding: EdgeInsets.all(3),
      //       icon: const Icon(
      //         MaterialCommunityIcons.chevron_left,
      //         size: 30,
      //       ),
      //       color: Colors.black,
      //       onPressed: () {},
      //       tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      //     );
      //   },
      // ),
    ),
  );
}
