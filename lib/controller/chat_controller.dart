import 'dart:convert';
import 'dart:io';

import 'package:binary_app/model/objects.dart';
import 'package:binary_app/screens/chats/conersation_list.dart';
import 'package:binary_app/screens/chats/conversation_setting.dart';
import 'package:binary_app/utils/util_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class ChatController {
  final uuid = Uuid();
  CollectionReference chats_groups =
      FirebaseFirestore.instance.collection('chats_groups');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference conversations =
      FirebaseFirestore.instance.collection('conversations');
  CollectionReference zoomLinks =
      FirebaseFirestore.instance.collection('zoo_link');
  CollectionReference userzoomLinks =
      FirebaseFirestore.instance.collection('user_zoo_link');

  CollectionReference messageCollection =
      FirebaseFirestore.instance.collection('message');
  //retreive chat groups
  Stream<QuerySnapshot> getGroups() {
    // return users.where('uid',)
    return chats_groups.where('status', isEqualTo: 0).snapshots();
  }

  Future<ConversationModel> createConversation(
      UserModel user, UserModel peeruser) async {
    //generate random id

    String docid = conversations.doc().id;
    await conversations
        .doc(docid)
        .set({
          'id': docid,
          'users': [user.uid, user.uid],
          'userArray': [user.toJson(), user.toJson()],
          'lastMessage': "started convocation",
          'lastMessageTime': DateTime.now().toString(),
          'createdBy': user.uid,
          'created_at': DateTime.now(),
        })
        .then((value) => print("conversation Added"))
        .catchError((error) => print("Failed to add conversation: $error"));

    DocumentSnapshot snapshot = await conversations.doc(docid).get();

    return ConversationModel.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  //retrive conversation
  Stream<QuerySnapshot> getConversation(String uid) => conversations
      .orderBy('created_at', descending: true)
      .where('users', arrayContainsAny: [uid]).snapshots();

//send - retrive message
  Future<void> sendMessage(String conid, String sendarName, String senderid,
      String image, String message, String uid) async {
    try {
      //save message data in db
      await messageCollection.add({
        "id": conid,
        "sendarName": sendarName,
        "senderid": senderid,
        "message": message,
        "image": image,
        "messageUrl": "null",
        "read": "null",
        "messageType": "text",
        "messageTime": DateTime.now().toString(),
        "created_at": DateTime.now(),
      }).then((value) => sendPushNotification(sendarName, message, uid));

//update the conversation
      await conversations.doc(conid).update({
        'lastMessage': message,
        'lastMessageSender': sendarName,
        'lastMessageTime': DateTime.now().toString(),
        'created_at': DateTime.now(),
      });
    } catch (e) {}
  }

  //recieve message stream
  Stream<QuerySnapshot> getMessage(String convid) => messageCollection
      .orderBy('created_at', descending: true)
      .where('id', isEqualTo: convid)
      .snapshots();

  //upload image to th firebase
  UploadTask? uploadFile(File file) {
    try {
      final filename = basename(file.path);
      final destination = "bxlChatImages/$filename";
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<void> captionWithImage(
      String conid, File img, String caption, UserModel userModel) async {
    try {
      //save message data in db
      var orderRef = await messageCollection.add({
        "id": conid,
        "sendarName": userModel.fname,
        "senderid": userModel.uid,
        "message": caption,
        "image": userModel.image,
        "messageUrl": "null",
        "messageType": "image",
        "messageTime": DateTime.now().toString(),
        "created_at": DateTime.now(),
      });

//update the conversation
      await conversations.doc(conid).update({
        'lastMessage': caption,
        'lastMessageSender': userModel.fname,
        'lastMessageTime': DateTime.now().toString(),
        'created_at': DateTime.now(),
      });

      UploadTask? task = uploadFile(img);
      final snapshot = await task!.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await messageCollection.doc(orderRef.id).update({
        "messageUrl": downloadUrl,
      });
    } catch (e) {}
  }

  Future<ZomLinkModel> getZommLinks(String docId) async {
    // String docid = zoomLinks.doc(docId).get();
    DocumentSnapshot snapshot = await zoomLinks.doc(docId).get();

    if (snapshot.data() != null) {
      ZomLinkModel zoomlinks =
          ZomLinkModel.fromJson(snapshot.data() as Map<String, dynamic>);

      return zoomlinks;
    } else {
      ZomLinkModel zoomlink = ZomLinkModel(group_id: "", zoom_links: []);
      return zoomlink;
    }
  }

  Future<UserZoomLinkModel> getUserZommLinks(String docId) async {
    DocumentSnapshot snapshot = await userzoomLinks.doc(docId).get();

    if (snapshot.data() != null) {
      UserZoomLinkModel userzoomLinks =
          UserZoomLinkModel.fromJson(snapshot.data() as Map<String, dynamic>);

      return userzoomLinks;
    } else {
      UserZoomLinkModel? zoomlink;
      return zoomlink!;
    }
  }

  Future<void> setAssAdmin(BuildContext context, docId) async {
    await users.doc(docId).update({'roleid': '1'}).then((value) {});
    UtilFuntions.pageTransition(
        context, const ConversationList(), const ConversationSettings());
  }

  Future<void> unsetAssAdmin(BuildContext context, docId) async {
    await users.doc(docId).update({'roleid': '2'}).then((value) {});
    UtilFuntions.pageTransition(
        context, const ConversationList(), const ConversationSettings());
  }

  Future<ConversationModel> createConversationWithAdmins(
      UserModel user, UserModel peeruser) async {
    var nlist = [user.uid, peeruser.uid];
    var sortedcid = nlist..sort();
    final docid = uuid.v5(Uuid.NAMESPACE_URL, sortedcid.toString());
    //generate random id

    // String docid = conversations.doc().id;
    await conversations
        .doc(docid)
        .set({
          'id': docid,
          'users': [user.uid, peeruser.uid],
          'userArray': [user.toJson(), peeruser.toJson()],
          'lastMessage': "started convocation",
          'lastMessageTime': DateTime.now().toString(),
          'createdBy': user.uid,
          'created_at': DateTime.now(),
          'conversation_name': 'null',
          'description': '',
          'image': '',
          'status': 0,
          'type': "1",
          'lastMessageSender': ''
        })
        .then((value) => print("conversation Added"))
        .catchError((error) => print("Failed to add conversation: $error"));

    DocumentSnapshot snapshot = await conversations.doc(docid).get();

    return ConversationModel.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  Future<void> sendPushNotification(
      String title, String message, String uid) async {
    try {
      // var url = Uri.https('example.com', 'whatsit/create');
      final body = {
        'to': uid,
        'notification': {
          "title": title,
          "body": message,
        }
      };
      var response =
          await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'key=AAAAQW7i1Ec:APA91bEKXeJzuOTqyVsC-tKnAyAJ_B4qFcZtChXtWXr29mIJp50ZLcVHFYdsDBaoJ1nM8BhYRTV8W_VbiY-4xMW-Z7S1s0uGpeyI9Gkrjv1mjb-FStqpOatDYNevmPgNMaFPQZr36vhC'
              },
              body: jsonEncode(body));
      Logger().d('Response status: ${response.statusCode}');
      Logger().d('Response body: ${response.body}');
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<int> getCount(String convid) async {
    final int documentCount;
    try {
      final CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('message');
      final QuerySnapshot snapshot =
          await collectionRef.where('id', isEqualTo: convid).get();
      documentCount = snapshot.size;
      return documentCount;
    } catch (e) {
      return 0;
    }
  }
}
