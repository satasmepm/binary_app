import 'dart:io';

import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:binary_app/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

// import '../model/objects.dart';
import 'package:path/path.dart';

import '../model/objects.dart';
import '../screens/components/custom_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as p;

class UserController {
  // Create a collection refferance
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference conversations =
      FirebaseFirestore.instance.collection('conversations');
  UserModel? _userModel;

  Future<UserModel> getUserData(BuildContext context, String id) async {
    DocumentSnapshot snapshot = await users.doc(id).get();
    // Logger().i(snapshot.data());
    UserModel userModel =
        UserModel.fromJson(snapshot.data() as Map<String, dynamic>);

    return userModel;
  }

  Future<UserModel> updateUserWithImage(File img, UserModel? userModel) async {
    _userModel = userModel!;
    UploadTask? task = uploadFile(img);
    final snapshot = await task!.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();

    await users.doc(userModel.uid).update({
      'email': userModel.email,
      'fname': userModel.fname,
      'lname': userModel.lname,
      'uid': userModel.uid,
      'image': downloadUrl,
    }).then((value) async {
      DocumentSnapshot snapshot = await users.doc(userModel!.uid).get();
      // result = 1;
      // Logger().d(snapshot.data());
      userModel = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    });
    return userModel!;
  }

  UploadTask? uploadFile(File file) {
    try {
      final fileName = p.basename(file.path);
      final destination = 'Users/$fileName';
      final user = FirebaseStorage.instance.ref(destination);

      return user.putFile(file);
    } catch (e) {
      Logger().i(e);
      return null;
    }
  }

  Future<UserModel> updateUser(
      BuildContext context,
      String fname,
      String lnane,
      String email,
      String phone,
      String homenumber,
      String address,
      String uid) async {
    Provider.of<UserProvider>(context, listen: false).setLoading(true);

    FirebaseAuth.instance.currentUser?.updateEmail(email).then((value) {
      users.doc(uid).update({
        'fname': fname,
        'lname': lnane,
        'email': email,
        'phone': phone,
        'homenumber': homenumber,
        'address': address,
      }).then((value) async {
        DialogBox().dialogBox(
            context, DialogType.SUCCES, 'SUCCESS', 'Profile updated', () {});
        Provider.of<UserProvider>(context, listen: false).setLoading();
        // return _userModel!;

        // Provider.of<UserProvider>(context, listen: false).profileComplete();
        DocumentSnapshot snapshot = await users.doc(uid).get();
        _userModel =
            UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
        print("User updated");
        Provider.of<UserProvider>(context, listen: false).profileComplete();
      }).catchError((error) => print("Failed to add user: $error"));
      Provider.of<UserProvider>(context, listen: false).setLoading();
    });

    // Provider.of<UserProvider>(context, listen: false).profileComplete();
    return _userModel!;
  }

  Future<void> addUserToConv(BuildContext context, UserModel? userModel,
      UserModel? tempuserModel) async {
    bool isContained = false;
    var docid = "l5rpAUCIXQiBHOHq7tJl";
    QuerySnapshot abc = await FirebaseFirestore.instance
        .collection("conversations")
        .where('id', isEqualTo: docid)
        .where("users", arrayContains: userModel!.uid)
        .get();
    // late ConversationModel conversationModel;
    // int indexof = 0;
    for (var item in abc.docs) {
      // conversationModel =
      //     ConversationModel.fromJson(item.data() as Map<String, dynamic>);
      isContained = true;
      // indexof = conversationModel.users.indexOf(userModel.uid);

    }

    if (isContained == false) {
      await conversations
          .doc(docid)
          .update({
            "users": FieldValue.arrayUnion([userModel.uid]),
            "userArray": FieldValue.arrayUnion([userModel.toJson()])
          })
          .then((value) {})
          // .then((value) =>
          //     print("conversation Added user cpntroller is contained"))
          .catchError((error) => print("Failed to add conversation: $error"));
    } else {
      // await FirebaseFirestore.instance
      //     .collection('conversations')
      //     .doc(docid)
      //     .update({
      //   "users": FieldValue.arrayUnion([userModel.uid]),
      //   "userArray": FieldValue.arrayRemove([userModel.toJson()])
      // });

    }
    if (isContained == true) {
      if (identical(userModel, tempuserModel)) {
      } else {
        await FirebaseFirestore.instance
            .collection('conversations')
            .doc(docid)
            .update({
          "users": FieldValue.arrayUnion([userModel.uid]),
          "userArray": FieldValue.arrayRemove([userModel.toJson()])
        });
      }
    }
  }

