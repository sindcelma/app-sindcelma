import 'package:flutter/material.dart';
import 'package:sindcelma_app/model/Request.dart';

import '../../../components/Btn.dart';
import '../../../components/HeaderActivity.dart';
import '../../../components/Input.dart';
import '../../../themes.dart';

class CodeArea extends StatelessWidget {

  final Function response;
  final Function onError;
  final String email;
  final bool showLogo;
  String codigo = "";
  
  CodeArea(this.response, this.onError, this.email, this.showLogo, {Key? key}) : super(key: key);

  void verificarCodigo() async {
    var request = Request();
    await request.post('/user/check_code_recover', {
      'email':email,
      'codigo':codigo
    });

    if(request.code() != 200) {
      onError('Código incorreto');
      return;
    }

    String novoCodigo = request.response()['message']['codigo'];
    response(novoCodigo);

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
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text("Enviamos um e-mail para '$email' com o código de recuperação .", style:
          const TextStyle(
            fontSize: 18,
          ),),
        ),
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text("digite o código abaixo:", style: TextStyle(
            fontSize: 16,
          ),),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Input(
            label: 'código',
            value: "",
            onChanged: (str, status){
              codigo = str;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: BtnIconOutline(
              TypeColor.secondary,
              "Verificar",
              const Icon(
                Icons.check,
                color: Colors.green,
              ), verificarCodigo
          ),
        ),
      ],
    );
  }
}
