import 'dart:io';

class InfoApp {

  String _appVersion = '';
  String _apiVersion = '';
  String _package = '';
  String _packageAndroid = '';
  String _packageIOS = '';
  bool _atualized = false;
  bool _inicializado = false;


  static final InfoApp _infoApp = InfoApp._internal();

  InfoApp._internal();

  factory InfoApp(){
    return _infoApp;
  }

  apiVersion(){
    return _apiVersion;
  }

  appVersion(){
    return _appVersion;
  }

  package(){
    return _package;
  }

  packages(){
    return Platform.isIOS ? _packageIOS : _packageAndroid;
  }

  setAppVersion(String appVersion){
    _appVersion = appVersion;
  }

  setApiVersion(String apiVersion){
    _apiVersion = apiVersion;
  }

  setPackage(String package){
    _package = package;
  }

  setPackageIOS(String package){
    _packageIOS = package;
  }

  setPackageAndroid(String package){
    _packageAndroid = package;
  }

  setIsAtualized(bool atualizado){
    _inicializado = true;
    _atualized = atualizado;
  }

  isInicializado(){
    return _inicializado;
  }

  isAtualizado(){
    return _atualized;
  }

}