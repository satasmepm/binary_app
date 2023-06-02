import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:link_text/link_text.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../provider/corse_provider.dart';
import '../../provider/user_provider.dart';
import '../../provider/video_provider.dart';
import '../../utils/util_functions.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    Key? key,
    required this.status,
  }) : super(key: key);
  final bool status;
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xFFECF3F9),
        appBar: widget.status != true
            ? AppBar(
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
                        tooltip: MaterialLocalizations.of(context)
                            .openAppDrawerTooltip,
                      );
                    },
                  ),
                ),
              )
            : null,
        body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('notification').snapshots(),
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
        elevation: 0,
        shadowColor: Colors.grey.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(0),
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
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                    ),
                  ),
                ),
                if (data['image'] != "")
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                    ),
                    child: Image.network(
                      data['image'],
                      // width: size.width / 1,
                      //   // height: height,
                      fit: BoxFit.fill,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;

                        return SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                            width: size.width / 1,
                            height: 200,
                          ),
                        );
                      },
                    ),
                  ),
                Container(
                  // height: 140,
                  width: size.width / 1.1,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: size.width / 1.1,
                              // height: 35,
                              child: Text(
                                data['notification_title'],
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
                              child: LinkText(
                                data['description'],

                                // textAlign: TextAlign.center,
                                // You can optionally handle link tap event by yourself
                                // onLinkTap: (url) => ...
                              ),
                              // Text(
                              //   data['description'],
                              //   style: const TextStyle(
                              //     fontSize: 12,
                              //     color: Colors.black,
                              //   ),
                              // ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              timeago.format(data['created_at'].toDate()),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 10, bottom: 0, top: 5),
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
