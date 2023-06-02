import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../model/objects.dart';

class VideoController {
  // Create a collection refferance
  CollectionReference videos = FirebaseFirestore.instance.collection('videos');

  Future<VideosModel?> getVideoData(BuildContext context, String id) async {
    DocumentSnapshot snapshot = await videos.doc(id).get();
    // Logger().i(snapshot.data());
    VideosModel videoModel =
        VideosModel.fromJson(snapshot.data() as Map<String, dynamic>);
    return videoModel;
  }
}
