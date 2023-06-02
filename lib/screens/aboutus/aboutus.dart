import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:logger/logger.dart';

import '../../utils/util_functions.dart';

class aboutUs extends StatefulWidget {
  const aboutUs({Key? key}) : super(key: key);

  @override
  _aboutUsState createState() => _aboutUsState();
}

class _aboutUsState extends State<aboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: Text(
            //     "BINARY",
            //     style: TextStyle(
            //         color: Colors.amber,
            //         fontSize: 40,
            //         fontWeight: FontWeight.bold),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Container(
            //     width: double.infinity,
            //     color: const Color(0xff3949ab),
            //     child: const Padding(
            //       padding: EdgeInsets.all(8.0),
            //       child: Text(
            //         "Export Lanka Power Team",
            //         textAlign: TextAlign.center,
            //         style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 30,
            //             fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                // color: const Color(0xff3949ab),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(105),
                          child: Hero(
                            tag: "profgroup",
                            child: Image.asset(
                              "assets/bxl client logo.jpeg",
                              height: 120,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            color: Colors.grey[400],
                            height: 70,
                            width: 2,
                          ),
                        ),
                        Image.asset(
                          "assets/logo.png",
                          // width: 120,
                          height: 130,
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 4,
                        ),
                      ],
                    ),
                    // Container(
                    //   height: 50,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       FlutterSocialButton(
                    //         onTap: () {},
                    //         mini: true,
                    //       ),
                    //       FlutterSocialButton(
                    //         onTap: () {},
                    //         mini: true,
                    //         buttonType: ButtonType.facebook,
                    //       ),
                    //       FlutterSocialButton(
                    //         onTap: () {},
                    //         mini: true,
                    //         buttonType: ButtonType.twitter,
                    //       ),
                    //       FlutterSocialButton(
                    //         onTap: () {},
                    //         mini: true,
                    //         buttonType: ButtonType.whatsapp,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "       Binary expert Lanka අපි ඔබ සමග අත්වල් බැදගන්නේ ඔබව සාර්තක අන්තර්ජාල ව්‍යවසායකයෙකු ලෙස බිහි කිරීමේ බලාපොරොත්තු අතැතිව සහ Trading තුලින් ඔබගේ ජීවිතය සාර්තකව නංවාලීමේ එකම අබිප්‍රායෙනි.\n \n          වර්ශ 2018ක් වූ දෙසැම්බර් 09 වන දින එක් සිසුවෙකුගෙන් ආරම්බ කල Binary Expert Lanka Trading ආයතනය 2021 දෙසැම්බර් 09වන දිනට වසර 03ක සාර්තක ගමන් මග නිමා කරමින් සිව්වෙනි වසරට පා තබනන්නේ දෙස් විදෙස් සිසුන් 7500කට වඩා පිරිසකගේ අන්තර්ජාල ව්‍යවසයකයෙකු වීමේ සිහිනය යතාර්තයක් කරමින්ය.ගත වූ වර්ශ 03 තුල Binary Expert Lanka ආයතනය විසින් 85% කට වඩා ප්‍රතිශතයකින් අන්තර්ජාල ව්‍යවසායකයන් බිහි කල අතර ඉන් බහුතරයකගේ වසරක ආදායම ලක්ශ එක හමාරකට (150,000) වඩා වැඩි වී ඇත.ඉන් සමහර සිසුන්ගේ මසක ආදායම ලක්ශ දහය (1,000,000) අබිබවා තිබීමද Binary Expert Lanka අප ආයතනයට ඉමහත් කීර්තියක් දෙන කාරනයක්ද විය.\n \n          වසර 11ක සිට අන්තර්ජාල ක්ශේත්‍රය තුල දැවැන්ත අත්දැකිම් සමුදායක් මුසු කර ගනිමින් වසර 09කට ආසන්න කාලයක් Binary Tick Trading කලාව තුල ලබා ගත් අතිශය දැවැන්ත අත්දැකීම් සමුදායද අතැතිව ලහිරු තීක්ශන වීරසිංහ යන ඒ දැවැන්ත චරිතය ලාංකික Trading කලාව වෙනසකට හසු කරමින් Binary Expert Lanka යන නමින් Tick Trading ආයතනයක් ලංකාව තුල ප්‍රතම වරට බිහි කිරීමට සමත් වූ අතර ඒ තුලින් ලාංකික Trading කලාවේ හැරවුම් ලක්ශයක් බවට පත් කිරීමට සමත් විය. මේ වන විට Binary Expert Lanka අප ආයතනය මගින් අපගේ සිසුන්ට දැනුම ලබා දීමට මෙන්ම අත්දැකීම් බහුල ඇදුරු මඩුල්ලක් සහ සහයක කන්ඩායමක් සිටින අතර Trading ආයතනයක් වශයෙන් එම සියලු කරුනු සාර්තකව ඉදිරියට එන යෑමට ලහිරු වීරසිංහෙ වන Binary Expert Lanka නිර්මාතෘ විසින් කාටයුතු කර ඇත.",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

AppBar _appBar() {
  return AppBar(
    backgroundColor: HexColor("#283890"),
    elevation: 0,
    title: const Text(
      "About Us",
      style: TextStyle(fontSize: 14, color: Colors.white),
    ),
    automaticallyImplyLeading: false,
    actions: const [],
    leading: Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.transparent),
      child: Builder(
        builder: (BuildContext context) {
          return IconButton(
            padding: const EdgeInsets.all(3),
            icon: const Icon(
              MaterialCommunityIcons.chevron_left,
              size: 30,
            ),
            color: Colors.white,
            onPressed: () {
              UtilFuntions.goBack(context);
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
    ),
  );
}
