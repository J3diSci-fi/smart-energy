import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:smartenergy_app/logic/core/appcore.dart';
import 'package:smartenergy_app/services/notification_service.dart';


@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  AppCore.soundManager.playSong();
  
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final NotificationService notificationService = NotificationService();

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    _firebaseMessaging.setForegroundNotificationPresentationOptions();
    final token = await _firebaseMessaging.getToken();

    initPushNotifications(token!);
    notificationService.initNotification();
  }

  Future<void> subscribeCustomerIdTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
  }

  Future initPushNotifications(String token) async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final notificationTitle = notification!.title;
      final notificationBody = notification.body;
      notificationService.showNotification(
          title: notificationTitle, body: notificationBody);
      AppCore.soundManager.playSong();
    });
  }
}
