import 'package:book_stash/auth/ui/login_screen.dart';
import 'package:book_stash/auth/ui/signup_screen.dart';
import 'package:book_stash/firebase_options.dart';
import 'package:book_stash/pages/books.dart';
import 'package:book_stash/pages/home.dart';
import 'package:book_stash/pages/message_screen.dart';
import 'package:book_stash/service/auth_service.dart';
import 'package:book_stash/service/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();


//handling background notification
Future _fireBackgroundMessage(RemoteMessage message) async {
  if(message.notification!=null){
    print("A notification found in background");
  }
}



void main() async {

  WidgetsFlutterBinding.ensureInitialized();

await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//initilize firebase messaging
await PushNotificationHelper.init();
//initialize local notifications
await PushNotificationHelper.localNotificationInitialization();

FirebaseMessaging.onBackgroundMessage(_fireBackgroundMessage);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      //home: LoginScreen(),

      routes: {
        "/":(context) => CheckUserBookStash(),
        "/login" :(context) => LoginScreen(),
        "/home" :(context) => Home(),
         "/signup" :(context) => SignupScreen(),
         "/message" : (context) => MessageScreen(),
         "/books" : (context) => Books(),
      },
    );
  }
}

class CheckUserBookStash extends StatefulWidget {
  const CheckUserBookStash({super.key});

  @override
  State<CheckUserBookStash> createState() => _CheckUserBookStashState();
}

class _CheckUserBookStashState extends State<CheckUserBookStash> {

@override
  void initState() {
   AuthServiceHelper.isUserLoggedIn().then((value){
    if(value){
      Navigator.pushReplacementNamed(context, "/home");
    }
    else{
      Navigator.pushReplacementNamed(context, "/login");
    }
   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}