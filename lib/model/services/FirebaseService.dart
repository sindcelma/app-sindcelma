import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sindcelma_app/model/Request.dart';
import 'package:sindcelma_app/model/services/SocioManagerService.dart';
import 'package:sindcelma_app/model/services/notification_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workmanager/workmanager.dart';
import '../entities/User.dart';
import 'DatabaseService.dart';

class FirebaseService {

  final NotificationService _notificationService = NotificationService();
  final User _user = User();

  static String? _deviceToken;
  static bool initialized = false;

  FirebaseService(){
    init();
  }
  
  init() async {

    if(initialized){
      return;
    }

    if(_deviceToken != null){
      return;
    }

    _onMessage();

    var db = await DatabaseService().db;
    List firebase_reg  = await db.query('firebase', limit: 1);
    if(firebase_reg.isEmpty){
      _deviceToken = await FirebaseMessaging.instance.getToken();
      await _saveToken(db);
    } else {
      _deviceToken = firebase_reg.first['device_token'];
    }
    initialized = true;
  }
  
  token() {
    return _deviceToken;
  }

  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) {

      // initialise the plugin of flutterlocalnotifications.
      FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();

      // app_icon needs to be a added as a drawable
      // resource to the Android head project.
      var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
      var IOS = const DarwinInitializationSettings();

      // initialise settings for both Android and iOS device.
      var settings = InitializationSettings(android: android, iOS: IOS);
      flip.initialize(settings);
      _showNotificationWithDefaultSound(flip);
      return Future.value(true);
    });
  }

  static Future _showNotificationWithDefaultSound(flip) async {
    // Show a notification after every 15 minute with the first
    // appearance happening a minute after invoking the method
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        importance: Importance.max,
        priority: Priority.high
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    // initialise channel platform for both Android and iOS device.
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics
    );
    await flip.show(0, 'GeeksforGeeks',
        'Your are one step away to connect with GeeksforGeeks',
        platformChannelSpecifics, payload: 'Default_Sound'
    );
  }
  
  _saveToken(Database db) async {
    await SocioManagerService().generateSocio();
    var rememberme = _user.socio.getToken();
    var req = Request();
    await req.post('/user/save_token', {
      "remembermetk":rememberme,
      "tokendevice":_deviceToken
    });
    if(req.code() == 200) {
      await db.insert('firebase', {
        "device_token":_deviceToken
      });
    } else {
      _deviceToken = "";
    }
  }

  _onMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _notificationService.showLocalNotification(
          CustomNotification(
            id: android.hashCode,
            title: notification.title!,
            body: notification.body!,
            payload: message.data['route'] ?? '',
          ),
        );
      }
    });
  }

}