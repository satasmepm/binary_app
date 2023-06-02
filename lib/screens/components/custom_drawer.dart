import 'package:binary_app/provider/user_provider.dart';
import 'package:binary_app/screens/home.dart';
import 'package:binary_app/screens/shops/shops_screen.dart';
import 'package:binary_app/screens/timetable/time_table.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../utils/util_functions.dart';
import '../Refer/refer.dart';
import '../aboutus/aboutus.dart';
import '../aboutus/privacy_policy_screen.dart';
import '../chats/conersation_list.dart';

import '../login.dart';
import '../notification/notifications.dart';
import '../profile_screen/profile_screen_new.dart';
import '../success/success_stories.dart';
import 'custom_tile.dart';
import '../../utils/constatnt.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 30,
          child: Row(
            children: [
              Text(
                // "Powerd by satasme holdings (Pvt) Ltd, Sri lanka.",
                "Powerd by satasme holdings (Pvt) Ltd,Sri lanka.",
                style:
                    GoogleFonts.poppins(color: Colors.grey[800], fontSize: 9),
              ),
              SizedBox(
                width: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Image.asset(
                  Constants.imageAsset("satasmelogo.png"),
                  scale: 3,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          // color: Color.fromRGBO(50,75,205,1),

          child: Consumer<UserProvider>(
            builder: (context, value, child) {
              return ListView(
                children: [
                  UserAccountsDrawerHeader(
                      accountEmail: const Text(''),
                      // decoration: BoxDecoration(
                      //   color: Colors.transparent,
                      // ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Color(0xff283593),
                            Color(0xff2196f3),
                          ],
                        ),
                      ),
                      accountName: Row(
                        children: <Widget>[
                          Container(
                            width: 50,
                            height: 50,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: InkWell(
                              onTap: () {
                                UtilFuntions.pageTransition(
                                    context,
                                    const ProfileScreenNew(),
                                    const CustomDrawer());
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(55),
                                child: value.getuserModel.image == "null"
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(55),
                                        child: Image.asset(
                                          "assets/avatar.jpg",
                                        ),
                                        //  Image.asset(value.getImageFile!.path),
                                      )
                                    : CircleAvatar(
                                        radius: 25.0,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            value.getuserModel.image,
                                          ),
                                          radius: 24,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  value.getuserModel.fname +
                                      " " +
                                      value.getuserModel.lname,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  value.getuserModel.email,
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  Column(
                    children: [
                      CustomListTile(
                        text: "Profile",
                        iconleading: CupertinoIcons.person,
                        onTap: () async {
                          value.profileComplete();
                          UtilFuntions.pageTransition(context,
                              const ProfileScreenNew(), const CustomDrawer());
                        },
                      ),

                      const Divider(), //
                      CustomListTile(
                        text: "Notifications",
                        iconleading: CupertinoIcons.bell,
                        onTap: () {
                          UtilFuntions.pageTransition(
                              context,
                              const NotificationScreen(
                                status: false,
                              ),
                              const CustomDrawer());
                        },
                      ),
                      const Divider(), //
                      CustomListTile(
                        text: "Success Stories",
                        iconleading: Icons.ads_click_sharp,
                        onTap: () {
                          UtilFuntions.pageTransition(context,
                              const SuccessStories(), const CustomDrawer());
                        },
                      ),
                      const Divider(), //
                      CustomListTile(
                        text: "Shops",
                        iconleading: CupertinoIcons.cart,
                        onTap: () async {
                          // UtilFuntions.navigateTo(context, const slipPay());
                          UtilFuntions.pageTransition(context,
                              const ShopScreen(), const CustomDrawer());
                        },
                      ),
                      const Divider(), //
                      Consumer<UserProvider>(
                        builder: (context, value, child) {
                          return CustomListTile(
                            text: "Chat",
                            iconleading: CupertinoIcons.bubble_right,
                            onTap: () async {
                              UtilFuntions.pageTransition(
                                  context,
                                  const ConversationList(),
                                  const CustomDrawer());
                            },
                          );
                        },
                      ),
                      const Divider(), //
                      CustomListTile(
                        text: "About Us",
                        iconleading: CupertinoIcons.lightbulb,
                        onTap: () {
                          UtilFuntions.pageTransition(
                              context, const aboutUs(), const CustomDrawer());
                        },
                      ),
                      const Divider(), //
                      CustomListTile(
                        text: "Refer & Earn",
                        iconleading: CupertinoIcons.person_add,
                        onTap: () async {
                          Navigator.of(context).pop();
                          await Future.delayed(const Duration(
                              milliseconds: 200)); // wait some time
                          UtilFuntions.pageTransition(
                              context, const refer(), const HomeScreen());
                        },
                      ),
                      const Divider(), //
                      CustomListTile(
                        text: "Privacy Policy",
                        iconleading: CupertinoIcons.lock,
                        onTap: () {
                          UtilFuntions.pageTransition(
                              context,
                              const PrivacyPolicyScreen(),
                              const CustomDrawer());
                        },
                      ),
                      const Divider(), //
                      CustomListTile(
                        text: "Refund Policy",
                        iconleading: CupertinoIcons.lock_shield,
                        onTap: () {
                          UtilFuntions.pageTransition(
                              context,
                              const PrivacyPolicyScreen(),
                              const CustomDrawer());
                        },
                      ),
                      const Divider(), //
                      CustomListTile(
                        text: "Time Table",
                        iconleading: CupertinoIcons.calendar,
                        onTap: () {
                          UtilFuntions.pageTransition(
                              context, TimeTableScreen(), const CustomDrawer());
                        },
                      ),
                      // const Divider(), //
                      // CustomListTile(
                      //   text: "Testing pupose",
                      //   iconleading:
                      //       MaterialCommunityIcons.account_arrow_right_outline,
                      //   onTap: () async {
                      //     Navigator.of(context).pop();
                      //     await Future.delayed(const Duration(
                      //         milliseconds: 200)); // wait some time
                      //     UtilFuntions.pageTransition(context,
                      //         const ProfileScreenNew(), const CustomDrawer());
                      //   },
                      // ),

                      const Divider(), //here is a divider
                      const SizedBox(
                        height: 30,
                      ),
                      CustomListTile(
                        text: "Logout",
                        iconleading: CupertinoIcons.power,
                        onTap: () {
                          Provider.of<UserProvider>(context, listen: false)
                              .clearImagePicker();
                          Provider.of<UserProvider>(context, listen: false)
                              .logOut();

                          FirebaseAuth.instance.signOut().then((_) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                (Route<dynamic> route) => false);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
