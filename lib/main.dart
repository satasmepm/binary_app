import 'package:binary_app/provider/chat_provider.dart';
import 'package:binary_app/provider/payment_provider.dart';
import 'package:binary_app/provider/registraion_provider.dart';
import 'package:binary_app/provider/slider_provider.dart';
import 'package:binary_app/provider/slip_provider.dart';
import 'package:binary_app/screens/home.dart';
import 'package:binary_app/screens/home/client_disconnected_screen.dart';
import 'package:binary_app/screens/startPage/startpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'notificationservice.dart';
import 'provider/corse_provider.dart';
import 'provider/user_provider.dart';
import 'provider/video_provider.dart';
import 'screens/course/course_details.dart';
import 'screens/notification/message_by_id.dart';
import 'screens/notification/notification_by_id.dart';
import 'screens/splash_screen/splash_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/services.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
  print('back ground ms : ${message.data}');

  NotificationService().initLocalNotifications(message);
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  NotificationService().initNotification();
  tz.initializeTimeZones();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    // Fluttertoast.showToast(msg: "Can't chatting this type of words");

    if (message.notification != null) {
      print(
          'Message also contained a notification 1: ${message.notification!.android}');

      print('Message also contained a notification 2: ${message.data['id']}');

      NotificationService().showNotification(
          1,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          5);
      NotificationService().initLocalNotifications(message);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    NotificationService().initLocalNotifications(message);
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null && message.data['screen'] != null) {
      // Extract custom data payload
      // String page = message.data['page'];
      // Navigate to desired page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (message.data['screen'] == "notf") {
          Get.to(() => NotificationById(id: message.data['id']));
        } else if (message.data['screen'] == "course") {
          Get.to(() => CourseDetails(
                docid: message.data['cour_id'],
              ));
        } else if (message.data['screen'] == "message") {
          Get.to(() => MessageById(
                id: message.data['id'],
              ));
        }
      });
    }
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CourseProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PaymentProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RegistrationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SlipProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => VideoProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SliderProvider(),
        ),
      ],
      child: MyApp(email: email),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({this.email, Key? key}) : super(key: key);

  // This widget is the root of your application.
  String? email;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BXL',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      // home: email == null ? splashScreen() : HsplashScreen(),
    );
  }
}

class splashScreen extends StatelessWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: const Color(0xff3949ab),
      splash: Container(
        child: const Image(
          image: AssetImage(
            "assets/logo.png",
          ),
          width: 200,
        ),
      ),
      nextScreen: const getStarted(),
      // splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}

class HsplashScreen extends StatelessWidget {
  const HsplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: const Color(0xff3949ab),
      splash: Container(
        child: const Image(
          image: AssetImage(
            "assets/logo.png",
          ),
          width: 200,
        ),
      ),

      nextScreen: const HomeScreen(),
      //splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}
