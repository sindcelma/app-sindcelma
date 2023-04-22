import 'package:flutter/material.dart';
import 'package:sindcelma_app/model/Request.dart';
import 'package:sindcelma_app/model/services/UserManagerService.dart';

import '../../../components/Btn.dart';
import '../../../components/HeaderActivity.dart';
import '../../../components/Input.dart';
import '../../../themes.dart';

class ResetPassword extends StatelessWidget {

  Function response;
  Function onError;
  String codigo;
  String email;
  bool showLogo;

  String senha = "";
  String confirm = "";

  ResetPassword(this.response, this.onError, this.email, this.codigo, this.showLogo, {Key? key}) : super(key: key);

  void salvarNovaSenha() async {
    if(senha != confirm){
      onError('A senha e a confirmação não são iguais');
    }
    var request = Request();
    await request.post('/user/change_pass_using_code', {
      'email':email,
      'codigo':codigo,
      'senha':senha
    });
    if(request.code() != 200){
      onError("Ocorreu um erro no servidor");
      return;
    }
    UserManagerService().reset();
    Request.reloadApp();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        showLogo
            ? const HeaderActivity()
            : Container(),
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text("Esqueci minha senha:", style: TextStyle(
            fontSize: 20,
          ),),
        ),
        Container(
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: const [
                Center(
                  child: Text('O APLICATIVO SERÁ REINICIADO APÓS ALTERAÇÂO DA SENHA',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Oswald',
                        fontSize: 18
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text("Crie uma nova senha:", style: TextStyle(
            fontSize: 20,
          ),),
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
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Input(
            label: 'confirme a senha',
            value: "",
            onChanged: (str, status){
              confirm = str;
            },
            functionError: (){
              return senha == confirm;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: BtnIconOutline(
              TypeColor.secondary,
              "Salvar Nova Senha",
              const Icon(
                Icons.key,
                color: Colors.green,
              ), salvarNovaSenha
          ),
        )
      ],
    );
  }
}
