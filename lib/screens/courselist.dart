import 'package:binary_app/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../provider/corse_provider.dart';
import 'course/course_details.dart';
import 'course/search.dart';

class courseList extends StatefulWidget {
  courseList({
    Key? key,
    required this.status,
  }) : super(key: key);
  bool status = false;

  @override
  _courseListState createState() => _courseListState();
}

class _courseListState extends State<courseList> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  var s = false;
  var val;

  TextEditingController searchcont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFECF3F9),
      appBar: widget.status != true
          ? AppBar(
              backgroundColor: const Color(0xFFECF3F9),
              elevation: 0,
              centerTitle: true,
              title: const Text(
                "All Courses",
                style: TextStyle(color: Colors.black),
              ),
              leading: IconButton(
                onPressed: () {
                  // UtilFuntions.pageTransition(
                  //     context, const HomeScreen(), const CourseList());
                  Navigator.pop(context);
                },
                icon: const Icon(
                  MaterialCommunityIcons.chevron_left,
                  size: 30,
                ),
                color: Colors.black,
              ),
            )
          : null,
      key: _globalKey,
      body: SafeArea(
        left: false,
        right: false,
        bottom: false,
        child: Container(
          margin: const EdgeInsets.only(top: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
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
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const SeachPage(),
                              inheritTheme: true,
                              ctx: context),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                list(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget list() {
    int columnCount = 1;
    int i = 0;
    var size = MediaQuery.of(context).size;

    return Consumer2<CourseProvider, UserProvider>(
      builder: (context, value, value2, child) {
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("course")
                .where('status', isEqualTo: 1)
                .snapshots(),
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
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: SizedBox(
                  // height: size.height,
                  child: AnimationLimiter(
                    child: GridView.count(
                        childAspectRatio: (1 / 0.88),
                        crossAxisCount: columnCount,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        children: snapshot.data!.docs.map((docReference) {
                          i++;
                          var coursePrice = NumberFormat("###.00#", "en_US");
                          String price = coursePrice
                              .format(double.parse(docReference['CourseFee']));
                          String id = docReference.id;

                          return AnimationConfiguration.staggeredGrid(
                            position: i,
                            columnCount: columnCount,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              child: SlideAnimation(
                                child: GestureDetector(
                                  onTap: () async {
                                    value.fetchSingleCourse(
                                        context, docReference.id);
                                    isPaied(
                                        docReference.id,
                                        docReference['CourseFee'],
                                        docReference['CourseName'],
                                        value,
                                        value2);
                                  },
                                  child: SizedBox(
                                    // height: 250,
                                    child: Card(
                                      elevation: 10,
                                      shadowColor:
                                          Colors.grey.withOpacity(0.08),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Colors.grey.withOpacity(0.2),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Stack(
                                            children: <Widget>[
                                              //Center(child: CircularProgressIndicator()),
                                              SizedBox(
                                                width: size.width,
                                                height: size.height / 4.4,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(5),
                                                  ),
                                                  child: Image.network(
                                                    docReference['image'],

                                                    //   // height: height,
                                                    fit: BoxFit.fill,
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }

                                                      return SkeletonAvatar(
                                                        style:
                                                            SkeletonAvatarStyle(
                                                          width: size.width,
                                                          height:
                                                              size.height / 4.4,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8,
                                                right: 10,
                                                bottom: 10,
                                                top: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                SizedBox(
                                                  width: 236,
                                                  height: 35,
                                                  child: Text(
                                                    docReference['CourseName'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
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
                                                  itemSize: 12,
                                                  itemPadding: const EdgeInsets
                                                          .symmetric(
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
                                                Text(
                                                  "LKR  " + price.toString(),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList()),
                  ),
                ),
              );
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

//  UtilFuntions.navigateTo(context,  CourseDetails(
//           docid: id,
//         ),);

    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft,
          child: CourseDetails(
            docid: id,
          ),
          inheritTheme: true,
          ctx: context),
    );

    // UtilFuntions.pageTransition(
    //     context,
    //     // TestScreen(),
    //     CourseDetails(
    //       docid: id,
    //     ),
    //     courseList(
    //       status: false,
    //     ));
  }
}
