import 'package:flutter/material.dart';
import 'package:sindcelma_app/model/Request.dart';

import '../../../components/Btn.dart';
import '../../../components/Input.dart';
import '../../../themes.dart';

class CadastrarEmailSenha extends StatelessWidget {

  Function response;
  Function onError;

  String email = "";
  String confirmEmail = "";
  String senha = "";
  String confirmSenha = "";
  String cpf;

  CadastrarEmailSenha(this.response, this.cpf, this.onError, {Key? key}) : super(key: key);

  void salvarEmailESenha() async {
    var request = Request();
    await request.post('/user/create', {
      'email':email,
      'senha':senha,
      'doc':cpf
    });
    if(request.code() != 200){
      onError(request.response()['message']);
    } else {
      response(email, senha);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text("Cadastro de Usuário", style: TextStyle(
            fontSize: 20,
          ),),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Input(
            label: 'email',
            value: "",
            onChanged: (str, status){
              email = str;
            },
          ),
        ),Padding(
          padding: const EdgeInsets.all(10),
          child: Input(
            label: 'Confirme seu e-mail',
            value: "",
            onChanged: (str, status){
              confirmEmail = str;
            },
            functionError: (){
              return email == confirmEmail;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Input(
            label: 'senha',
            value: "",
            onChanged: (str, status){
              senha = str;
            },
          ),
        ),Padding(
          padding: const EdgeInsets.all(10),
          child: Input(
            label: 'Confirme sua senha',
            value: "",
            onChanged: (str, status){
              confirmSenha = str;
              //
            },
            functionError: (){
              return senha == confirmSenha;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: BtnIconOutline(
              TypeColor.secondary,
              "Salvar",
              const Icon(
                Icons.email_outlined,
                color: Colors.green,
              ),
              () => salvarEmailESenha()
          ),
        ),
      ],
    );
  }
}
