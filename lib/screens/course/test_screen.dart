import 'package:flutter/material.dart';

import '../../utils/util_functions.dart';
import '../Payment/payment_screen.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          InkWell(
            onTap: () {
              UtilFuntions.pageTransition(
                  context, const PaymentScreen(), const TestScreen());
            },
            child: const Text(">>>>>>>>>>>>>>>>>"),
          ),
        ],
      ),
    );
  }
}
