import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sindcelma_app/model/entities/InfoApp.dart';
import 'package:sindcelma_app/model/entities/User.dart';
import 'package:sindcelma_app/pages/Atualizar.dart';
import 'package:sindcelma_app/pages/app/app.dart';
import 'package:sindcelma_app/pages/loading.dart';
import 'package:sindcelma_app/pages/login/login.dart';

import 'components/AddDocumentsActivity.dart';
import 'firebase_options.dart';
import 'model/Request.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(
      SindcelmaApp(page: 'loading')
  );
}

class SindcelmaApp extends StatefulWidget {

  String page;
  String? subpage;

  SindcelmaApp({required this.page, this.subpage, Key? key}) : super(key: key);

  @override
  State<SindcelmaApp> createState() => _SindcelmaAppState();
}


class _SindcelmaAppState extends State<SindcelmaApp> {

  void reload(){
    setState(() {
      widget.page = "loading";
    });
  }

  @override
  void initState() {
    super.initState();
    Request.onReload = reload;
  }

  @override
  Widget build(BuildContext context) {

    if(widget.page == 'atualizar'){
      return MaterialApp(
        home: Atualizar(onResponse),
      );
    } else if(widget.page == 'login'){
      return LoginPage(onResponse);
    } else if(widget.page == 'loading'){
      return LoadingPage(onResponse);
    } else if(widget.page == 'document') {
      return MaterialApp(
        home: AddDocumentsActivity(onResponse),
      );
    } else {
      //  O app faz análise do usuário e carrega as telas conforme o tipo dele
      //  se o usuário for um sócio mas seu token expirou (por qualquer motivo)
      //    é necessário redirecionar o usuário para a tela de cadastro
      //    e alterar o status dele para 2
      return App((){
        setState(() {
          widget.page = "loading";
        });
      });
    }
  }

  void onResponse(bool status, {bool atualizar = false, bool loading = false, InfoApp? info}){
    // user status = 1 // significa que é um visitante
    // user status = 2 // significa que é um sócio e precisa do token dele
    // user status = 3 // significa que é sócio e tem o token
    // user status = 0 // va para area de login

    setState(() {

      if(atualizar){
        widget.page = 'atualizar';
        return;
      }

      if(loading){
        widget.page = 'loading';
        return;
      }

      if(!status){
        widget.page = "document";
        return;
      }
      switch(User().status){
        case 1: widget.page = "home"; break;
        case 2:
          widget.page = "login";
          widget.subpage = "login";
          break;
        case 3:
          widget.page = "home";
          break;
        case 0:
        default:
          widget.page = "login";
          widget.subpage = "";
      }
    });

  }

}

