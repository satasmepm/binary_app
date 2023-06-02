import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../controller/video_controller.dart';
import '../model/objects.dart';

class VideoProvider extends ChangeNotifier {
  VideosModel? _videoModel;
  //user controller object
  VideosModel? get getvideoModel => _videoModel;
  final VideoController _videocontroller = VideoController();
  Future<void> fetchSingleVideo(BuildContext context, String id) async {
    _videoModel = await _videocontroller.getVideoData(context, id);

    // notifyListeners();
  }
}
