import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../provider/payment_provider.dart';
import '../../utils/util_functions.dart';

class RefundPolicy extends StatelessWidget {
  const RefundPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    DateTime now = DateTime.now();
    String formatDate = DateFormat('yyyyMMddhhmm').format(now);
    return Scaffold(
      appBar: _appBar(),
      body: Consumer<PaymentProvider>(
        builder: (context, value, child) {
          return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image(
                        image: AssetImage(
                          "assets/99382-rocket-all-orange-privacy-website.gif",
                        ),
                        height: 200,
                      ),

                      // Lottie.asset(
                      //   'assets/105408-lock.json',
                      //   width: 150,
                      //   // height: 200,
                      //   fit: BoxFit.fill,
                      // ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 232, 235, 231),
                          borderRadius: BorderRadius.circular(5)),
                      width: size.width,
                      child: Row(
                        children: [
                          Flexible(
                            child: Column(
                              children: const [
                                Text(
                                  "Binary Expert Lanka ආයතනය යටතේ අධ්යා පනය ලබන ඕනෑම සිසුවෙකු මෙහි පවතින සියළුම නීති වලට අනුගත හෝ අනුගත වීමට කටයුතු කළ යුතුය. එම නීතිරීති පිළිනොපදින ඕනෑම සිසුවෙකුට ඔහුගේ ශිෂ්යටභාවය අහෝසි කිරීමේ සම්පූර්ණ අයිතිය binary expert Lanka කළමනාකාරීත්වය යටතේ පවතී .",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 7,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                MaterialCommunityIcons.radiobox_marked,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: Column(
                                  children: const [
                                    Text(
                                      "Binary Expert Lanka power team තුළ අනිසි ලෙස අනවශ්යා ප්රේචාර කිරීමට (posts, link, scam news, fake news) අවසර නොමැත.",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 7,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Icon(
                                MaterialCommunityIcons.radiobox_marked,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: Column(
                                  children: const [
                                    Text(
                                      "ආයතන තුළ අධ්යා පනය ලබන සිසුවෙකු වශයෙන් තමන්ගේ ව්යාතපාරික ගැටලු හෝ අදහස් අනවශ්යo ලෙස ප්රsචාරය කිරීමට අවසර නොමැත.",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 7,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Icon(
                                MaterialCommunityIcons.radiobox_marked,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: Column(
                                  children: const [
                                    Text(
                                      "Binary Expert Lanka ආයතනයට අපහාස වන අයුරින් ප්රමචාරයන් දියත් කිරීමට හෝ උදව් කිරීම අප ආයතනයේ ශිෂ්යp භාවය අහෝසි වීමට හේතුවක් වේ.",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 7,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Icon(
                                MaterialCommunityIcons.radiobox_marked,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: Column(
                                  children: const [
                                    Text(
                                      "Binary Expert Lanka ආයතනයේ අවසරයකින් තොරව Skrill, Nettler, BTC හෝ වෙනත් අන්තර්ජාලය හරහා භාවිතා වන මුදල් ඒකක විකිණීමට අවසර නොමැත.",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 7,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Icon(
                                MaterialCommunityIcons.radiobox_marked,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: Column(
                                  children: const [
                                    Text(
                                      "Binary Expert Lanka ආයතනය මගින් ලබා දෙන binary trading දැනුම (BXL Binary strategies and ETC.) එම ආයතනයේ කළමනාකාරීත්වයේ අවසරයකින් තොරව විකිණීම, නැවත ඉගැන්වීම හෝ පන්ති ලෙස පැවැත්වීම කිසිදු හේතුවක් මත අවසර හිමි නොවේ .මෙම සීමාවන් අභිබවා යෑම අප ආයතනය මගින් නීතිමය ක්රිතයාමාර්ග ගැනීමට හැකිය .",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 7,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Icon(
                                MaterialCommunityIcons.radiobox_marked,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: Column(
                                  children: const [
                                    Text(
                                      "Binary Expert Lanka ආයතනයේ මේ වන විට පවතින group for or individual classes සඳහා මුදල් ගෙවූ පසු කිසිදු හේතුවක් මත ආපසු නොකෙරේ.",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 7,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // ElevatedButton(
                    //   onPressed: () {},
                    //   child: Text(
                    //     "   Accept   ",
                    //     style: GoogleFonts.poppins(
                    //       fontSize: 12,
                    //     ),
                    //   ),
                    //   style: ElevatedButton.styleFrom(
                    //     primary: Colors.blue,
                    //     onPrimary: Colors.white,
                    //     // shape: StadiumBorder(),
                    //   ),
                    // ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}

AppBar _appBar() {
  return AppBar(
    backgroundColor: HexColor("#283890"),
    elevation: 0,
    title: const Text(
      "Refund policy",
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
