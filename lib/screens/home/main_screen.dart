import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:binary_app/model/slider_model.dart';
import 'package:binary_app/screens/Content.dart';
import 'package:binary_app/screens/Refer/refer.dart';
import 'package:binary_app/screens/Video/Videolist.dart';
import 'package:binary_app/screens/courselist.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../provider/corse_provider.dart';
import '../../provider/user_provider.dart';
import '../../utils/constatnt.dart';
import '../../utils/util_functions.dart';
import '../components/custom_drawer.dart';
import '../course/course_details.dart';
import '../course/search.dart';
import '../home.dart';
import '../profile_screen/profile_screen_new.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  CarouselController carouselController = CarouselController();

  final List<String> _carousalImages = [];
  var _dotPosition = 0;

  List<SliderModel> list = [];

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
  }

  @override
  dispose() {
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  var s = false;
  var val;
  TextEditingController searchcont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFECF3F9),
      // appBar: AppBar(
      //   backgroundColor: HexColor("#283890"),
      //   elevation: 0,
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Stack(
      //         children: [
      //           Container(
      //             margin: EdgeInsets.fromLTRB(0, 5, 10, 8),
      //             child: Icon(
      //               MaterialCommunityIcons.bell_outline,
      //               color: Colors.white,
      //               size: 25,
      //             ),
      //           ),
      //           // Positioned(
      //           //   left: 12,
      //           //   top: 1,
      //           //   child: Container(
      //           //     width: 18,
      //           //     height: 18,
      //           //     decoration: BoxDecoration(
      //           //       color: Colors.red,
      //           //       borderRadius: BorderRadius.circular(25),
      //           //     ),
      //           //     padding: const EdgeInsets.all(2.0),
      //           //     child: Center(
      //           //       child: Text(
      //           //         "5",
      //           //         style: TextStyle(fontSize: 12),
      //           //       ),
      //           //     ),
      //           //   ),
      //           // ),
      //         ],
      //       ),
      //       onPressed: () {
      //         UtilFuntions.pageTransition(
      //             context, const NotificationScreen(), const HomeScreen());
      //       },
      //     )
      //   ],
      // ),
      key: _globalKey,
      drawer: const SafeArea(
        child: CustomDrawer(),
      ),

      // endDrawerEnableOpenDragGesture: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Column(
                children: [
                  if (FirebaseAuth.instance.currentUser != null) Name(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 42,
                      child: TextField(
                        readOnly: true,
                        cursorColor: Colors.black,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 17),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(Icons.search,
                              color: Theme.of(context).iconTheme.color),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          // fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Search....',
                        ),
                        onTap: () {
                          UtilFuntions.pageTransition(
                              context, const SeachPage(), const HomeScreen());
                        },
                      ),
                    ),
                  ),
                ],
              ),
              // height: MediaQuery.of(context).size.height * 0.175,
              height: 140,
              decoration: BoxDecoration(
                color: HexColor("#283890"),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                ),
              ),
              alignment: Alignment.center,
            ),

            SizedBox(
              // color: Colors.pink,
              // height: size.height / 3.2,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("sliders")
                      .where('status', isEqualTo: 0)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                          child: SpinKitRing(
                        color: Colors.blue,
                        size: 28.0,
                        lineWidth: 3,
                      ));
                    }
                    _carousalImages.clear();

                    for (var item in snapshot.data!.docs) {
                      Map<String, dynamic> data =
                          item.data() as Map<String, dynamic>;

                      var model = SliderModel.fromMap(data);
                      list.add(model);
                      _carousalImages.add(
                        model.image,
                      );
                    }

                    return CarouselSlider(
                      items: snapshot.data!.docs.map((docReference) {
                        //  _carousalImages
                        // .map((item) =>
                        return Image.network(
                          docReference['image'],

                          //   // height: height,
                          fit: BoxFit.fitWidth,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }

                            return const SkeletonAvatar(
                              style: SkeletonAvatarStyle(
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            );
                          },
                        );
                      }).toList(),
                      // .toList(),
                      options: CarouselOptions(
                          aspectRatio: 16 / 7,
                          viewportFraction: 0.75,
                          // initialPage: 0,
                          enableInfiniteScroll: true,
                          // reverse: false,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (val, CarouselPageChangedReason) {
                            setState(() {
                              _dotPosition = val;
                            });
                          }),
                    );
                  }),
            ),
            // Positioned(
            //   child:
            // )

            // const SizedBox(
            //   height: 5,
            // ),
            DotsIndicator(
              dotsCount: _carousalImages.isEmpty ? 1 : _carousalImages.length,
              position: _dotPosition.toDouble(),
              decorator: DotsDecorator(
                spacing: const EdgeInsets.all(4),
                size: const Size.square(6.0),
                activeSize: const Size(17.0, 6.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
            AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "Populer Courses",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 270,
                      child: course(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "Programs",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Consumer<UserProvider>(
                              builder: (context, value, child) {
                                return GestureDetector(
                                  onTap: () {
                                    // Provider.of<CourseProvider>(context,
                                    //         listen: false)
                                    //     .getAllPaidCourses(value.getuserModel!.uid);

                                    UtilFuntions.pageTransition(
                                        context,
                                        courseList(
                                          status: false,
                                        ),
                                        const HomeScreen());
                                  },
                                  child: Container(
                                    width: size.width / 2.2,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                          colors: [
                                            Colors.white,
                                            Colors.white,
                                            // Color(0xff0d47a1),
                                            // Color(0xff2196f3),
                                          ],
                                          begin: FractionalOffset(1.0, 1.0),
                                          end: FractionalOffset(1.0, 0.0),
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 15,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 23, 202, 32),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Icon(
                                                      Icons.book_outlined,
                                                      color: Colors.white,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    const Text(
                                                      "Courses",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 17),
                                                    ),
                                                    Text(
                                                      "${value.getcoursecount}+ Courses",
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 95, 95, 95),
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                                const Icon(
                                                  MaterialCommunityIcons
                                                      .arrow_right_circle,
                                                  size: 30,
                                                  color: Colors.blue,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                UtilFuntions.pageTransition(
                                    context,
                                    const Videolist(
                                      status: false,
                                    ),
                                    const HomeScreen());

                                // UtilFuntions.pageTransition(context,
                                //         const Videolist(), const HomeScreen());
                              },
                              child: Container(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.play_circle_outline,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                const Text(
                                                  "Videos",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17),
                                                ),
                                                Consumer<UserProvider>(
                                                  builder:
                                                      (context, value, child) {
                                                    return Text(
                                                      "${value.getvideocount}+ Videos",
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 95, 95, 95),
                                                          fontSize: 12),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            const Icon(
                                              MaterialCommunityIcons
                                                  .arrow_right_circle,
                                              size: 30,
                                              color: Colors.blue,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                                width: size.width / 2.2,
                                height: 140,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 15,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                  gradient: const LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Colors.white
                                        // Color(0xff0d47a1),
                                        // Color(0xff2196f3),
                                      ],
                                      begin: FractionalOffset(1.0, 1.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 25.0, left: 12, right: 12, bottom: 25),
                      child: Container(
                        decoration: BoxDecoration(
                            color: HexColor("#F59300"),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 15),
                                    child: Text(
                                      "Refer and earn",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0, top: 8),
                                    child: Text(
                                      "Refer your friend",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "and win cryptocoins",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 20),
                                      child: RaisedButton(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const refer()));
                                        },
                                        child: Text(
                                          "Refer Now",
                                          style: TextStyle(
                                              color: Colors.amber[700]),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            const SizedBox(width: 85),
                            Expanded(
                                child: Image.asset('assets/referal.png',
                                    width: 60, height: 60))
                          ],
                        ),
                        width: double.infinity,
                        height: 180,
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
    // );
  }

  Widget course() {
    return Consumer2<CourseProvider, UserProvider>(
      builder: (context, value, value2, child) {
        return StreamBuilder(
            stream: FirebaseFirestore.instance.collection("course").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    /*    child: SpinKitRing(
                  color: Colors.blue,
                )*/
                    );
                //  Center(child: LoadingFilling.square());
              }
              return ListView(
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data!.docs.map((docReference) {
                    String id = docReference.id;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(
                          width: 260,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  value.fetchSingleCourse(
                                      context, docReference.id);

                                  isPaied(
                                      docReference.id,
                                      docReference['CourseFee'],
                                      docReference['CourseName'],
                                      value,
                                      value2);
                                },
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                  child: Image.network(
                                    docReference['image'],
                                    width: 260,
                                    //   // height: height,
                                    fit: BoxFit.fill,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;

                                      return const SkeletonAvatar(
                                        style: SkeletonAvatarStyle(
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // Align(
                              //   alignment: Alignment.topRight,
                              //   child: Container(
                              //     width: 59,
                              //     height: 28,
                              //     decoration: BoxDecoration(
                              //       color: Colors.lightGreen.withOpacity(0.5),
                              //       borderRadius: const BorderRadius.only(
                              //         bottomLeft: Radius.circular(15),
                              //         topRight: Radius.circular(15),
                              //       ),
                              //     ),
                              //     child: const Align(
                              //       alignment: Alignment.center,
                              //       child: Text(
                              //         "New",
                              //         style: TextStyle(color: Colors.white),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  height: 125,
                                  width: 260,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              width: 236,
                                              height: 25,
                                              child: Text(
                                                docReference['CourseName'],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            // const SizedBox(
                                            //   height: 5,
                                            // ),
                                            Text(
                                              docReference['instructor'],
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.black,
                                              ),
                                            ),
                                            RatingBar.builder(
                                              initialRating: 5,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 15,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0.0),
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                print(rating);
                                              },
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 7,
                                                      vertical: 3),
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 250, 233, 182),
                                                  // border: Border.all(
                                                  //     color: Color.fromARGB(
                                                  //         255, 250, 233, 182)),
                                                  borderRadius:
                                                      BorderRadius.circular(3)),
                                              child: Text(
                                                docReference['duration'],
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "LKR  " +
                                                  docReference['CourseFee'],
                                              style: GoogleFonts.poppins(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList());
            });
      },
    );
  }

  void isPaied(String id, String cousreFee, String cousreName,
      CourseProvider value, UserProvider value2) async {
    await value.seachPayedCourse(cousreName, value2.getuserModel);

    value.addItems(context);
    value.addSection(id);
    value.setPrice(cousreFee);

    UtilFuntions.pageTransition(
        context,
        CourseDetails(
          docid: id,
        ),
        const HomeScreen());
  }

  Widget Name() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text(""),
            );
            //  Center(child: LoadingFilling.square());
          }
          return SizedBox(
            height: 80,
            child: ListView(
              children: snapshot.data!.docs.map((docReference) {
                String id = docReference.id;
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            maxLines: 2,
                            text: TextSpan(children: [
                              TextSpan(
                                text: "Welcome ",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.amber,
                                  fontSize: 25,
                                ),
                              ),
                              TextSpan(
                                text: docReference['fname'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ]),
                          ),
                          Text(
                            "What you want to learn today",
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                color:
                                    const Color.fromARGB(255, 209, 208, 208)),
                          ),
                        ],
                      ),
                      Consumer<UserProvider>(
                        builder: (context, value, child) {
                          return InkWell(
                            onTap: () {
                              value.profileComplete();
                              UtilFuntions.pageTransition(context,
                                  const ProfileScreenNew(), const HomeScreen());
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 5, right: 20.0),
                              child: value.getuserModel.image == "null"
                                  ? CircleAvatar(
                                      radius: 22,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(55),
                                        child: Hero(
                                          tag: "profile",
                                          child: Image.asset(
                                            "assets/avatar.jpg",
                                          ),
                                        ),
                                        //  Image.asset(value.getImageFile!.path),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 22.0,
                                      backgroundColor: Colors.white,
                                      child: Hero(
                                        tag: "profile",
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            value.getuserModel.image,
                                          ),
                                          radius: 21,
                                        ),
                                      ),
                                    ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        });
  }

  Widget Search() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("course")
            .where('CourseName', isEqualTo: val)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text("No files"),
            );
            //  Center(child: LoadingFilling.square());
          }
          return SizedBox(
            height: 200,
            child: ListView(
              children: snapshot.data!.docs.map((docReference) {
                String id = docReference.id;
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => courseDetails(
                                      docid: docReference.id,
                                    )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[350],
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                /* CircleAvatar(
                                              radius: 50,
                                              backgroundImage: NetworkImage(
                                                  'https://www.iconbunny.com/icons/media/catalog/product/1/2/120.9-teacher-i-icon-iconbunny.jpg'),
                                            ),*/

                                Image.asset("assets/course.png",
                                    width: 234, height: 112),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            docReference['CourseName'],
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              docReference['CourseFee'] +
                                                  " LKR",
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                          ),
                                        )
                                      ]),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        });
  }
}

class CardTitle extends StatelessWidget {
  const CardTitle({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 110,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.blueAccent,
              width: 0.8,
            ),
          ),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SliderItem extends StatelessWidget {
  const SliderItem({
    Key? key,
    required this.img,
    // required this.text1,
    // required this.text2,
  }) : super(key: key);

  final String img;
  // final String text1;
  // final String text2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          Constants.imageAsset(img),
          // fit: BoxFit.cover,
        ),
        // Text(
        //   text1,
        //   style: const TextStyle(
        //     fontSize: 22,
        //   ),
        // ),
        // const SizedBox(height: 5),
        // Text(
        //   text2,
        //   textAlign: TextAlign.center,
        //   style: const TextStyle(
        //     fontSize: 14,
        //     color: Colors.grey,
        //   ),
        // )
      ],
    );
  }
}
