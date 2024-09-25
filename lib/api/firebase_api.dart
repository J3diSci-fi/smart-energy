import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:smartenergy_app/logic/core/appcore.dart';
import 'package:smartenergy_app/services/notification_service.dart';
import 'package:smartenergy_app/services/tbclient_service.dart';


@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  
  String? status = await ThingsBoardService.tbSecureStorage.getItem("status");
  if(status == "true"){
    AppCore.soundManager.play();
  }
  
  
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
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      handleMessage(message);
    });

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      String? status = await ThingsBoardService.tbSecureStorage.getItem("status");
      final notification = message.notification;
      if(notification != null){
        final notificationTitle = notification!.title;
        final notificationBody = notification.body;
        notificationService.showNotification(title: notificationTitle, body: notificationBody);
        if(status == "true"){
           AppCore.soundManager.play();
        }
        
      }
      else{
        print("Notificação nulla");
      }
      
    });
  }
}
