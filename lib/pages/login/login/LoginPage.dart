import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/AlertMessage.dart';
import 'package:sindcelma_app/components/Btn.dart';
import 'package:sindcelma_app/components/Input.dart';
import 'package:sindcelma_app/model/Request.dart';
import 'package:sindcelma_app/model/entities/User.dart';
import 'package:sindcelma_app/model/services/UserManagerService.dart';
import 'package:sindcelma_app/pages/login/login/CadastrarCPF.dart';
import 'package:sindcelma_app/pages/login/login/PasswordArea.dart';
import 'package:sindcelma_app/pages/login/login/UserArea.dart';
import 'package:sindcelma_app/themes.dart';

import 'CadastrarEmailSenha.dart';

class LoginPage extends StatefulWidget {

  Function response;

  LoginPage(this.response, {Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String email = "";
  String senha = "";
  String cpf = "";
  String np = "";
  bool emailStatus = false;
  List<Widget> subpages = [];
  int _index = 0;

  void showError(String message){
    ScaffoldMessenger.of(context).showSnackBar(
        AlertMessage(
            type: "error",
            message: message
        ).alert()
    );
  }

  void logar() async {
    var request = Request();
    await request.post('/user/login', {
      'email':email,
      'senha':senha,
      'type':'Socio',
      'rememberme': true
    });

    if(request.code() != 200){
      showError("Email/CPF ou senha estão incorretos");
      setState(() {});
      return;
    }

    var res = request.response()['message'];
    User().setDataMap(res['user']);
    User().setSocioMap(res['user']);
    User().socio.status = res['user']['status'];
    User().status = 3;
    User().socio.setToken(request.response()['message']['remembermetk']);
    await UserManagerService().saveUser();
    widget.response(0, status:User().socio.status != 1);

  }

  Widget create(){
    switch(_index){

      case 1: return PasswordArea((senha, status){
        if(!status){
          return widget.response(1);
        }
        this.senha = senha;
        logar();
      }, loading: false,);

      case 2: return CadastrarEmailSenha((email, senha){
        this.email = email;
        this.senha = senha;
        logar();
      }, cpf, showError);

      case 3: return CadastrarCPF((cpf){
       setState(() {
         this.cpf = cpf;
         if(!emailStatus){
           _index = 2;
         } else {
           _index = 1;
         }
       });
      }, showError, np:np);

      case 0:
      default:
        return UserArea((String email, bool emailStatus, String cpf, bool cpfStatus, String np){
        setState(() {
          this.cpf = cpf;
          this.email = email;
          this.np = np;
          this.emailStatus = emailStatus;
          if(!cpfStatus){
            _index = 3;
          } else
          if(!emailStatus){
            _index = 2;
          } else {
            _index = 1;
          }
        });
      }, showError);

    }

  }

  @override
  Widget build(BuildContext context) {
    return create();
  }
}
