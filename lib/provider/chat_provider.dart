import 'dart:convert';
import 'dart:io';

import 'package:binary_app/controller/chat_controller.dart';
import 'package:binary_app/model/objects.dart';
import 'package:binary_app/provider/user_provider.dart';
import 'package:binary_app/screens/Chat/chatScreen.dart';
import 'package:binary_app/screens/chats/chat_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

// import '../model/objects.dart';

import '../controller/user_controller.dart';
import '../screens/chats/conersation_list.dart';
import '../utils/util_functions.dart';

class ChatProvider extends ChangeNotifier {
  final UserController _usercontroller = UserController();
  CollectionReference userscol = FirebaseFirestore.instance.collection('users');

  final ChatController _chatController = ChatController();
  late ConversationModel _conversationModel;
  late ZomLinkModel _zoomlinkModel;
  late UserZoomLinkModel _userzoomlinkModel;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  ConversationModel get conv => _conversationModel;
  ZomLinkModel get getZoomlinks => _zoomlinkModel;
  UserZoomLinkModel get getuserZoomlinks => _userzoomlinkModel;

  final TextEditingController _message = TextEditingController();
  TextEditingController get messageController => _message;

  final TextEditingController _caption = TextEditingController();
  TextEditingController get captionController => _caption;

  List<dynamic> zoomLinks = [];
  List<dynamic> get getCurrentUserZoomLinks => zoomLinks;
  bool isRightDoorLock = false;

  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  XFile? get getImageFile => _imageFile;

  File _image = File("");

  int _heroVal = 0;
  int get getHeroVal => _heroVal;

  final List<UserModel> _list = [];
  final List<UserModel> _groupUsers = [];
  List<UserModel> get geGroupusers => _groupUsers;

  String _isOnline = "online";
  String get getOnline => _isOnline;

  void updateRightDoorLock(String val) {
    if (val != "") {
      isRightDoorLock = true;
    } else {
      isRightDoorLock = false;
    }
    notifyListeners();
  }

  void setConv(ConversationModel model) {
    _conversationModel = model;
    notifyListeners();
  }

  //create a conversation function

  Future<void> createConversation(
      BuildContext context, UserModel peermodel) async {
    try {
      //get user model
      UserModel? userModel =
          Provider.of<UserProvider>(context, listen: false).getuserModel;
      _conversationModel =
          await _chatController.createConversation(userModel, peermodel);

      notifyListeners();

      UtilFuntions.pageTransition(
          context, const chatScreen(), const ChatMain());
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> setIsOnline(BuildContext context, String uid) async {
    try {
      String isOnline = await _usercontroller.gerIsOnline(context, uid);
      // documentSnapshot snapshot = await users.doc(id).get();
      _isOnline = isOnline;
      if (isOnline == "true") {
        _isOnline = "online";
      } else {
        _isOnline = "offline";
      }
      notifyListeners();
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> sendMessage(BuildContext context, String uid) async {
    List<String> words = [
      "boru",
      "hora",
      "borukaraya",
      "palhora",
      "bitch",
      "keriya",
      "keri",
      "fuck",
      "Huththa",
      "Pakaya",
      "payya"
    ];
    var string = _message.text;

    bool existed = false;
    for (var item in words) {
      // string.toUpperCase().contains(item.toUpperCase());
      if (string.toUpperCase().contains(item.toUpperCase())) {
        existed = true;
      }
    }

    try {
      if (_message.text.isNotEmpty) {
        if (existed) {
          Fluttertoast.showToast(msg: "Can't chatting this type of words");
        } else {
          UserModel userModel =
              Provider.of<UserProvider>(context, listen: false).getuserModel;
          await _chatController.sendMessage(
              _conversationModel.id,
              userModel.fname,
              userModel.uid,
              userModel.image,
              _message.text,
              uid);
          isRightDoorLock = false;
        }

        notifyListeners();
      } else {
        Logger().e(" Error ");
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  void takePhoto(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source // ImageSource.gallery,
            );

    _imageFile = pickedFile;
    if (pickedFile != null) {
      _image = File(pickedFile.path);

      notifyListeners();
    } else {
      Logger().e("no image selected");
    }

    notifyListeners();
  }

  Future<void> captionWithImage(BuildContext context) async {
    UserModel userModel =
        Provider.of<UserProvider>(context, listen: false).getuserModel;
    // await _chatController.sendMessage(
    //   _conversationModel.id,
    //   userModel.fname ,
    //   userModel.uid,
    //   userModel.image,
    //   _message.text,
    // );
    await _chatController.captionWithImage(
        _conversationModel.id, _image, _caption.text, userModel);

    notifyListeners();
  }

  void setHeroValue(int val) {
    _heroVal = val;

    notifyListeners();
  }

  Future<void> setZoomLinkModel(BuildContext context, String groupId) async {
    try {
      zoomLinks = [];
      _zoomlinkModel = await _chatController.getZommLinks(groupId);

      if (_zoomlinkModel.zoom_links.length > 0) {
        _userzoomlinkModel = await _chatController.getUserZommLinks(groupId);

        for (var i = 0; i < _zoomlinkModel.zoom_links.length; i++) {
          for (var j = 0; j < _userzoomlinkModel.zoom_links.length; j++) {
            if (i == j) {
              String id = j.toString();
              zoomLinks.add({
                "id": id,
                "zoom_link": _zoomlinkModel.zoom_links[i].toString(),
                "status": _userzoomlinkModel.zoom_links[j].toString(),
              });

              notifyListeners();
              // i++;
            }
          }
        }

        notifyListeners();
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> setUsers(List<dynamic> users) async {
    _list.clear();
    _groupUsers.clear();
    // try {
    QuerySnapshot snapshot =
        await userscol.where('status', isEqualTo: "0").get();

    for (var item in snapshot.docs) {
      UserModel model = UserModel.fromJson(item.data() as Map<String, dynamic>);

      _list.add(model);
    }

    for (var i = 0; i < users.length; i++) {
      for (var j = 0; j < _list.length; j++) {
        if (users[i] == _list[j].uid) {
          _groupUsers.add(_list[j]);
        }
      }
    }

    notifyListeners();
    // } catch (e) {
    //   Logger().e(e);
    // }
  }

  Future<void> setAssAdmin(BuildContext context, String docid) async {
    await _chatController.setAssAdmin(context, docid);
    // notifyListeners();
  }

  Future<void> unsetAssAdmin(BuildContext context, String docid) async {
    await _chatController.unsetAssAdmin(context, docid);
    // notifyListeners();
  }

  Future<void> createConversationWithAdmins(BuildContext context,
      UserModel curentusermodel, UserModel peermodel) async {
    try {
      if (curentusermodel.uid != peermodel.uid) {
        _conversationModel = await _chatController.createConversationWithAdmins(
            curentusermodel, peermodel);
        notifyListeners();

        UtilFuntions.pageTransition(
            context, const ConversationList(), const ChatMain());
      }
    } catch (e) {
      Logger().e(e);
    }
  }
}
