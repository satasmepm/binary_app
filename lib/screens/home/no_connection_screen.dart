import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({Key? key}) : super(key: key);

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: const Color(0xFFECF3F9),
      //   elevation: 0,
      //   centerTitle: true,

      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     icon: const Icon(
      //       MaterialCommunityIcons.chevron_left,
      //       size: 30,
      //     ),
      //     color: Colors.black,
      //   ),
      // ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/817-no-internet-connection.json',
              width: 200,
              // height: 200,
              fit: BoxFit.fill,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Ooops!",
              style: GoogleFonts.poppins(fontSize: 20, color: Colors.blue),
            ),
            Text(
              "Slow or no internet connection",
              style: GoogleFonts.poppins(fontSize: 12),
            ),
            Text(
              "please check your internet setting.",
              style: GoogleFonts.poppins(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
