
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

  Future<InfoApp> getInfo() async {

    InfoApp infoApp = InfoApp();
    if(infoApp.isInicializado()){
      return infoApp;
    }

    var req = Request();
    await req.get('/info');
    var res_api = req.response()['message'];

    infoApp.setApiVersion(res_api['api_version']);
    infoApp.setAppVersion(res_api['app_version']);
    infoApp.setPackage(res_api['package']);
    infoApp.setIsAtualized(compareVersion(Config.APP_VERSION, res_api));

    return infoApp;

  }

}