import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sindcelma_app/model/Config.dart';
import 'package:sindcelma_app/model/entities/User.dart';
import 'package:sindcelma_app/model/services/UserManagerService.dart';

class Request {

  int _code = 0;
  Map<String, dynamic> _response = {};

  int code() => _code;
  Map<String, dynamic> response() => _response;

  static String session = "";

  static Function? onReload;

  static void reloadApp(){
    onReload!();
  }

  Future<void> atualizarUser() async {
    try {

      var res = await http.post(Config.getUrlAPI('/user/rememberme'),
          headers: {"Content-Type": "application/json"},
          body:jsonEncode({
            "rememberme":User().socio.getToken(),
            "type":"Socio"
          })
      );

      var response = jsonDecode(utf8.decode(res.bodyBytes));
      var code = res.statusCode;

      if(code == 200){
        var r = response['message'];
        User().socio.setSession(r['session']);
        User().setDataMap(r['user']);
        User().setSocioMap(r['user']);
        User().socio.status = r['user']['status'];
        await UserManagerService().updateUser();
        await UserManagerService().updateSocio();
        User().atualizado = true;
      }

      if(code == 401){
        User().reset();
        await UserManagerService().reset();
      }

    } catch(e) {
      User().atualizado = false;
    }

  }

  Request(){
    session = User().socio.getSession();
  }

  Future<bool> get(String uri) async {

    int count = 5;

    while(!User().atualizado){
      if(count == 0) {
        return false;
      }
      await atualizarUser();
      count--;
    }

    var res = await http.get(Config.getUrlAPI(uri));
    _response = jsonDecode(utf8.decode(res.bodyBytes));
    _code = res.statusCode;

    return res.statusCode == 200;

  }

  Future<bool> post(String uri, Map<String, dynamic> body, { bool uploadFile = false }) async {

    if(session != "") {
      body['session'] = session;
    }

    int count = 5;
    while(!User().atualizado){
      if(count == 0) {
        return false;
      }
      await atualizarUser();
      await Future.delayed(const Duration(seconds: 2));
      count--;
    }

    Uri _uri = uploadFile ? Config.getUrlAsset(uri) : Config.getUrlAPI(uri);
    //print('------------------------------------------------------------------------');
    //print(_uri);
    //print('------------------------------------------------------------------------');
    var res = await http.post(_uri, headers: {"Content-Type": "application/json"}, body:jsonEncode(body));
    _response = jsonDecode(utf8.decode(res.bodyBytes));

    if(_response.containsKey('session')){
      session = _response['session'];
    }
    _code = res.statusCode;

    //print('------------------------------------------------------------------------');
    //print("code > ${res.statusCode}");
    //print("message > $_response");
    ///print('------------------------------------------------------------------------');

    if(res.statusCode == 401){
      await UserManagerService().reset();
      onReload!();
    }

    return res.statusCode == 200;

  }

}