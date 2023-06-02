import 'package:binary_app/model/course_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import '../model/objects.dart';

// import '../model/objects.dart';

class SlipController {
  final uuid = const Uuid();
  String? cp_id;
  Coursemodel? coursemodel;
  CollectionReference course = FirebaseFirestore.instance.collection('course');

  CollectionReference res =
      FirebaseFirestore.instance.collection('coursepay_details');
  CollectionReference lms_pay_details =
      FirebaseFirestore.instance.collection('lms_pay_details');
  CollectionReference course_pay =
      FirebaseFirestore.instance.collection('course_pay');
  CollectionReference lms_pay =
      FirebaseFirestore.instance.collection('lms_pay');
  CollectionReference video_pay =
      FirebaseFirestore.instance.collection('video_pay');
  // FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  String sp_id = "";
  Future<void> saveSlipData(
      File img, String coursename, String cour_id, UserModel userModel) async {
    // Logger().d("________________ Image path is : " + img.toString());
    //${DateTime.now().toIso8601String() + p.basename(img)}
    UploadTask? task = uploadFile(img);
    final snapshot = await task!.whenComplete(() {});
    final downloadurl = await snapshot.ref.getDownloadURL();

    DateTime now = DateTime.now();
    String day = DateFormat('yyyy-MM-dd').format(now);
    //get the unique document id auto generated
    String docId = res.doc().id;

    QuerySnapshot snapshotCourse =
        await course.where('CourseName', isEqualTo: coursename).get();

    //querying all the docs in this snapshot
    for (var item in snapshotCourse.docs) {
      // mapping to a single model
      coursemodel = Coursemodel.fromJson(item.data() as Map<String, dynamic>);
      //ading to the model

    }

    // var collectionReference = FirebaseFirestore.instance
    //     .collection('corse_pay')
    //     .where('uid', isEqualTo: userModel.uid)
    //     .where('courseName', isEqualTo: coursename);

    //  QuerySnapshot corse_paysnapshot = await course_pay
    // .where('uid', isEqualTo: userModel.uid)
    //  .where('CourseName', isEqualTo: coursename)
    //  .get();

    // QuerySnapshot corse_paysnapshot = await collectionReference.get();
    cp_id = userModel.uid + "" + coursename;

    final cpdocId = uuid.v5(Uuid.NAMESPACE_URL, cp_id);

    DocumentSnapshot snapshot1 = await course_pay.doc(cpdocId).get();

    if (snapshot1.exists == false) {
      await course_pay.doc(cpdocId).set({
        'cpid': cpdocId,
        'courseName': coursename,
        'cour_id': cour_id,
        'courseFee': coursemodel!.CourseFee,
        'uid': userModel.uid,
        'userName': userModel.fname + "" + userModel.lname,
        'email': userModel.email,
        'pay_amount': 0,
        'create_at': day,
        'updated_at': day,
        'user': userModel.toJson(),
        'status': 1,
      }).then((value) async {
        await res.doc(docId).set({
          'cpdid': docId,
          'cpid': cpdocId,
          'courseName': coursename,
          'img': downloadurl,
          'uid': userModel.uid,
          'userName': userModel.fname + "" + userModel.lname,
          'create_at': day,
          'status': 0,
        });
      });
    } else {
      await course_pay.doc(cpdocId).update({
        'updated_at': day,
      }).then((value) async {
        await res.doc(docId).set({
          'cpdid': docId,
          'cpid': cpdocId,
          'courseName': coursename,
          'img': downloadurl,
          'uid': userModel.uid,
          'userName': userModel.fname + "" + userModel.lname,
          'create_at': day,
          'status': 0,
        });
      });
    }
  }

