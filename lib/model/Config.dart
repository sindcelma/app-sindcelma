class Config {

  static const String urlProduction  = "https://sindcelma.com.br";
  static const String urlDevelopment = "http://192.168.0.11:3050";

  static const String urlAPIProduction  = "https://sindcelma.com.br/api";
  static const String urlAPIDevelopment = "http://192.168.0.11:3050";

  static const bool   isSecure       = false;
  static const bool   isInProduction = false;

  static String getUrl(String uri){
    String url = (isInProduction ? urlProduction : urlDevelopment)+uri;
    return url;
  }

  static getUrlAPI(String uri){
    String url = (isInProduction ? urlAPIProduction : urlAPIDevelopment)+uri;
    return Uri.parse(url);
  }

}