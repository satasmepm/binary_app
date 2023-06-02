import 'package:binary_app/screens/Video/Videolist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_beautiful_popup/main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../screens/Payment/Slippay.dart';
import '../screens/Payment/payment_screen.dart';
import '../screens/Payment/slip_pay_video.dart';
import '../screens/course/course_details.dart';
import '../screens/lms/slipPayLms.dart';

class UtilFuntions {
  //navigation function
  static void navigateTo(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  //go back function
  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  //push and remove navigation function
  static void pushRemoveNavigation(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => widget), (route) => false);
  }

  static void pageTransition(
      BuildContext context, Widget widgetchild, Widget widgetcurrent) {
    Navigator.push(
      context,
      PageTransition(
          child: widgetchild,
          childCurrent: widgetcurrent,
          type: PageTransitionType.rightToLeftJoined,
          duration: const Duration(milliseconds: 300),
          reverseDuration: const Duration(milliseconds: 300),
          curve: Curves.easeInCubic,
          alignment: Alignment.topCenter),
    );
  }

  static void pageTransitionwithremove(
      BuildContext context, Widget widgetchild, Widget widgetcurrent) {
    Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
            child: widgetchild,
            childCurrent: widgetcurrent,
            type: PageTransitionType.rightToLeftJoined,
            duration: const Duration(milliseconds: 300),
            reverseDuration: const Duration(milliseconds: 300),
            curve: Curves.easeInCubic,
            alignment: Alignment.topCenter),
        (route) => false);
  }

  static paymetDialog(String fname, BuildContext context) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Hello ${fname}",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "You have to pay for this LMS",
            style: GoogleFonts.poppins(
              fontSize: 12,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PaymentType(
                color: const Color.fromARGB(255, 23, 202, 32),
                icon: Icons.credit_card_outlined,
                maintext: "Online",
                subtext: "pay",
                onTap: () {
                  Navigator.pop(context);
                  UtilFuntions.pageTransition(
                    context,
                    const PaymentScreen(),
                    CourseDetails(docid: "1"),
                  );
                },
              ),
              SizedBox(
                width: 10,
              ),
              PaymentType(
                color: Colors.red,
                icon: MaterialCommunityIcons.cloud_check_outline,
                maintext: "Upload",
                subtext: "bank slip",
                onTap: () {
                  Navigator.pop(context);
                  UtilFuntions.pageTransition(
                    context,
                    const SlipPayLMSScreen(),
                    CourseDetails(docid: "1"),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }

  static paymetvideoDialog(String fname, BuildContext context) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Hello ${fname}",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "You have to pay for this video",
            style: GoogleFonts.poppins(
              fontSize: 12,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PaymentType(
                color: const Color.fromARGB(255, 23, 202, 32),
                icon: Icons.credit_card_outlined,
                maintext: "Online",
                subtext: "pay",
                onTap: () {
                  Navigator.pop(context);
                  UtilFuntions.pageTransition(
                    context,
                    const PaymentScreen(),
                    Videolist(status: true),
                  );
                  // Navigator.pop(context);
                },
              ),
              SizedBox(
                width: 10,
              ),
              PaymentType(
                color: Colors.red,
                icon: MaterialCommunityIcons.cloud_check_outline,
                maintext: "Upload",
                subtext: "bank slip",
                onTap: () {
                  Navigator.pop(context);
                  UtilFuntions.pageTransition(
                    context,
                    const SlipPayVideo(),
                    CourseDetails(docid: "1"),
                  );
                  // Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
    //   final popup = BeautifulPopup(
    //     context: context,
    //     template: TemplateOrangeRocket2,
    //   );
    //   return popup.show(
    //     title: 'Hello ' + fname + " !",
    //     content: SizedBox(
    //       height: 300,
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             "You have to pay for this video",
    //             style: GoogleFonts.poppins(
    //               fontSize: 12,
    //             ),
    //           ),
    //           const SizedBox(
    //             height: 40,
    //           ),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               PaymentType(
    //                 color: const Color.fromARGB(255, 23, 202, 32),
    //                 icon: Icons.credit_card_outlined,
    //                 maintext: "Online",
    //                 subtext: "pay",
    //                 onTap: () {
    //                   UtilFuntions.pageTransition(
    //                     context,
    //                     const PaymentScreen(),
    //                     CourseDetails(docid: "1"),
    //                   );
    //                 },
    //               ),
    //               PaymentType(
    //                 color: Colors.red,
    //                 icon: MaterialCommunityIcons.cloud_check_outline,
    //                 maintext: "Upload",
    //                 subtext: "bank slip",
    //                 onTap: () {
    //                   UtilFuntions.pageTransition(
    //                     context,
    //                     const SlipPayVideo(),
    //                     CourseDetails(docid: "1"),
    //                   );
    //                 },
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //     actions: [
    //       popup.button(
    //         label: 'Close',
    //         onPressed: Navigator.of(context).pop,
    //       ),
    //     ],
    //     // bool barrierDismissible = false,
    //     // Widget close,
    //   );
  }
}

class PaymentType extends StatelessWidget {
  const PaymentType({
    required this.color,
    required this.icon,
    required this.maintext,
    required this.subtext,
    required this.onTap,
    Key? key,
  }) : super(key: key);
  final Color color;
  final IconData icon;
  final String maintext;
  final String subtext;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 125,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Colors.white,
              Colors.white,
            ],
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  maintext,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtext,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
