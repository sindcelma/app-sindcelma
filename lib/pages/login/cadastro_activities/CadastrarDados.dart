import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/DateInput.dart';
import 'package:sindcelma_app/components/Input.dart';
import 'package:sindcelma_app/components/SelectInput.dart';
import 'package:sindcelma_app/model/Request.dart';
import 'package:sindcelma_app/pages/login/cadastro_activities/CadastroActivity.dart';
import 'package:sindcelma_app/model/entities/User.dart';

import '../../../model/services/SocioManagerService.dart';
import '../../../model/services/UserManagerService.dart';

class CadastrarDados extends StatelessWidget implements Activity {

  bool emailStatus = false;
  bool senhaStatus = false;
  List<String> list = ["Masculino", "Feminino", "Nenhum"];

  BuildContext? context;

  CadastrarDados({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    this.context = context;

    DinamicInput dinamicInputEmail = Input(label: "email", value: User().email,
        onChanged: (str, status) {
          User().email = str;
          emailStatus = status;
        });

    dinamicInputEmail.setRules(RegExp(r'^[a-z0-9.]+@[a-z0-9]+\.[a-z]+(\.[a-z]+)?$'), "email não é válido");
    Widget inputEmail = dinamicInputEmail as Widget;

    DinamicInput dinamicInputSenha = Input(label: "senha", value: User().senha,
        onChanged: (str, status) {
          User().senha = str;
          senhaStatus  = status;
        });
    dinamicInputSenha.setRules(RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$'), "min. 6 caracteres com letras e números");
    Widget inputSenha = dinamicInputSenha as Widget;

    DinamicInput dinamicInputConfirmSenha = Input(
        label: "Confirme sua senha",
        value: User().confirm,
        onChanged: (str, status) =>  User().confirm = str
    );

    dinamicInputConfirmSenha.setFunctionError(() => User().confirm == User().senha);
    Widget inputConfirm = dinamicInputConfirmSenha as Widget;

    return Column(children: [
      const Text("Digite as informações que estão faltando abaixo"),
      Padding(
        padding: const EdgeInsets.all(10),
        child: SelectInput(
          label: 'Gênero',
          list: const ['Gênero','Masculino', 'Feminino', 'Nenhum'],
          onChange: (String value){
            User().socio.setGenero(value);
          },
          isError: (String value){
            return value == 'Gênero' || value.isEmpty;
          }
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: SelectInput(
            label: 'Estado Civil',
            list: const ['Estado Civil','Soltero(a)', 'Casado(a)'],
            onChange: (String value){
              User().socio.setEstadoCivil(value);
            },
            isError: (String value){
              return value == 'Estado Civil' || value.isEmpty;
            }
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: DateInput(
          label: 'Data de Nascimento',
          value: User().socio.getDataNascimento(),
          onChanged: (dataBr, dataEn){
            User().socio.setDataNascimento(dataBr);
            User().socio.setDataNascimentoEn(dataEn);
          },
        ),
      ),
      Padding(padding: const EdgeInsets.all(10),
        child: Input(
            label: "RG",
            value: User().socio.getRG(),
            onChanged: (str, status) =>  User().socio.setRG(str)
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: inputEmail,
      ),
      Padding(padding: const EdgeInsets.all(10),
        child: Input(
            label: "Telefone",
            value: User().telefone,
            onChanged: (str, status) =>  User().telefone = str
        ),
      ),
      Padding(padding: const EdgeInsets.all(10),
        child: inputSenha,
      ),
      Padding(padding: const EdgeInsets.all(10),
        child: inputConfirm,
      )
    ],);
  }

  @override
  Future<ResponseActivity> checkStatusActivity() async {

    var request = Request();

    await request.post('/user/check_email', {
      'email':User().email
    });

    if(request.code() != 200) {
      return ResponseActivity(status: false, response: "Este email já está em uso. Tente outro email.");
    }

    bool stat = User().confirm == User().senha && emailStatus;
    if(!stat){
      return ResponseActivity(
          status: false,
          response: !stat ? "As senhas não batem ou o e-mail não é válido." : ""
      );
    }

    var response = await SocioManagerService().saveSocio();

    if(!response.getStatus()) {
      return ResponseActivity(status: false, response: response.getResponse());
    }

    User().isMinimal();

    // fazer o login...
    while(true){
      var requestLogin = Request();
      await requestLogin.post('/user/login', {
        'email':User().email,
        'senha':User().senha,
        'type':'Socio',
        'rememberme': true
      });
      if(requestLogin.code() == 200){
        var res = requestLogin.response()['message'];
        User().setDataMap(res['user']);
        User().setSocioMap(res['user']);
        User().socio.status = res['user']['status'];
        User().status = 3;
        User().socio.setToken(requestLogin.response()['message']['remembermetk']);
        await UserManagerService().saveUser();
        await requestLogin.atualizarUser();
        break;
      }
    }

    return ResponseActivity(status: true, response: '');

  }

}
