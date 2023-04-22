import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sindcelma_app/model/Request.dart';
import 'package:sindcelma_app/model/services/SocioManagerService.dart';
import 'package:sqflite/sqflite.dart';
import '../entities/User.dart';
import 'DatabaseService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sindcelma_app/firebase_options.dart';
import 'dart:io';

class FirebaseService {

  final User _user = User();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  static String? _deviceToken;
  static String? _deviceType;
  static bool initialized = false;

  FirebaseService(){
    init();
  }
  
  init() async {

    if(User().hasCodeDev){
      return;
    }

    if(!initialized){
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform
      );
    }

    NotificationSettings ns = await _fcm.requestPermission(alert: true, sound: false);

    if(ns.authorizationStatus == AuthorizationStatus.authorized){
      _deviceType  = Platform.isIOS ? 'ios' : 'android';
      _deviceToken = await FirebaseMessaging.instance.getToken();
      await _saveToken();
    }

    initialized = true;
  }
  
  token() {
    return _deviceToken;
  }

  static resetToken() {
    _deviceToken = null;
    initialized = false;
  }

  _saveToken() async {
    await SocioManagerService().generateSocio();
    var rememberme = _user.socio.getToken();
    var req = Request();
    await req.post('/user/save_token', {
      "remembermetk":rememberme,
      "tokendevice":_deviceToken,
      "typedevice":_deviceType
    });
  }

}