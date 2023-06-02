import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:binary_app/model/objects.dart';
import 'package:binary_app/provider/chat_provider.dart';
import 'package:binary_app/provider/user_provider.dart';
import 'package:binary_app/screens/Chat/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/custom_dialog.dart';

class ConversationSettings extends StatefulWidget {
  const ConversationSettings({
    Key? key,
  }) : super(key: key);

  @override
  State<ConversationSettings> createState() => _ConversationSettingsState();
}

class _ConversationSettingsState extends State<ConversationSettings> {
  final ScrollController _scrollController = ScrollController();
  final int _batchSize = 15;
  bool _loading = false;
  List<dynamic> _displayData = [];

  late List<UserModel?> userModel;

  var top = 0.0;
  late ScrollController _scrolController;

  @override
  void initState() {
    super.initState();
    _scrolController = ScrollController();
    _scrollController.addListener(_scrollListener);
    userModel = Provider.of<ChatProvider>(context, listen: false).geGroupusers;

    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadData();
    }
  }

  void _loadData() async {
    if (_loading) {
      return;
    }
    setState(() {
      _loading = true;
    });
    int displayDataLength = _displayData.length;
    int remainingDataLength = userModel.length - displayDataLength;
    int nextBatchSize =
        remainingDataLength >= _batchSize ? _batchSize : remainingDataLength;
    List<dynamic> nextBatch = userModel
        .getRange(displayDataLength, displayDataLength + nextBatchSize)
        .toList();
    setState(() {
      _loading = false;
      _displayData.addAll(nextBatch);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrolController,
            slivers: [
              SliverAppBar(
                backgroundColor: HexColor("#283890"),
                pinned: true,
                leading: AnimatedOpacity(
                  opacity: top <= 130 ? 0.0 : 1.0,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    color: Colors.black,
                  ),
                  duration: const Duration(milliseconds: 300),
                ),
                expandedHeight: 250,
                flexibleSpace: Consumer<ChatProvider>(
                  builder: (context, value, child) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        top = constraints.biggest.height;
                        return FlexibleSpaceBar(
                          centerTitle: true,
                          title: AnimatedOpacity(
                            opacity: top <= 130 ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 12,
                                ),
                                CircleAvatar(
                                  minRadius: 10,
                                  maxRadius: 18,
                                  backgroundImage: NetworkImage(
                                    value.conv.image,
                                    // "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(value.conv.conversation_name),
                              ],
                            ),
                          ),
                          background: Hero(
                            tag: "profgroup" + value.getHeroVal.toString(),
                            child: Image.network(
                              value.conv.image,
                              // "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(child: Consumer2<ChatProvider, UserProvider>(
                builder: (context, value, value2, child) {
                  return SizedBox(
                    // height: size.height,
                    child: Column(
                      children: [
                        Card(
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              width: size.width,
                              // height: size.height / 6,
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("info"),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  value.conv.description != ""
                                      ? Text(value.conv.description)
                                      : const Text(""),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              width: size.width,
                              // height: size.height / 6,
                              color: Colors.white,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(0),
                                primary: false,
                                shrinkWrap: true,
                                itemCount: value.getCurrentUserZoomLinks.length,
                                itemBuilder: (BuildContext context, index) =>
                                    ListTile(
                                  leading: value.getCurrentUserZoomLinks[index]
                                                  ['status']
                                              .toString() !=
                                          "-1"
                                      ? Link(
                                          uri: Uri.parse(value
                                              .getCurrentUserZoomLinks[index]
                                                  ['zoom_link']
                                              .toString()),
                                          target: LinkTarget.blank,
                                          builder: (BuildContext ctx,
                                              FollowLink? openLink) {
                                            return TextButton.icon(
                                              onPressed: openLink,
                                              label: Text(
                                                  "Zoom link ${index + 1}"),
                                              icon: const Icon(Icons.read_more),
                                            );
                                          },
                                        )
                                      : Text("Zoom link ${index + 1}"),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 800,
                          // color: Colors.red,
                          child:
                              // Text("^^"+_displayData.length.toString());
                              ListView.builder(
                            itemCount: _displayData.length + (_loading ? 1 : 0),
                            itemBuilder: (BuildContext context, int index) {
                              if (index == _displayData.length) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                var item = _displayData[index];
                                return ListTile(
                                  leading: item.image == "null"
                                      ? InkWell(
                                          onTap: () {
                                            if (value2.getuserModel.roleid ==
                                                "0") {
                                              if (item.uid !=
                                                  auth.currentUser!.uid) {
                                                if (item.roleid == "1") {
                                                  confirmAdminDelete(
                                                      value, index);
                                                } else {
                                                  confirmSetAdmin(value, index);
                                                }
                                              }
                                            } else {
                                              DialogBox().dialogBox(
                                                  context,
                                                  DialogType.INFO,
                                                  'Hellow',
                                                  'This feature only for owner',
                                                  () {});
                                            }
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(45),
                                            child: Image.asset(
                                              "assets/avatar.jpg",
                                              height: 45,
                                              width: 45,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            if (value2.getuserModel.roleid ==
                                                "0") {
                                              if (item.uid !=
                                                  auth.currentUser!.uid) {
                                                if (item.roleid == "1") {
                                                  AwesomeDialog(
                                                    context: context,
                                                    title: 'Hello',
                                                    desc:
                                                        'Are you sure want to delete admin previlage',
                                                    btnCancelOnPress: () {},
                                                    btnOkOnPress: () async {
                                                      value.unsetAssAdmin(
                                                          context,
                                                          value
                                                              .geGroupusers[
                                                                  index]
                                                              .uid);
                                                    },
                                                  ).show();
                                                } else {
                                                  AwesomeDialog(
                                                    context: context,
                                                    title: 'Hello',
                                                    desc:
                                                        'Are you sure want to set admin previlage',
                                                    btnCancelOnPress: () {},
                                                    btnOkOnPress: () async {
                                                      value.setAssAdmin(
                                                          context,
                                                          value
                                                              .geGroupusers[
                                                                  index]
                                                              .uid);
                                                    },
                                                  ).show();
                                                }
                                              }
                                            } else {
                                              DialogBox().dialogBox(
                                                  context,
                                                  DialogType.INFO,
                                                  'Hellow',
                                                  'This feature only for owner',
                                                  () {});
                                            }
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(45),
                                            child: Image.network(
                                              item.image,
                                              height: 45,
                                              width: 45,
                                              fit: BoxFit.fill,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }

                                                return const SkeletonAvatar(
                                                  style: SkeletonAvatarStyle(
                                                    width: 45,
                                                    height: 45,
                                                  ),
                                                );
                                              },
                                            ),
                                          )),
                                  title: GestureDetector(
                                    onTap: () {
                                      item.roleid == "1" || item.roleid == "0"
                                          ? value.createConversationWithAdmins(
                                              context,
                                              value2.getuserModel,
                                              item)
                                          : null;
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item.fname.toString() +
                                            " " +
                                            item.lname.toString()),
                                        item.roleid == "1" || item.roleid == "0"
                                            ? Text(
                                                item.email.toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                  trailing: Wrap(
                                    spacing: 12, // space between two icons
                                    children: item.roleid == "1" ||
                                            item.roleid == "0"
                                        ? <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                launch("tel://${item.phone}");
                                              },
                                              child: const Icon(
                                                Icons.call,
                                                color: Color.fromARGB(
                                                    255, 12, 156, 17),
                                              ),
                                            ), // icon-1

                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.green),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 2),
                                                child: Text(
                                                  'Admin',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 10,
                                                    color: Colors.green[900],
                                                  ),
                                                ),
                                              ),
                                            ), // icon-2
                                          ]
                                        : <Widget>[],
                                  ),
                                );
                              }
                            },
                            controller: _scrollController,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )),
            ],
          ),
          _buildFab(),
        ],
      ),
    );
  }

  confirmAdminDelete(ChatProvider value, int index) {
    AwesomeDialog(
      context: context,
      title: 'Hello',
      desc: 'Are you sure want to delete admin previlage',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        value.unsetAssAdmin(context, value.geGroupusers[index].uid);
      },
    ).show();
  }

  confirmSetAdmin(ChatProvider value, int index) {
    AwesomeDialog(
      context: context,
      title: 'Hello',
      desc: 'Are you sure want to set admin previlage',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        value.setAssAdmin(context, value.geGroupusers[index].uid);
      },
    ).show();
  }

  Widget _buildFab() {
    const double defaultMargin = 265;
    const double defaultStart = 220;
    const double defaultEnd = defaultStart / 2;
    double top = defaultMargin;
    double scale = 1.0;
    if (_scrolController.hasClients) {
      double offset = _scrolController.offset;
      top -= offset;
      if (offset < defaultMargin - defaultStart) {
        scale = 1.0;
      } else if (offset < defaultStart - defaultEnd) {
        scale = (defaultMargin - defaultEnd - offset) / defaultEnd;
      } else {
        scale = 0.0;
      }
    }
    return Positioned(
      top: top,
      right: 16,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(scale),
        child: SizedBox(
          width: 40,
          height: 40,
          child: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.camera_alt_outlined),
            backgroundColor: Colors.blue,
            splashColor: Colors.yellow,
          ),
        ),
      ),
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }
}