  Future<int> getCourseCount() async {
    int count = await FirebaseFirestore.instance
        .collection('course')
        .get()
        .then((value) => value.size);
    return count;
  }

  Future<int> getVideoCount() async {
    int count = await FirebaseFirestore.instance
        .collection('videos')
        .get()
        .then((value) => value.size);
    return count;
  }

  Future<UserModel> uploadUserNicFile(
      File imgfront, File imgback, String uid) async {
    late UserModel userModel;

    UploadTask? taskf = uploadNICFile(imgfront);
    UploadTask? taskb = uploadNICFile(imgback);
    final snapshotf = await taskf!.whenComplete(() {});
    final snapshotb = await taskb!.whenComplete(() {});
    final downloadUrlf = await snapshotf.ref.getDownloadURL();
    final downloadUrlb = await snapshotb.ref.getDownloadURL();

    await users.doc(uid).update({
      'nicfront': downloadUrlf,
      'nicback': downloadUrlb,
    }).then((value) async {
      DocumentSnapshot snapshot = await users.doc(uid).get();

      userModel = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);

      return userModel;
    });
    return userModel;
  }

  UploadTask? uploadNICFile(File file) {
    try {
      final fileName = basename(file.path);
      final destination = 'NIC/$fileName';
      final user = FirebaseStorage.instance.ref(destination);

      return user.putFile(file);
    } catch (e) {
      Logger().i(e);
      return null;
    }
  }

  Future<void> uploadSignatureFile(Uint8List? img, String uid) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final String picture =
        "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
    final destination = 'Signature/$picture';
    UploadTask task = storage.ref(destination).putData(img!);

    final snapshot = await task.whenComplete(() {});
    final downloadurl = await snapshot.ref.getDownloadURL();

    await users.doc(uid).update({
      'signature': downloadurl,
    }).then((value) async {
      DocumentSnapshot snapshot = await users.doc(uid).get();
    }).catchError((error) => print("Failed to add user: $error"));
  }

  UploadTask? uploadSignature(File file) {
    try {
      final fileName = basename(file.path);
      final destination = 'Signature/$fileName';
      final user = FirebaseStorage.instance.ref(destination);

      return user.putFile(file);
    } catch (e) {
      Logger().i(e);
      return null;
    }
  }

  Future<String> getMaxId(BuildContext context) async {
    var abc = await FirebaseFirestore.instance
        .collection("users")
        .orderBy('createdat')
        .limitToLast(1)
        .get();
    String stuid = "";
    for (var item in abc.docs) {
      UserModel model = UserModel.fromJson(item.data());

      stuid = model.stunumber;
    }

    String MaxId = "10000";
    if (stuid != "") {
      int maxId = int.parse(stuid);
      MaxId = (maxId + 1).toString();
    }

    // int maxId = int.parse(stuid);

    return MaxId;
  }

  Future<void> addRoConversationNewObject(
      UserModel? userModel, UserModel? tempuserModel) async {
    Logger().d(".......................................... new " +
        userModel!.toJson().toString());

    Logger().d(".......................................... temper " +
        tempuserModel!.toJson().toString());
    bool isContained = false;
    var docid = "l5rpAUCIXQiBHOHq7tJl";

    await FirebaseFirestore.instance
        .collection('conversations')
        .doc(docid)
        .update({
      "userArray": FieldValue.arrayRemove([tempuserModel.toJson()])
    });

    await FirebaseFirestore.instance
        .collection('conversations')
        .doc(docid)
        .update({
      "userArray": FieldValue.arrayUnion([userModel.toJson()])
    });
  }

  Future<void> updateOnline(String uid) {
    return users
        .doc(uid)
        .update({
          "isOnline": true,
          "lastSeen": DateTime.now().toString(),
        })
        .then((value) => Logger().i("Online status updated"))
        .catchError(
          (error) => Logger().i("error :  faild to added user status $error"),
        );
  }

  Future<void> updateOffline(String uid) {
    return users
        .doc(uid)
        .update({
          "isOnline": false,
          "lastSeen": DateTime.now().toString(),
        })
        .then((value) => Logger().i("Online status updated"))
        .catchError(
          (error) => Logger().i("error :  faild to added user status $error"),
        );
  }

  Future<String> gerIsOnline(BuildContext context, String id) async {
    DocumentSnapshot ds = await users.doc(id).get();
    Map<String, dynamic> data = ds.data() as Map<String, dynamic>;

    String isOnline = data["isOnline"].toString();

    return isOnline;
  }
}
