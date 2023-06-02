import 'package:binary_app/screens/Video/search_video.dart';
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

import '../../provider/corse_provider.dart';
import '../../provider/user_provider.dart';
import '../../provider/video_provider.dart';
import '../components/custom_loader.dart';

class Videolist extends StatefulWidget {
  const Videolist({
    Key? key,
    required this.status,
  }) : super(key: key);

  final bool status;
  @override
  _VideolistState createState() => _VideolistState();
}

class _VideolistState extends State<Videolist> {
  var s;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFECF3F9),
        appBar: widget.status != true
            ? AppBar(
                backgroundColor: const Color(0xFFECF3F9),
                elevation: 0,
                title: const Text(
                  "All Videos",
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    // UtilFuntions.pageTransition(
                    //     context,
                    //     const HomeScreen(),
                    //     Videolist(
                    //       status: false,
                    //     ));
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
        body: Consumer<CourseProvider>(
          builder: (context, value, child) {
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
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
                            // UtilFuntions.pageTransition(
                            //     context,
                            //     const SearchVideo(),
                            //     Videolist(
                            //       status: false,
                            //     ));

                            Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: const SearchVideo(),
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
                    value.isLoading
                        ? CustomLoader(loadertype: true)
                        : const SizedBox(
                            height: 10,
                          ),
                    Vlist(),
                  ],
                ),
              ),
            );
          },
        ));
  }

  Widget Vlist() {
    var size = MediaQuery.of(context).size;
    int i = 0;
    int columnCount = 1;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("videos")
            .where('status', isEqualTo: 0)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                /*    child: SpinKitRing(
                  color: Colors.blue,
                )*/
                );
            //  Center(child: LoadingFilling.square());
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SizedBox(
              height: size.height,
              child: AnimationLimiter(
                child: GridView.count(
                    childAspectRatio: (1 / 0.8),
                    crossAxisCount: columnCount,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 170),
                    // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //   crossAxisCount: 2,
                    //   crossAxisSpacing: 10,
                    //   mainAxisSpacing: 12,
                    //   childAspectRatio: (1 / 1.15),
                    // ),
                    children: snapshot.data!.docs.map((docReference) {
                      i++;
                      var coursePrice = NumberFormat("###.00#", "en_US");
                      String price =
                          coursePrice.format(double.parse(docReference['Fee']));

                      String id = docReference.id;
                      return AnimationConfiguration.staggeredGrid(
                        position: i,
                        duration: const Duration(milliseconds: 375),
                        columnCount: columnCount,
                        child: SlideAnimation(
                          child: SlideAnimation(
                            child: Consumer3<CourseProvider, UserProvider,
                                VideoProvider>(
                              builder: (context, value, value2, value3, child) {
                                return GestureDetector(
                                  onTap: () {
                                    value3.fetchSingleVideo(
                                        context, docReference.id);
                                    isPaied(
                                        docReference.id,
                                        docReference['vurl'],
                                        docReference['Fee'],
                                        docReference['corse_id'],
                                        value,
                                        value2);
                                  },
                                  child: Card(
                                    elevation: 10,
                                    shadowColor: Colors.grey.withOpacity(0.08),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Stack(
                                          children: <Widget>[
                                            //Center(child: CircularProgressIndicator()),
                                            Center(
                                              child: SizedBox(
                                                width: size.width,
                                                height: size.height / 4.4,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft: Radius.circular(5),
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
                                              Text(
                                                docReference['VideoName'],
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                docReference['Duration'],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 10,
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
                                              docReference['Fee'] != "0"
                                                  ? Text(
                                                      "Rs ${price.toString()}",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                    )
                                                  : Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8),
                                                      decoration: BoxDecoration(
                                                          color: const Color
                                                                  .fromARGB(255,
                                                              250, 233, 182),
                                                          // border: Border.all(
                                                          //     color: Color.fromARGB(
                                                          //         255, 250, 233, 182)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3)),
                                                      child: Text(
                                                        "Free",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }).toList()),
              ),
            ),
          );
        });
  }

  void isPaied(String id, String vid, String fee, String courseid,
      CourseProvider value, UserProvider value2) async {
    await value.getcoursebyid(courseid, vid, value2.getuserModel, context);
    value.setPrice(fee);
  }
}
