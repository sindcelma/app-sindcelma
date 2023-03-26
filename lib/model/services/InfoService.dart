
import 'package:sindcelma_app/model/Config.dart';
import 'package:sindcelma_app/model/Request.dart';
import 'package:sindcelma_app/model/entities/InfoApp.dart';


String getPrincipalVersion(String v){
  var ver = v.split('.');
  return "${ver[0]}.${ver[1]}";
}

bool compareVersion(String versionAtual, Map versionCloud){
  return double.parse(getPrincipalVersion(versionAtual))
      >= double.parse(getPrincipalVersion(versionCloud['app_version']));
}


class InfoService {

  static bool _wp_noticias = false;

  Future<InfoApp> getInfo() async {

    InfoApp infoApp = InfoApp();
    if(infoApp.isInicializado()){
      return infoApp;
    }

    var req = Request();
    await req.get('/info');

    var resApi = req.response()['message'];

    _wp_noticias = resApi['wp_noticias'];
    infoApp.setApiVersion(resApi['api_version']);
    infoApp.setAppVersion(resApi['app_version']);
    infoApp.setPackage(resApi['package']);
    infoApp.setIsAtualized(compareVersion(Config.APP_VERSION, resApi));

    return infoApp;

  }

  static bool getWpNoticiasStatus(){
    return _wp_noticias;
  }

}