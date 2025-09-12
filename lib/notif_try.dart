import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:open_file_plus/open_file_plus.dart';

class NotificationService {
  // Singleton pattern
  // static final NotificationService _notificationService =
  //     NotificationService._internal();
  // factory NotificationService() {
  //   return _notificationService;
  // }
  // NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Inisialisasi untuk Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
          '@drawable/ic_notification',
        ); // Nama ikon dari drawable

    // Inisialisasi untuk iOS
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    // Minta izin notifikasi untuk Android 13+
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            'high_importance_channel', // id
            'High Importance Notifications', // title
            description:
                'This channel is used for important notifications.', // description
            importance: Importance.max,
          ),
        );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    //   // Aksi yang dijalankan saat notifikasi diketuk
    //   onDidReceiveNotificationResponse: (NotificationResponse response) async {
    //     if (response.payload != null && response.payload!.isNotEmpty) {
    //       print('Membuka file dari payload: ${response.payload}');
    //       // Buka file menggunakan path yang ada di payload
    //       await OpenFile.open(response.payload);
    //     }
    //   },
    // );
  }

  Future<void> showNotification(
    int id,
    String title,
    String body,
    // String payload,
  ) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'high_importance_channel', // Channel ID
          'High Importance Notifications', // Channel name
          channelDescription: 'Channel untuk notifikasi unduhan file',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      // payload: payload, // Di sinilah kita menyimpan path file
    );
  }
}
