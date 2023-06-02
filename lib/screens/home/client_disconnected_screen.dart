import 'package:binary_app/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';

class DisconnectedScreen extends StatelessWidget {
  const DisconnectedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                "assets/80164-reject-document-files.json",
                width: 200,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                height: 60,
              ),
              const Text(
                "Your account has been disconnected",
                // style: TextStyle(text),
              ),
              const Text(
                " Please contact administrator",
                // style: TextStyle(text),
              ),
              const SizedBox(
                height: 20,
              ),
              Consumer<UserProvider>(
                builder: (context, value, child) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0.0),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Provider.of<UserProvider>(context, listen: false)
                          .clearImagePicker();
                      Provider.of<UserProvider>(context, listen: false)
                          .logOut();

                      FirebaseAuth.instance.signOut().then((_) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (Route<dynamic> route) => false);
                      });
                    },
                    child: Ink(
                      width: size.width / 1.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.green[400],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        child: const Text(
                          'Go Back',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              )

              // ElevatedButton(
              //                             style: ElevatedButton.styleFrom(
              //                               padding:
              //                                   const EdgeInsets.all(0.0),
              //                               elevation: 3,
              //                               shape: RoundedRectangleBorder(
              //                                 borderRadius:
              //                                     BorderRadius.circular(30),
              //                               ),
              //                             ),
              //                             onPressed: () {
              //                               if (value1.getTotal > 9) {
              //                                 paymetDialog(
              //                                     value2.getuserModel.fname,
              //                                     context);
              //                               } else {
              //                                 DialogBox().dialogBox(
              //                                   context,
              //                                   DialogType.WARNING,
              //                                   'Warning.',
              //                                   "Can't enroll the course, please\ncomplete your profile",
              //                                   () {
              //                                     // UtilFuntions.pageTransition(
              //                                     //     context, const Videolist(), const SlipPayVideo());
              //                                   },
              //                                 );
              //                               }
              //                             },
              //                             child: Ink(
              //                               width: size.width / 2,
              //                               decoration: BoxDecoration(
              //                                 borderRadius:
              //                                     BorderRadius.circular(5),
              //                                 color: Colors.blue,
              //                               ),
              //                               child: Container(
              //                                 padding:
              //                                     const EdgeInsets.all(18),
              //                                 child: const Text(
              //                                     'Enroll Now',
              //                                     textAlign:
              //                                         TextAlign.center),
              //                               ),
              //                             ),
              //                           )
            ],
          )),
    );
  }
}
