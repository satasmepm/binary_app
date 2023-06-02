import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:logger/logger.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../provider/corse_provider.dart';
import '../../provider/user_provider.dart';
import '../../provider/video_provider.dart';
import '../../utils/util_functions.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'message_by_id.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xFFECF3F9),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('inbox_messages')
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              // .orderBy('created_at', descending: false)
              .snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer3<CourseProvider, UserProvider, VideoProvider>(
                    builder: (context, value, value2, value3, child) {
                      return AnimationLimiter(
                        child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 0,
                              );
                            },
                            itemCount: snapshots.data!.docs.length,
                            itemBuilder: (context, index) {
                              var data = snapshots.data!.docs[index].data()
                                  as Map<String, dynamic>;
                              var docId = snapshots.data!.docs[index].id;

                              return AnimationConfiguration.staggeredList(
                                duration: const Duration(milliseconds: 375),
                                position: index,
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: listCard(size, data),
                                ),
                              );
                            }),
                      );
                    },
                  );
          },
        ));
  }

  GestureDetector listCard(Size size, Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {},
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: MessageById(id: data['id']),
                inheritTheme: true,
                ctx: context),
          );
        },
        child: Card(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: <Widget>[
                  //Center(child: CircularProgressIndicator()),
                  SizedBox(
                    width: size.width / 1,
                    // height: size.height / 9,
                    child: const ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                    ),
                  ),

                  Container(
                    // height: 140,
                    width: size.width / 1.1,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: size.width / 1.3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: size.width / 1.1,
                                  // height: 35,
                                  child: Text(
                                    data['message_title'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: size.width / 1.1,
                                  child: Text(
                                    data['description'],
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  timeago.format(data['created_at'].toDate()),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                  ),
                                )
                              ],
                            ),
                          ),
                          data['type'] == "Alert"
                              ? LeadingIcon(Color.fromARGB(255, 193, 230, 247),
                                  CupertinoIcons.info_circle, Colors.blue)
                              : LeadingIcon(
                                  Color.fromARGB(255, 255, 198, 198),
                                  CupertinoIcons.exclamationmark_triangle,
                                  Colors.red)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8, right: 10, bottom: 0, top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container LeadingIcon(Color color, IconData iconname, Color icon_color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              spreadRadius: 1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          iconname,
          color: icon_color,
        ),
      ),
    );
  }
}
