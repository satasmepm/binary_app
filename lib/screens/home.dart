import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:binary_app/model/slider_model.dart';
import 'package:binary_app/screens/Video/Videolist.dart';
import 'package:binary_app/screens/courselist.dart';
import 'package:binary_app/screens/notification/message_screen.dart';
import 'package:binary_app/screens/notification/notifications.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:logger/logger.dart';
import 'package:new_version_plus/new_version_plus.dart';
import '../utils/util_functions.dart';
import 'components/custom_drawer.dart';
import 'home/main_screen.dart';
import 'home/no_connection_screen.dart';
import 'lms/lms_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CarouselController carouselController = CarouselController();
  int _selectedIndex = 0;
  String _title = "";

  final ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  List<SliderModel> list = [];
  static final List<Widget> _widgetOptions = <Widget>[
    const MainScreen(),
    courseList(status: true),
    const Videolist(status: true),
    const MessageScreen(),
    LMSScreen(status: true)
  ];

  void _onItemTapped(int index) {
    String title = "";
    if (index == 1) {
      title = "All Course";
    } else if (index == 2) {
      title = "All Videos";
    }
    if (index == 3) {
      title = "Inbox";
    }
    if (index == 4) {
      title = "LMS";
    }
    setState(() {
      _selectedIndex = index;
      _title = title;
    });
  }

  Future<bool> initBackButton() async {
    Logger().d('back button pressed');
    return await showDialog(
          context: context,
          builder: (context) => ElasticIn(
            child: AlertDialog(
              title: Text(
                'Exit App',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                'Do you really want to exit an App ?',
                style:
                    GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal, // This is what you need!
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('No'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // This is what you need!
                  ),
                  onPressed: () => SystemNavigator.pop(),
                  child: const Text('Yes'),
                ),
              ],
            ),
          ),
        ) ??
        false;
  }

  @override
  initState() {
    // fetchCarousalImages();
    super.initState();
    // Instantiate NewVersion manager object (Using GCP Console app as example)
    final newVersion = NewVersionPlus(
      iOSId: 'com.example.binaryApp',
      androidId: 'com.satasme.binary_app',
    );

    // You can let the plugin handle fetching the status and showing a dialog,
    // or you can fetch the status and display your own dialog, or no dialog.
    final simpleBehavior = true;

    if (simpleBehavior) {
      basicStatusCheck(newVersion);
    }

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        UtilFuntions.pageTransition(
            context, const ConnectionScreen(), const HomeScreen());
      } else {
        UtilFuntions.pageTransition(
            context, const HomeScreen(), const ConnectionScreen());
      }

      // Got a new connectivity status!
    });
  }

  basicStatusCheck(NewVersionPlus newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  advancedStatusCheck(NewVersionPlus newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Update Available',
        dialogText:
            'Please update the app in new version,\nBecause Some options in the previous release will not work ',
      );
    }
  }

  @override
  dispose() {
    super.dispose();

    _connectivitySubscription.cancel();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  var s = false;
  var val;
  TextEditingController searchcont = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        // backgroundColor: const Color(0xFFECF3F9),
        backgroundColor: Colors.white,
        // backgroundColor: Color.fromARGB(26, 41, 41, 41),
        key: _globalKey,
        drawer: const SafeArea(
          child: CustomDrawer(),
        ),
        appBar: AppBar(
          backgroundColor: HexColor("#283890"),
          elevation: 0,
          title: Text(
            _title,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 5, 10, 8),
                    child: const Icon(
                      CupertinoIcons.bell,
                      color: Colors.white,
                      size: 21,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                UtilFuntions.pageTransition(
                    context,
                    const NotificationScreen(
                      status: false,
                    ),
                    const HomeScreen());
              },
            )
          ],
        ),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          selectedColorOpacity: 0.25,
          // unselectedItemColor: Color.fromARGB(255, 138, 138, 138),
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.house),
              title: Text("Home"),
              selectedColor: Colors.purple,
            ),

            /// Likes
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.circle_grid_3x3),
              title: Text("Course"),
              selectedColor: Colors.pink,
            ),

            /// Search
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.video_camera, size: 28),
              title: Text("videos"),
              selectedColor: Colors.orange,
            ),
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.envelope_badge),
              title: Text("Inbox"),
              selectedColor: Colors.blue,
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.book),
              title: Text("LMS"),
              selectedColor: Color.fromARGB(255, 3, 184, 165),
            ),
          ],
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: Icon(CupertinoIcons.house),
        //       label: 'Home',
        //     ),
        //     BottomNavigationBarItem(
        //         icon: Icon(CupertinoIcons.circle_grid_3x3),
        //         label: 'Course',
        //         tooltip: "Course"),
        //     BottomNavigationBarItem(
        //       icon: Icon(
        //         CupertinoIcons.video_camera,
        //         size: 28,
        //       ),
        //       label: 'videos',
        //       tooltip: "videos",
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(CupertinoIcons.bell),
        //       label: 'notificatons',
        //       tooltip: "notificatons",
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(CupertinoIcons.book),
        //       label: 'LMS',
        //       tooltip: "LMS",
        //     ),
        //   ],
        //   currentIndex: _selectedIndex,
        //   selectedItemColor: const Color.fromARGB(255, 26, 105, 243),
        //   unselectedItemColor: Colors.grey.withOpacity(0.5),
        //   onTap: _onItemTapped,
        //   showSelectedLabels: true,
        //   showUnselectedLabels: false,
        //   type: BottomNavigationBarType.fixed,
        //   backgroundColor: Colors.white,
        // ),
        body: _widgetOptions[_selectedIndex]);
  }
}
