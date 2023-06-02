import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../provider/slider_provider.dart';
import '../../provider/user_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      Provider.of<SliderProvider>(context, listen: false).fetchSliders();
      Provider.of<UserProvider>(context, listen: false).initializeUser(context);
      // UtilFunctions.navigateTo(context, const GettingStarted());
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 160,
              child: Image.asset(
                'assets/logo.png',
                scale: 0.5,
              ),
            ),
            const SpinKitRing(
              color: Colors.black,
              size: 28.0,
              lineWidth: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "loading informations...",
            ),
          ],
        ),
      ),
    );
  }
}
