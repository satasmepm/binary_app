import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:binary_app/model/course_model.dart';
import 'package:binary_app/screens/Payment/slip_pay_video.dart';
import 'package:binary_app/screens/Video/Videolist.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import '../model/objects.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../controller/slip_controller.dart';
import '../screens/Payment/Slippay.dart';
import '../screens/Payment/view_all_slips.dart';
import '../screens/components/custom_dialog.dart';
import '../utils/util_functions.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class SlipProvider extends ChangeNotifier {
  final SlipController _slipController = SlipController();
  String _selectedCourse = "AAA";
  final ImagePicker _picker = ImagePicker();
  File _image = File("");
  File get getImg => _image;

  File _file = File("");
  File get getCropImg => _file;

  bool _isLoading = false;
  //get loading state
  bool get isLoading => _isLoading;
  String get geSelectedCourse => _selectedCourse;

  //validate fields
  bool inputValidation() {
    var isValid = false;
    if (_file.path.isEmpty || _selectedCourse.isEmpty) {
      isValid = false;
    } else {
      isValid = true;
      print(">>>>>>>>>>>>> true ");
    }
    return isValid;
  }

  Future<void> selectImage() async {
    try {
      // Pick an image
      final XFile? pickFile = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);
      if (pickFile != null) {
        // _image = File(pickFile.path);

        dynamic file = await ImageCropper().cropImage(
            sourcePath: pickFile.path,
            aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
        if (file == null) {
          return;
        }
        file = await comressImage(file.path, 35);
        _file = file;
        notifyListeners();
      } else {
        Logger().e("no image selected");
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<File> comressImage(String path, int quality) async {
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');
    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      newPath,
      quality: quality,
    );
    return result!;
  }

  Future<void> clearImagePicker() async {
    // _image = File("");
    _file = File("");
    notifyListeners();
  }

  Future<void> startAddLMSSlipData(BuildContext context, UserModel userModel,
      Coursemodel coursemodel) async {
    try {
      if (inputValidation()) {
        setLoading(true);

        await _slipController
            .saveLMSSlipData(_file, coursemodel.CourseName, userModel)
            .then((value) {
          _file = File("");

          // _image.delete();
          // _selectedCourse = "";
          notifyListeners();
        });

        setLoading();
        DialogBox().dialogBox(
          context,
          DialogType.SUCCES,
          'Success.',
          'Successfully uploaded the slip.\n We will get back to you soon',
          () {
            UtilFuntions.goBack(context);
          },
        );
      } else {
        setLoading();
        DialogBox().dialogBox(context, DialogType.ERROR, 'Error.',
            'Please select an image', () {});
      }
    } catch (e) {
      setLoading();
      DialogBox().dialogBox(context, DialogType.ERROR, 'Somthing went wrong!',
          'Please try again', () {});
    }
  }

  Future<void> startAddSlipData(BuildContext context, UserModel userModel,
      Coursemodel coursemodel) async {
    try {
      if (inputValidation()) {
        setLoading(true);

        await _slipController
            .saveSlipData(
                _file, coursemodel.CourseName, coursemodel.cid, userModel)
            .then((value) {
          _file = File("");

          // _image.delete();
          // _selectedCourse = "";
          notifyListeners();
        });

        setLoading();
        DialogBox().dialogBox(
          context,
          DialogType.SUCCES,
          'Success.',
          'Successfully uploaded the slip.\n We will get back to you soon',
          () {
            UtilFuntions.pageTransition(
                context, const ViewAllSlips(), const slipPay());
          },
        );
      } else {
        setLoading();
        DialogBox().dialogBox(context, DialogType.ERROR, 'Error.',
            'Please select an image', () {});
      }
    } catch (e) {
      setLoading();
      DialogBox().dialogBox(context, DialogType.ERROR, 'Somthing went wrong!',
          'Please try again', () {});
    }
  }

  Future<void> startAddSlipDataforVideo(
      BuildContext context, UserModel userModel, VideosModel videoModel) async {
    try {
      if (inputValidation()) {
        setLoading(true);
        await _slipController
            .saveSlipDataforVideo(_file, videoModel, userModel)
            .then((value) {
          _file = File("");
          // _image.delete();
          notifyListeners();
        });
        setLoading();
        DialogBox().dialogBox(
          context,
          DialogType.SUCCES,
          'Success.',
          'Successfully uploaded the slip.\n We will get back to you soon',
          () {
            UtilFuntions.pageTransition(
                context,
                const Videolist(
                  status: false,
                ),
                const SlipPayVideo());
          },
        );
      } else {
        setLoading();
        DialogBox().dialogBox(context, DialogType.ERROR, 'Error.',
            'Please select an image', () {});
      }
    } catch (e) {
      setLoading();
      DialogBox().dialogBox(context, DialogType.ERROR, 'Somthing went wrong!',
          'Please try again', () {});
    }
  }

  //change loading state
  void setLoading([bool val = false]) {
    _isLoading = val;
    notifyListeners();
  }

  void setCurrentValue(String value) {
    _selectedCourse = value;

    notifyListeners();
  }
}
