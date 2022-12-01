import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/LoadingComponent.dart';
import 'package:sindcelma_app/model/Request.dart';
import 'package:sindcelma_app/model/services/UserManagerService.dart';
import 'package:sindcelma_app/model/services/SocioManagerService.dart';

import '../model/entities/User.dart';


class LoadingPage extends StatefulWidget {

  Function onResponse;

  LoadingPage(this.onResponse, {Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();

}

class _LoadingPageState extends State<LoadingPage> {

  bool first = true;
  List<bool> steps = [false,false];
  String message = "carregando dados...";
  bool imagesSocio = false;
  bool loaded = false;
  Widget comp = Container();
  bool error = false;

  void showError(){
    setState(() {
      error = true;
      message = "Não estamos recebendo resposta do servidor, tente novamente mais tarde";
    });
  }

  void showAlert() async {
    await Future.delayed(const Duration(seconds: 10));
    if(!loaded) {
      showError();
    }
  }

  void carregarSocio() async {

    showAlert();

    if(!steps[0]){
      bool status = await UserManagerService().generateUser();
      steps[0] = status;
    }

    if(!steps[1]){
      bool status = await SocioManagerService().generateSocio();
      int count = 5;
      do {
        if(count == 0) break;
        await Request().atualizarUser();
        count--;
        await Future.delayed(const Duration(seconds: 1));
      } while(!User().atualizado);
      steps[1] = status;
    }

    loaded = true;

    widget.onResponse(User().socio.status != 1);

  }

  Widget getLoading(){

    steps = [false,false];

    carregarSocio();

    return LoadingComponent(message, error);
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        body: getLoading(),
      ),
    );
  }
}

