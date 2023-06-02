import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../provider/corse_provider.dart';
import '../../provider/user_provider.dart';
import '../../provider/video_provider.dart';
import '../../utils/util_functions.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageById extends StatefulWidget {
  const MessageById({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;
  @override
  State<MessageById> createState() => _MessageByIdState();
}

class _MessageByIdState extends State<MessageById> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xFFECF3F9),
        appBar: AppBar(
          backgroundColor: HexColor("#283890"),
          elevation: 0,
          title: const Text(
            "Mesage",
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          automaticallyImplyLeading: false,
          actions: const [],
          leading: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent),
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
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('inbox_messages')
              .where('id', isEqualTo: widget.id)
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
                                height: 10,
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
                      topLeft: Radius.circular(10),
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
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Lottie.asset(
                            data['type'] == "Alert"
                                ? 'assets/alert.json'
                                : 'assets/warning.json',
                            width: 150,
                            // height: 200,
                            fit: BoxFit.fill,
                          ),
                          Text(
                            data['message_title'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            data['description'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: size.width / 1.1,
                            child: Text(
                              timeago.format(data['created_at'].toDate()),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 10, bottom: 10, top: 5),
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
    );
  }
}

AppBar _appBar() {
  return AppBar(
    backgroundColor: HexColor("#283890"),
    elevation: 0,
    title: const Text(
      "Notifications",
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
