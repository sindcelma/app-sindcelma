import 'package:flutter/material.dart';

import '../../../components/Btn.dart';
import '../../../components/Input.dart';
import '../../../themes.dart';

class PasswordArea extends StatelessWidget {

  Function response;

  PasswordArea(this.response, {Key? key}) : super(key: key);

  String senha = "";

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.all(20),
        child: Text("Digite sua senha", style: TextStyle(
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
        child: BtnIconOutline(
            TypeColor.secondary,
            "Entrar",
            const Icon(
              Icons.arrow_forward,
              color: Colors.green,
            ),
            () => response(senha, true)
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: Btn(
            TypeButton.text,
            TypeColor.text,
            "esqueci minha senha",
            () => response('', false)

        ),
      )
    ],
    );
  }
}
