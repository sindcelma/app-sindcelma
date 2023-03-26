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

    if(initialized){
      return;
    }

    if(_deviceToken != null){
      return;
    }

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform
    );

    NotificationSettings ns = await _fcm.requestPermission(alert: true, sound: false);

    if(ns.authorizationStatus == AuthorizationStatus.authorized){

      _deviceType = Platform.isIOS ? 'ios' : 'android';

      var db = await DatabaseService().db;
      List firebaseReg  = await db.query('firebase', limit: 1);
      if(firebaseReg.isEmpty){
        _deviceToken = await FirebaseMessaging.instance.getToken();
        await _saveToken(db);
      } else {
        _deviceToken = firebaseReg.first['device_token'];
      }

    }

    initialized = true;
  }
  
  token() {
    return _deviceToken;
  }


  _saveToken(Database db) async {
    await SocioManagerService().generateSocio();
    var rememberme = _user.socio.getToken();
    var req = Request();
    await req.post('/user/save_token', {
      "remembermetk":rememberme,
      "tokendevice":_deviceToken,
      "typedevice":_deviceType
    });
    if(req.code() == 200) {
      await db.insert('firebase', {
        "device_token":_deviceToken
      });
    } else {
      _deviceToken = "";
    }
  }

}