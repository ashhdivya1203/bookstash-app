import 'package:book_stash/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb


class PushNotificationHelper {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Call this in main()
  static Future init() async {
    // 🔒 Request notification permission
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      sound: true,
    );

    final token = await _firebaseMessaging.getToken();
print("📌 Fetching token...");

if (token != null) {
  print("✅ Device FCM token: $token");

  try {
    await FirebaseFirestore.instance.collection("device_tokens").add({
      "token": token,
      "timestamp": FieldValue.serverTimestamp(),
    });
    print("📥 Token saved to Firestore!");
  } catch (e) {
    print("❌ Error saving token: $e");
  }
} else {
  print("❌ Token is null. Maybe permission denied?");
}


    // 📩 Listen for foreground messages (important for Web)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Foreground message received!");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");

      // Show local notification only on Android (not for web)
      if (!kIsWeb) {
        showLocalNotification(message);
      }
    });
  }

  /// Local notifications setup (Android only)
  static Future localNotificationInitialization() async {
    const AndroidInitializationSettings initializationSettingsForAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsForAndroid,
    );

    // 🛡️ Request notification permission (Android 13+)
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // 🎯 Initialize notification plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  /// Show notification manually (foreground only, Android)
  static void showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    final android = notification?.android;

    if (notification != null && android != null) {
      final androidDetails = AndroidNotificationDetails(
        'bookstash_channel', // channel ID
        'BookStash Notifications', // channel name
        channelDescription: 'Channel for BookStash notifications',
        importance: Importance.max,
        priority: Priority.high,
      );

      final platformDetails = NotificationDetails(android: androidDetails);

      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platformDetails,
      );
    }
  }

  /// Handle notification tap
  static void onNotificationTap(NotificationResponse response) {
    print("🔔 Notification clicked: ${response.payload}");
    // Add logic to navigate or show dialogs based on payload
  }
}

//on tap local notification
void onNotificationTap(NotificationResponse notificationResponse){
  navigatorKey.currentState!.pushNamed("/message", arguments: notificationResponse);
}

Future showLocalNotification({
  required String title,
  required String body,
  required String payload,
}) async
    

  {
    const AndroidNotificationDetails androidNotificationDetails = 
    AndroidNotificationDetails(
      'channel id',
      'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker'
    );

   const NotificationDetails notificationDetails = 
   NotificationDetails(android: androidNotificationDetails);
   await _flutterLocalNotificationsPlugin.show(0,title,body,notificationDetails, payload);


  }