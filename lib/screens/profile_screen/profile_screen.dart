import 'package:binary_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../utils/constatnt.dart';
import '../../utils/util_functions.dart';
import '../components/circle_avatar.dart';
import '../components/custom_drawer.dart';
import '../components/custom_loader.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                MaterialCommunityIcons.chevron_left,
                size: 30,
              ),
              color: Colors.black,
              onPressed: () {
                UtilFuntions.goBack(context);
              },
              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
//        backgroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const CustomDrawer(),
      // drawer: Drawer(
      //   child: ListView(
      //     children: [
      //       Text("Home"),
      //       Text("Settings")
      //     ],
      //   ),
      // ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            color: Colors.grey[100],
            width: size.width,
            height: size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Consumer<UserProvider>(
                builder: (context, value, child) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 70,
                        ),
                        CircleImageAvatar(
                          radius: 55,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: ((builder) => BottomSheet(size: size)),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "ssssssssssssssssssssssssss",
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        Text(
                          value.getuserModel.email,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          value.getuserModel.fname,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        customTextField(
                          MaterialCommunityIcons.account_outline,
                          "First Name",
                          "First Name",
                          false,
                          false,
                          value.fnameController,
                          (value) {
                            if (value!.isEmpty) {
                              return ("Please enter first name");
                            }
                            return null;

                            // return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        customTextField(
                          MaterialCommunityIcons.account_outline,
                          "Last Name",
                          "Last name",
                          false,
                          true,
                          value.lnameController,
                          (value) {
                            if (value!.isEmpty) {
                              return ("Please enter last email");
                            }
                            return null;

                            // return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        customTextField(
                          MaterialCommunityIcons.email_outline,
                          "Email Address",
                          "Email Address",
                          false,
                          true,
                          value.emailController,
                          (value) {
                            if (value!.isEmpty) {
                              return ("Please enter your email");
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please Enter a valid email");
                            }
                            return null;
                            // return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        customTextField(
                          MaterialCommunityIcons.phone_outline,
                          "Phone Number",
                          "Phone Number",
                          true,
                          false,
                          value.phoneController,
                          (value) {
                            if (value!.isEmpty) {
                              return ("Please enter your email");
                            }
                            if (!RegExp('^(?:[+0]9)?[0-9]{10}')
                                .hasMatch(value)) {
                              return ("Please Enter a valid phone number");
                            }
                            return null;
                            // return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        value.isLoading
                            ? Container(
                                height: 52,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: CustomLoader(loadertype: false),
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(0.0),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    value.UpdateUser(context, _formKey,
                                        value.getuserModel.uid);
                                  }
                                },
                                child: Ink(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue,
                                    // gradient: const LinearGradient(
                                    //     colors: [Colors.red, Colors.orange]),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(18),
                                    child: const Text('Update Now',
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding customTextField(
    IconData icon,
    String hintText,
    String labelText,
    bool isPassword,
    bool isEmail,
    TextEditingController controller,
    String? Function(String?)? validator,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hintText,
            style: const TextStyle(fontSize: 13, color: Constants.labelText),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
              obscureText: false,
              controller: controller,
              keyboardType:
                  isEmail ? TextInputType.emailAddress : TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  icon,
                  color: Constants.iconColor,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Constants.textColor1),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlueAccent),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                contentPadding: const EdgeInsets.all(10),
                hintText: hintText,
                labelText: hintText,
                hintStyle: const TextStyle(fontSize: 14, color: Constants.textColor1),
              ),
              validator: validator),
        ],
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
    return Consumer<UserProvider>(
      builder: (context, value, child) {
        return Container(
          height: 100,
          width: size.width,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              const Text(
                "Chose Profile Photo",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton.icon(
                    onPressed: () {
                      value.takePhoto(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("Camera"),
                  ),
                  FlatButton.icon(
                    onPressed: () {
                      value.takePhoto(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("Galary"),
                  ),
                ],
              )
            ],
          ),
          // color: Colors.amber,
        );
      },
    );
  }
}