  Future<void> saveLMSSlipData(
      File img, String coursename, UserModel userModel) async {
    UploadTask? task = uploadLMSFile(img);
    final snapshot = await task!.whenComplete(() {});
    final downloadurl = await snapshot.ref.getDownloadURL();
    DateTime now = DateTime.now();
    String day = DateFormat('yyyy-MM-dd').format(now);
    //get the unique document id auto generated
    String docId = lms_pay_details.doc().id;
    QuerySnapshot snapshotCourse =
        await course.where('CourseName', isEqualTo: coursename).get();
    //querying all the docs in this snapshot
    for (var item in snapshotCourse.docs) {
      // mapping to a single model
      coursemodel = Coursemodel.fromJson(item.data() as Map<String, dynamic>);
      //ading to the model
    }
    cp_id = userModel.uid + "" + coursename;
    final cpdocId = uuid.v5(Uuid.NAMESPACE_URL, cp_id);
    DocumentSnapshot snapshot1 = await lms_pay.doc(cpdocId).get();

    if (snapshot1.exists == false) {
      await lms_pay.doc(cpdocId).set({
        'cpid': cpdocId,
        'courseName': coursename,
        'lmsFee': coursemodel!.lmsFee,
        'uid': userModel.uid,
        'userName': userModel.fname + "" + userModel.lname,
        'email': userModel.email,
        'pay_amount': 0,
        'create_at': day,
        'updated_at': day,
        'user': userModel.toJson(),
        'img': downloadurl,
        'status': 1,
      }).then((value) async {
        await lms_pay_details.doc(docId).set({
          'cpdid': docId,
          'cpid': cpdocId,
          'courseName': coursename,
          'img': downloadurl,
          'uid': userModel.uid,
          'userName': userModel.fname + "" + userModel.lname,
          'create_at': day,
          'status': 0,
        });
      });
    } else {
      await lms_pay.doc(cpdocId).update({
        'updated_at': day,
      }).then((value) async {
        await lms_pay_details.doc(docId).set({
          'cpdid': docId,
          'cpid': cpdocId,
          'courseName': coursename,
          'img': downloadurl,
          'uid': userModel.uid,
          'userName': userModel.fname + "" + userModel.lname,
          'create_at': day,
          'status': 0,
        });
      });
    }

    Logger().i(downloadurl);
  }

//upload image to th firebase
  UploadTask? uploadFile(File file) {
    try {
      final filename = p.basename(file.path);
      final destination = "paymentslip/$filename";
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  //upload image to th firebase
  UploadTask? uploadLMSFile(File file) {
    try {
      final filename = p.basename(file.path);
      final destination = "LMSpaymentslip/$filename";
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<void> saveSlipDataforVideo(
      File img, VideosModel videoModel, UserModel userModel) async {
    UploadTask? task = uploadFile(img);
    final snapshot = await task!.whenComplete(() {});
    final downloadurl = await snapshot.ref.getDownloadURL();
    DateTime now = DateTime.now();
    String day = DateFormat('yyyy-MM-dd').format(now);
    //get the unique document id auto generated
    String docId = res.doc().id;

    cp_id = userModel.uid + "" + videoModel.vurl;
    final vpdocId = uuid.v5(Uuid.NAMESPACE_URL, cp_id);
    DocumentSnapshot snapshot1 = await video_pay.doc(vpdocId).get();

    if (snapshot1.exists == false) {
      await video_pay.doc(vpdocId).set({
        'vpid': vpdocId,
        'videoName': videoModel.VideoName,
        'vid': videoModel.vurl,
        'videFee': videoModel.Fee,
        'uid': userModel.uid,
        'userName': userModel.fname + "" + userModel.lname,
        'email': userModel.email,
        'pay_amount': 0,
        'create_at': day,
        'updated_at': day,
        'user': userModel.toJson(),
        'video': videoModel.toJson(),
        'img': downloadurl,
        'status': 0,
      }).then((value) async {});
    } else {
      await video_pay.doc(vpdocId).update({
        'updated_at': day,
      }).then((value) async {});
    }
    // Logger().i(downloadurl);
  }
}
