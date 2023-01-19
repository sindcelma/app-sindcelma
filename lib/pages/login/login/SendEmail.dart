import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/HeaderActivity.dart';
import 'package:sindcelma_app/model/Request.dart';
import 'package:sindcelma_app/model/entities/User.dart';

import '../../../components/Btn.dart';
import '../../../components/Input.dart';
import '../../../themes.dart';

class SendEmail extends StatelessWidget {

  final Function response;
  final Function onError;
  final bool showLogo;

  SendEmail(this.response, this.onError, this.showLogo, {Key? key}) : super(key: key);

  String _cpf = "";

  void enviarEmail() async {

    var request = Request();
    await request.post('/user/recover', {
      'doc':_cpf,
      'to':'email',
      'type':'Socio'
    });

    if(request.code() != 200){
      onError("Este CPF não está cadastrado em nosso banco de dados");
      return;
    }

    String email = request.response()['message']['email'];
    response(email);

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
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text("Digite seu CPF que enviaremos um e-mail com código de recuperação.", style: TextStyle(
            fontSize: 16,
          ),),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Input(
            label: 'CPF',
            value: "",
            onChanged: (str, status){
              _cpf = str;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: BtnIconOutline(
              TypeColor.secondary,
              "Enviar",
              const Icon(
                Icons.email_outlined,
                color: Colors.green,
              ), (){
                enviarEmail();
              }
          ),
        ),
      ],
    );
  }
}
