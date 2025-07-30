import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'login_page.dart';

// Inisialisasi plugin local notification global
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Background handler (tetap sama)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📩 [Background] Notifikasi: ${message.notification?.title} - ${message.notification?.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Setup background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Setup local notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Request permission notifikasi
    FirebaseMessaging.instance.requestPermission().then((settings) {
      print('🔔 Izin notifikasi: ${settings.authorizationStatus}');
    });

    // Subscribe ke topik
    FirebaseMessaging.instance.subscribeToTopic("alert");

    // Tangani pesan saat foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 [Foreground] ${message.notification?.title}: ${message.notification?.body}");

      // Tampilkan Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.notification?.body ?? 'Notifikasi masuk'),
          duration: Duration(seconds: 3),
        ),
      );

      // Tampilkan notifikasi lokal
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'alert_channel', // channelId
              'Alert Notifications', // channelName
              channelDescription: 'Channel untuk notifikasi alert',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    // Saat user klik notifikasi (app di background / closed)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("🟢 [Click Notification] ${message.notification?.title}");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(message.notification?.title ?? "Notifikasi"),
          content: Text(message.notification?.body ?? "-"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Tutup"),
            )
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terrarium Alert',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
