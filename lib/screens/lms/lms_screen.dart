import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:binary_app/provider/user_provider.dart';
import 'package:binary_app/screens/Chat/chatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../provider/corse_provider.dart';
import '../components/custom_dialog.dart';
import 'lms_details.dart';

class LMSScreen extends StatefulWidget {
  LMSScreen({
    Key? key,
    required this.status,
  }) : super(key: key);
  bool status = false;
  @override
  _LMSScreenState createState() => _LMSScreenState();
}

class _LMSScreenState extends State<LMSScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  var s = false;
  var val;
  TextEditingController searchcont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: const Color(0xFFECF3F9),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('course')
              .where('status', isEqualTo: 1)
              .snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer2<CourseProvider, UserProvider>(
                    builder: (context, value, value2, child) {
                      return ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                          itemCount: snapshots.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshots.data!.docs[index].data()
                                as Map<String, dynamic>;
                            var docId = snapshots.data!.docs[index].id;
                            value.getAllPaidCourses(auth.currentUser!.uid);

                            // if (true) {}
                            return GestureDetector(
                              onTap: () {
                                value.fetchSingleCourse(context, docId);

                                isPaied(docId, data['lmsFee'],
                                    data['CourseName'], value, value2);
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Card(
                                  color: Colors.grey[200],
                                  elevation: 10,
                                  shadowColor: Colors.grey.withOpacity(0.08),
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
                                            // height: size.height / 4.4,
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(5),
                                              ),
                                              child: Image.network(
                                                data['lms_image'],

                                                //   // height: height,
                                                fit: BoxFit.fill,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }

                                                  return SkeletonAvatar(
                                                    style: SkeletonAvatarStyle(
                                                      width: size.width,
                                                      height: size.height / 4.4,
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
                                                data['CourseName'],
                                                overflow: TextOverflow.ellipsis,
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
                                              data['instructor'],
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
                                            Text(
                                              data['lmsFee'] + " LKR",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  );
          },
        ));
  }

  void isPaied(String id, String cousreFee, String cousreName,
      CourseProvider value, UserProvider value2) async {
    await value.seachPayedCourse(cousreName, value2.getuserModel);

    if (value.getPaidFoCourse == "0") {
      DialogBox().dialogBox(
        context,
        DialogType.WARNING,
        'Warning.',
        'You have to enroll the course\nbefore by LMS',
        () {},
      );
    } else {
      await value.seachPayedLMS(cousreName, value2.getuserModel);

      value.addItems(context);
      value.addSection(id);
      value.setPrice(cousreFee);

      Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: LMSDetails(
              docid: id,
            ),
            inheritTheme: true,
            ctx: context),
      );
    }
  }
}
