class Config {

  static const String urlAssetProduction  = "http://assetsindcelma.com.br";
  static const String urlAssetDevelopment = "http://192.168.0.11:8904";

  static const String urlAPIProduction    = "http://sindcelmatecnologia.com.br";
  static const String urlAPIDevelopment   = "http://192.168.0.11:3050";

  static const String APP_VERSION    = "1.4.0";

  static const bool   isSecure       = false;
  static const bool   isInProduction = true;

  static getUrlAsset(String uri){
    String url = (isInProduction ? urlAssetProduction : urlAssetDevelopment)+uri;
    return Uri.parse(url);
  }

  static getUrlAPI(String uri){
    String url = (isInProduction ? urlAPIProduction : urlAPIDevelopment)+uri;
    return Uri.parse(url);
  }

  static String getUrlAPIString(String uri){
    String url = (isInProduction ? urlAPIProduction : urlAPIDevelopment)+uri;
    return url;
  }

  static String getUrlAssetString(String uri){
    String url = (isInProduction ? urlAssetProduction : urlAssetDevelopment)+uri;
    return url;
  }

  static String getVersion(){
    return APP_VERSION;
  }

}