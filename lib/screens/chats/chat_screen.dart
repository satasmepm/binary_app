import 'dart:math';

import 'package:binary_app/model/objects.dart';
import 'package:binary_app/provider/chat_provider.dart';
import 'package:binary_app/provider/user_provider.dart';
import 'package:binary_app/screens/Chat/chatScreen.dart';
import 'package:binary_app/screens/chats/chat_image.dart';
import 'package:binary_app/screens/chats/chat_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_text/link_text.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/foundation.dart' as foundation;

import '../../controller/chat_controller.dart';
import '../../utils/util_functions.dart';
import 'conversation_setting.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key, required this.convId, required this.index})
      : super(key: key);

  final String convId;
  final int index;
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final ChatProvider _controller = ChatProvider();
  final TextEditingController _controllerr = TextEditingController();
  final _scrollController = ScrollController();
  final _itemCountPerPage = 12;
  late Stream<QuerySnapshot> _stream;
  int _pageNumber = 0;
  int _count = 0;
  bool emojiShowing = false;
  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance
        .collection('message')
        .orderBy('created_at', descending: true)
        .where('id', isEqualTo: widget.convId)
        .limit(_itemCountPerPage)
        .snapshots();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _pageNumber++;
        _stream = FirebaseFirestore.instance
            .collection('message')
            .orderBy('created_at', descending: true)
            .where('id', isEqualTo: widget.convId)
            .limit(_itemCountPerPage * (_pageNumber + 1))
            .snapshots();
      });
    }
    _count = await ChatController().getCount(widget.convId);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Scaffold(
            backgroundColor: HexColor("#efe7e1"),
            appBar: PreferredSize(
                child: AppBarSection(index: widget.index),
                preferredSize: Size.fromHeight(size.height / 12)),

            body: Stack(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("no messages"),
                      );
                    }
                    // if (snapshot.connectionState == ConnectionState.waiting) {
                    //   return const Center(
                    //     child: CircularProgressIndicator(),
                    //   );
                    // }

                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final items = snapshot.data!.docs;

                    return ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.only(bottom: 60),
                      controller: _scrollController,
                      itemCount: items.length + 1,
                      itemBuilder: (context, index) {
                        if (index == items.length) {
                          if (items.length != _count) {
                            if (items.length > _itemCountPerPage) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        }

                        final item = items[index];

                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Consumer2<UserProvider, ChatProvider>(
                              builder: (context, value, value2, child) {
                                String mystring = item['sendarName'];
                                String upperLeter = mystring[0].toUpperCase();

                                return Column(
                                  children: [
                                    item['senderid'] == value.getuserModel.uid
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              ChatBubble(
                                                clipper: ChatBubbleClipper5(
                                                    type:
                                                        BubbleType.sendBubble),
                                                alignment: Alignment.topRight,
                                                margin: const EdgeInsets.only(
                                                    top: 15),
                                                backGroundColor:
                                                    const Color.fromARGB(
                                                        255, 227, 253, 216),
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                  ),
                                                  child: item['messageType'] !=
                                                          "image"
                                                      ? LinkText(
                                                          item['message'],
                                                          textAlign:
                                                              TextAlign.left,
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontSize: 15),
                                                        )
                                                      : Column(
                                                          children: [
                                                            item['messageUrl'] ==
                                                                    "null"
                                                                ? const Center(
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              30),
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    ),
                                                                  )
                                                                : Image.network(
                                                                    item[
                                                                        'messageUrl'],
                                                                    // height: 45,
                                                                    width: 230,

                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                            LinkText(
                                                              item['message'],
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              textStyle:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                            ),
                                                          ],
                                                        ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                timeago.format(DateTime.parse(
                                                    item['messageTime'])),
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 11,
                                                ),
                                              )
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              value2.conv.conversation_name !=
                                                      "null"
                                                  ? item['image'] == "null"
                                                      ? Container(
                                                          height: 45,
                                                          width: 45,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(Random()
                                                                .nextInt(
                                                                    0xffffffff)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        45),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              upperLeter,
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 30,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(45),
                                                          child: Image.network(
                                                            item['image'],
                                                            height: 45,
                                                            width: 45,
                                                            fit: BoxFit.fill,
                                                            loadingBuilder:
                                                                (context, child,
                                                                    loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null) {
                                                                return child;
                                                              }

                                                              return const SkeletonAvatar(
                                                                style:
                                                                    SkeletonAvatarStyle(
                                                                  width: 45,
                                                                  height: 45,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        )
                                                  : Container(),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ChatBubble(
                                                    clipper: ChatBubbleClipper1(
                                                        type: BubbleType
                                                            .receiverBubble),
                                                    backGroundColor:
                                                        const Color.fromARGB(
                                                            255, 255, 255, 255),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 15),
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 0),
                                                      constraints:
                                                          BoxConstraints(
                                                        maxWidth: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                      ),
                                                      child:
                                                          item['messageType'] ==
                                                                  "image"
                                                              ? Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      item[
                                                                          'sendarName'],
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            5,
                                                                            121,
                                                                            9),
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Image
                                                                        .network(
                                                                      item[
                                                                          'messageUrl'],
                                                                      // height: 45,
                                                                      width:
                                                                          230,

                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    LinkText(
                                                                      item[
                                                                          'message'],
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      textStyle:
                                                                          const TextStyle(
                                                                              fontSize: 15),
                                                                      // You can optionally handle link tap event by yourself
                                                                      // onLinkTap: (url) => ...
                                                                    ),
                                                                  ],
                                                                )
                                                              : Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      item[
                                                                          'sendarName'],
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            5,
                                                                            121,
                                                                            9),
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                    ),
                                                                    LinkText(
                                                                      item[
                                                                          'message'],
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      textStyle:
                                                                          const TextStyle(
                                                                              fontSize: 15),
                                                                      // You can optionally handle link tap event by yourself
                                                                      // onLinkTap: (url) => ...
                                                                    ),
                                                                  ],
                                                                ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15, top: 5),
                                                    child: Text(
                                                      timeago.format(
                                                          DateTime.parse(item[
                                                              'messageTime'])),
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: size.width,
                    // height: size.height / 16,
                    color: Colors.white,
                    child: Consumer2<ChatProvider, UserProvider>(
                      builder: (context, value, value2, child) {
                        return Row(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 8, bottom: 8, right: 8),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    emojiShowing = !emojiShowing;
                                  });
                                },
                                icon: const Icon(Ionicons.happy_outline,
                                    size: 30, color: Colors.grey),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: value.messageController,
                                onChanged: (text) {
                                  value.updateRightDoorLock(text);
                                },
                                //  maxLines: 4,
                                minLines: 1,
                                maxLines: 5,
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Message",
                                ),
                              ),
                              // Text("sdsad")
                            ),
                            InkWell(
                              onTap: () {
                                if (value.conv.conversation_name == "null") {
                                  value.sendMessage(
                                      context,
                                      value.conv.userArray
                                          .firstWhere((element) =>
                                              element.uid !=
                                              value2.getuserModel.uid)
                                          .uid);
                                } else {
                                  value.sendMessage(context, "");
                                }

                                value.messageController.clear();
                              },
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: value.isRightDoorLock
                                    ? const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Ionicons.send,
                                          size: 22,
                                          color: Colors.blueAccent,
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: ((builder) =>
                                                BottomSheet(size: size)),
                                          );
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 12),
                                          child: Icon(
                                            Ionicons.camera_outline,
                                            size: 22,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Offstage(
                  offstage: !emojiShowing,
                  child: SizedBox(
                      height: 250,
                      child: EmojiPicker(
                        textEditingController: _controllerr,
                        config: Config(
                          columns: 7,
                          // Issue: https://github.com/flutter/flutter/issues/28894
                          emojiSizeMax: 32 *
                              (foundation.defaultTargetPlatform ==
                                      TargetPlatform.iOS
                                  ? 1.30
                                  : 1.0),
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          gridPadding: EdgeInsets.zero,
                          initCategory: Category.RECENT,
                          bgColor: const Color(0xFFF2F2F2),
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          backspaceColor: Colors.blue,
                          skinToneDialogBgColor: Colors.white,
                          skinToneIndicatorColor: Colors.grey,
                          enableSkinTones: true,
                          showRecentsTab: true,
                          recentsLimit: 28,
                          replaceEmojiOnLimitExceed: false,
                          noRecents: const Text(
                            'No Recents',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black26),
                            textAlign: TextAlign.center,
                          ),
                          loadingIndicator: const SizedBox.shrink(),
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL,
                          checkPlatformCompatibility: true,
                        ),
                      )),
                ),
              ],
            ),

            // bottomNavigationBar:
          );
        });
  }
}

