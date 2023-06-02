import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:binary_app/screens/home/client_disconnected_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/objects.dart';
import 'package:binary_app/screens/home.dart';

import 'package:binary_app/screens/startPage/startpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/user_controller.dart';

import '../screens/components/custom_dialog.dart';
import '../screens/login.dart';
import '../utils/util_functions.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class UserProvider extends ChangeNotifier {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  int _videocount = 0;
  int get getvideocount => _videocount;

  String _status = "";
  String get getStatus => _status;

  int _coursecount = 0;
  int get getcoursecount => _coursecount;
  // final _formKey = GlobalKey<FormState>();
  String? errorMessage;
  final _auth = FirebaseAuth.instance;

  UserModel? _tempusermodel;
  UserModel? get getemptusermodel => _tempusermodel;

  // late UserModel _userModel;

  UserModel _userModel = new UserModel(
      uid: "",
      stunumber: "",
      email: "",
      fname: "",
      lname: "",
      phone: "",
      homenumber: "",
      image: "null",
      token: "",
      signature: "",
      nicfront: "",
      nicback: "",
      address: "",
      roleid: "",
      status: "");
  //user controller object
  UserModel get getuserModel => _userModel;
  final UserController _usercontroller = UserController();
  bool _isLoading = false;
  //get loading state
  bool get isLoading => _isLoading;

  bool _isLoadingNIC = false;
  //get loading state
  bool get isLoadingNIC => _isLoadingNIC;

  bool _isLoadingSignature = false;
  //get loading state
  bool get isLoadingSignature => _isLoadingSignature;

  //show hide password text
  bool _isObscure = true;
  //get obscure state
  bool get isObscure => _isObscure;

  int total = 0;
  int get getTotal => total;
  String? _maxId;
  String? get getMaxId => _maxId;

  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  XFile? get getImageFile => _imageFile;

  File _image = File("");

  File _nicFront = File("");
  File get getNicFront => _nicFront;

  File _nicBack = File("");
  File get getNicBack => _nicBack;

  Image? _signatureImage;

  Uint8List? exportedImage;
  Uint8List? get getExportedImage => exportedImage;

  File? _signatureFile;
  File? get getsignatureFile => _signatureFile;

  final fname = TextEditingController();
  TextEditingController get fnameController => fname;
  final lname = TextEditingController();
  TextEditingController get lnameController => lname;
  final email = TextEditingController();
  TextEditingController get emailController => email;
  final phone = TextEditingController();
  TextEditingController get phoneController => phone;
  final homenumber = TextEditingController();
  TextEditingController get homenumberController => homenumber;
  final address = TextEditingController();
  TextEditingController get addressController => address;

  File _file = File("");
  File get getCropImg => _file;

  void takePhoto(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source // ImageSource.gallery,
            );

    _imageFile = pickedFile;
    if (pickedFile != null) {
      // _image = File(pickedFile.path);

      dynamic file = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
      if (file == null) {
        return;
      }
      file = await comressImage(file.path, 35);
      _file = file;

      uploadImage();
      notifyListeners();
    } else {
      Logger().e("no image selected");
    }

    notifyListeners();
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

  Future<void> uploadImage() async {
    UserModel _usermodel =
        await _usercontroller.updateUserWithImage(_file, _userModel);
    _userModel = _usermodel;

    checkUserUpdate();
    notifyListeners();
  }

  //change obscure state
  void changeObscure() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  //initialize and check whther the user signed in or not
  void initializeUser(BuildContext context) {
    print("************************** error ek ena thana");
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        Logger().i('User is currently signed out!');
        UtilFuntions.navigateTo(context, const getStarted());
      } else {
        Logger().i('User is signed in!');

        await checkUserDisconnected(context, user.uid).then((value) async => {
              if (_status != "0")
                {
                  setLoading(),
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const DisconnectedScreen()),
                      (Route<dynamic> route) => false),
                }
              else
                {
                  setLoading(),
                  await fetchSingleUser(context, user.uid).then((value) => {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                            (Route<dynamic> route) => false),
                      }),
                  storedNotificationTken(context, user.uid),
                }
            });

        // addUserToConversation(context, user.uid);
        storedNotificationTken(context, user.uid);
      }
    });
  }

  // Future<void> addUserToConversation(BuildContext context, String id) async {
  //   await _usercontroller.addUserToConv(context, id);
  //   notifyListeners();
  // }

  void storedNotificationTken(BuildContext context, String id) async {
    String? token = await FirebaseMessaging.instance.getToken();

    FirebaseFirestore.instance.collection("users").doc(id).set({
      'token': token,
    }, SetOptions(merge: true));
  }

  Future<void> fetchSingleUser(BuildContext context, String id) async {
    _coursecount = await _usercontroller.getCourseCount();
    _videocount = await _usercontroller.getVideoCount();

    _userModel = await _usercontroller.getUserData(context, id);

    _tempusermodel = _userModel;

    fname.text = _userModel.fname;
    lname.text = _userModel.lname;
    email.text = _userModel.email;
    phone.text = _userModel.phone;
    homenumber.text = _userModel.homenumber;
    address.text = _userModel.address;

    await _usercontroller.addUserToConv(context, _userModel, _tempusermodel);
    profileComplete();
    notifyListeners();
  }

  Future<void> checkUserDisconnected(BuildContext context, String id) async {
    DocumentSnapshot snapshot = await users.doc(id).get();
    // Logger().i(snapshot.data());
    UserModel userModel =
        UserModel.fromJson(snapshot.data() as Map<String, dynamic>);

    _status = userModel.status;

    notifyListeners();
  }

  //login function
  Future<void> startLogin(
    GlobalKey<FormState> _formKey,
    BuildContext context,
    String email,
    String password,
  ) async {
    setLoading(true);
    if (_formKey.currentState!.validate()) {
      try {
        // ignore: unused_local_variable
        UserCredential userCredential = await _auth
            .signInWithEmailAndPassword(
              email: email,
              password: password,
            )
            .then((value) => check(context, value.user!.uid, email, value));
        setLoading();
      } on FirebaseAuthException catch (e) {
        setLoading();
        if (e.code == 'user-not-found') {
          print('No user found for the email.');
          Fluttertoast.showToast(msg: 'No user found for the email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          Fluttertoast.showToast(msg: 'Wrong password provided for that user.');
        }
      }
    } else {
      setLoading();
    }
  }

  Future<UserCredential> check(
      BuildContext context, String uid, String email, user) async {
    await _usercontroller.updateOnline(uid);
    notifyListeners();

    await checkUserDisconnected(context, uid).then((value) async => {
          if (_status != "0")
            {
              setLoading(),
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const DisconnectedScreen()),
                  (Route<dynamic> route) => false),
            }
          else
            {
              setLoading(),
              login1(context, email),
            }
        });
    return user;
  }

  void login1(BuildContext context, String email) async {
    Fluttertoast.showToast(msg: "Login Successful");
    var time = Timestamp.now().toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('time', time);

    setLoading();
    UtilFuntions.pageTransitionwithremove(
      context,
      const HomeScreen(),
      const LoginScreen(),
    );
  }

  //change loading state
  void setLoading([bool val = false]) {
    _isLoading = val;
    notifyListeners();
  }

  void setLoadingNIC([bool val = false]) {
    _isLoadingNIC = val;
    notifyListeners();
  }

  void setLoadingSignature([bool val = false]) {
    _isLoadingSignature = val;
    notifyListeners();
  }

  Future<void> UpdateUser(
      BuildContext context, GlobalKey<FormState> _formKey, String uid) async {
    // _userModel = await _usercontroller.updateUser(context, fname.text,
    //     lname.text, email.text, phone.text, homenumber.text, address.text, uid);
    // await _auth.r

    setLoading(true);
    FirebaseAuth.instance.currentUser?.updateEmail(email.text).then((value) {
      users.doc(uid).update({
        'fname': fname.text,
        'lname': lname.text,
        'email': email.text,
        'phone': phone.text,
        'homenumber': homenumber.text,
        'address': address.text,
      }).then((value) async {
        DialogBox().dialogBox(
            context, DialogType.SUCCES, 'SUCCESS', 'Profile updated', () {});
        setLoading();
        // return _userModel!;

        // Provider.of<UserProvider>(context, listen: false).profileComplete();
        DocumentSnapshot snapshot = await users.doc(uid).get();
        _userModel =
            UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
        print("User updated");
        profileComplete();
      }).catchError((error) => print("Failed to add user: $error"));
      setLoading();
    });

    checkUserUpdate();
    notifyListeners();
  }

  Future<void> clearImagePicker() async {
    _image = File("");

    notifyListeners();
  }

  Future<void> logOut() async {
    await _usercontroller.updateOffline(_userModel.uid);
    _userModel = new UserModel(
        uid: "",
        stunumber: "",
        email: "",
        fname: "",
        lname: "",
        phone: "",
        homenumber: "",
        image: "",
        token: "",
        signature: "",
        nicfront: "",
        nicback: "",
        address: "",
        roleid: "",
        status: '');
    notifyListeners();
  }

  Future<void> startAddNicUpload(BuildContext context, String uid) async {
    if (_nicFront.path != "" && _nicBack.path != "") {
      setLoadingNIC(true);

/////////////////////////////////////////////////////////////
      // _userModel =
      //     await _usercontroller.uploadUserNicFile(_nicFront, _nicBack, uid);

      UploadTask? taskf = uploadNICFile(_nicFront);
      UploadTask? taskb = uploadNICFile(_nicBack);
      final snapshotf = await taskf!.whenComplete(() {});
      final snapshotb = await taskb!.whenComplete(() {});
      final downloadUrlf = await snapshotf.ref.getDownloadURL();
      final downloadUrlb = await snapshotb.ref.getDownloadURL();

      await users.doc(uid).update({
        'nicfront': downloadUrlf,
        'nicback': downloadUrlb,
      }).then((value) async {
        DocumentSnapshot snapshot = await users.doc(uid).get();
        _userModel =
            UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
        profileComplete();
      });

      /////////////////////////////////////////////////

      clearNicFrontPicker();
      clearNicBackePicker();

      checkUserUpdate();
      notifyListeners();

      setLoadingNIC();
      DialogBox().dialogBox(
        context,
        DialogType.SUCCES,
        'Success.',
        'Successfully uploaded NIC',
        () {},
      );
    } else {
      DialogBox().dialogBox(
        context,
        DialogType.ERROR,
        'Error.',
        'NIC font & Back, both are required',
        () {},
      );
    }
  }

  Future<void> selectNicFront() async {
    try {
      // Pick an image
      final XFile? pickFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickFile != null) {
        _nicFront = File(pickFile.path);
        notifyListeners();
      } else {
        Logger().e("no image selected");
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> selectNicBack() async {
    try {
      // Pick an image
      final XFile? pickFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickFile != null) {
        _nicBack = File(pickFile.path);
        notifyListeners();
      } else {
        Logger().e("no image selected");
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> clearNicFrontPicker() async {
    _nicFront = File("");
    Logger().e("no image selected");
    notifyListeners();
  }

  Future<void> clearNicBackePicker() async {
    _nicBack = File("");
    Logger().e("no image selected");
    notifyListeners();
  }

  Future<void> gelLastId(BuildContext context) async {
    String maxId = await _usercontroller.getMaxId(context);
    _maxId = maxId;

    print("****************** : " + maxId);
    notifyListeners();
  }

  Future<void> checkUserUpdate() async {
    if (identical(_userModel, _tempusermodel)) {
    } else {
      _usercontroller.addRoConversationNewObject(_userModel, _tempusermodel);
      _tempusermodel = _userModel;
      notifyListeners();
    }
    // print(identical(_userModel, _tempusermodel));

    // notifyListeners();
  }

  Future<void> startAddsignatureUpload(BuildContext context, String uid) async {
    if (exportedImage != null) {
      setLoadingSignature(true);
      ///////////////////////

      // await _usercontroller
      //     .uploadSignatureFile(exportedImage, uid)
      //     .then((value) {
      //   notifyListeners();
      // });

      final FirebaseStorage storage = FirebaseStorage.instance;
      final String picture =
          "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      final destination = 'Signature/$picture';
      UploadTask task = storage.ref(destination).putData(exportedImage!);

      final snapshot = await task.whenComplete(() {});
      final downloadurl = await snapshot.ref.getDownloadURL();

      await users.doc(uid).update({
        'signature': downloadurl,
      }).then((value) async {
        DocumentSnapshot snapshot = await users.doc(uid).get();
        _userModel =
            UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      }).catchError((error) => print("Failed to add user: $error"));

      ////////////////////
      setLoadingSignature();
      DialogBox().dialogBox(
        context,
        DialogType.SUCCES,
        'Success.',
        'Successfully uploaded Signature',
        () {},
      );
      profileComplete();
      notifyListeners();
    } else {
      DialogBox().dialogBox(
        context,
        DialogType.ERROR,
        'Error.',
        'Signature is empty',
        () {},
      );
    }
  }

  Future<void> setSignature(BuildContext context, Uint8List? uint8list) async {
    exportedImage = uint8list;

    _signatureImage = Image.memory(uint8list!);

    _signatureFile = File.fromRawPath(uint8list);

    notifyListeners();
  }

  Future<void> profileComplete() async {
    total = 0;
    if (_userModel.email != "") {
      total += 1;
    }
    if (_userModel.fname != "") {
      total += 1;
    }
    if (_userModel.lname != "") {
      total += 1;
    }
    if (_userModel.phone != "") {
      total += 1;
    }
    if (_userModel.homenumber != "") {
      total += 1;
    }
    if (_userModel.image != "") {
      total += 1;
    }
    if (_userModel.signature != "") {
      total += 1;
    }
    if (_userModel.nicfront != "") {
      total += 1;
    }
    if (_userModel.nicback != "") {
      total += 1;
    }
    if (_userModel.address != "") {
      total += 1;
    }

    notifyListeners();
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

  // Save user information
  Future<void> saveUserData(
    BuildContext context,
    String name,
    String email,
    String uid,
  ) async {
    var abc = await FirebaseFirestore.instance
        .collection("users")
        .orderBy('createdat')
        .limitToLast(1)
        .get();
    String stuid = "";
    for (var item in abc.docs) {
      UserModel model = UserModel.fromJson(item.data());

      stuid = model.stunumber;
      print("))))))))))))))))))))))%%%%%%%%%% : " + stuid);
    }

    String MaxId = "10000";
    if (stuid != "") {
      int maxId = int.parse(stuid);
      MaxId = (maxId + 1).toString();
    }

    print("))))))))))))))))))))))%%%%%%%%%% : " + MaxId);
    users
        .doc(uid)
        .set({
          'fname': name,
          'lname': "",
          'email': email,
          'uid': uid,
          'stunumber': MaxId,
          'phone': "",
          'homenumber': "",
          'image': "null",
          'token': "",
          'signature': "",
          'nicfront': "",
          'nicback': "",
          'address': "",
          'roleid': "2",
          'createdat': DateTime.now(),
          'isOnline': true,
          'lastSeen': DateTime.now().toString(),
          'status': "0",
        })
        // .then((value) => abc)
        .then((value) => getUserData(context, uid))
        .catchError((error) => print("Failed to add user: $error"));
  }

  void getUserData(BuildContext context, String uid) async {
    _userModel = await UserController().getUserData(context, uid);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false);
    notifyListeners();
  }
}