class AppBarSection extends StatelessWidget {
  const AppBarSection({
    required this.index,
    Key? key,
  }) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor("#283890"),
      padding: const EdgeInsets.only(left: 0, right: 20, top: 30),
      child: Consumer2<ChatProvider, UserProvider>(
        builder: (context, value, value2, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 0, right: 0, bottom: 10, top: 10),
                    // height: 25,
                    // width: 25,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent),
                    child: Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                          padding: const EdgeInsets.only(
                              left: 0, right: 0, top: 3, bottom: 3),
                          icon: const Icon(
                            MaterialCommunityIcons.chevron_left,
                            color: Colors.white,
                            size: 30,
                          ),
                          color: Colors.black,
                          onPressed: () {
                            UtilFuntions.goBack(context);
                          },
                          tooltip: MaterialLocalizations.of(context)
                              .openAppDrawerTooltip,
                        );
                      },
                    ),
                  ),
                  value.conv.conversation_name != "null"
                      ? InkWell(
                          onTap: () {
                            value.setHeroValue(index);
                            UtilFuntions.pageTransition(
                                context,
                                const ConversationSettings(),
                                const Chat(convId: "", index: 1));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Hero(
                              tag: "profgroup$index",
                              child: Image.network(
                                value.conv.image,
                                height: 45,
                                width: 45,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: Hero(
                            tag: "profgroup$index",
                            child: Image.network(
                              value.conv.userArray
                                  .firstWhere((element) =>
                                      element.uid != value2.getuserModel.uid)
                                  .image,
                              height: 45,
                              width: 45,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        value.conv.conversation_name != "null"
                            ? Text(
                                value.conv.conversation_name,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            : Text(
                                value.conv.userArray
                                        .firstWhere((element) =>
                                            element.uid !=
                                            value2.getuserModel.uid)
                                        .fname +
                                    " " +
                                    value.conv.userArray
                                        .firstWhere((element) =>
                                            element.uid !=
                                            value2.getuserModel.uid)
                                        .lname,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                        SizedBox(height: 5),
                        value.conv.conversation_name != "null"
                            ? Text(
                                // "30 members",
                                "${value.conv.users.length} members",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[200]),
                              )
                            : Text(
                                // "30 members",
                                "${value.getOnline}",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: value.getOnline == "online"
                                        ? Colors.green[200]
                                        : Colors.grey),
                              )
                      ],
                    ),
                  ),
                ],
              ),
              const Icon(
                MaterialCommunityIcons.dots_vertical,
                color: Colors.white,
                size: 20,
              )
            ],
          );
        },
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: 278,
      width: size.width,
      child: Card(
        margin: const EdgeInsets.all(18),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Consumer<ChatProvider>(
              builder: (context, value, child) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        iconcreation(
                          Icons.insert_drive_file,
                          Colors.indigo,
                          "Document",
                          () {
                            //  value.takePhoto(ImageSource.gallery);
                          },
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        iconcreation(
                          Icons.camera_alt,
                          Colors.pink,
                          "Camera",
                          () {
                            value.takePhoto(ImageSource.camera);
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        iconcreation(
                          Icons.insert_photo,
                          Colors.purple,
                          "Gallery",
                          () {
                            value.takePhoto(ImageSource.gallery);
                            Navigator.pop(context);
                            UtilFuntions.pageTransition(
                                context, const ChatImage(), const ChatMain());
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        iconcreation(
                          Icons.headset,
                          Colors.orange,
                          "Audio",
                          () {
                            //  value.takePhoto(ImageSource.camera);
                          },
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        iconcreation(
                          Icons.location_pin,
                          Colors.red,
                          "Location",
                          () {
                            //  value.takePhoto(ImageSource.camera);
                          },
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        iconcreation(
                          Icons.person,
                          Colors.blue,
                          "Contact",
                          () {
                            //  value.takePhoto(ImageSource.camera);
                          },
                        ),
                      ],
                    )
                  ],
                );
              },
            )),
      ),
    );
  }

  Widget iconcreation(
      IconData icon, Color color, String text, Function() onTap) {
    return Consumer<UserProvider>(
      builder: (context, value, child) {
        return Column(
          children: [
            InkWell(
              onTap: onTap,
              child: CircleAvatar(
                radius: 28,
                backgroundColor: color,
                child: Icon(
                  icon,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      },
    );
  }
}
