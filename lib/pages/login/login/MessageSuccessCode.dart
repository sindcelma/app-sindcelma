import 'package:flutter/material.dart';

import '../../../components/Btn.dart';
import '../../../themes.dart';

class MessageSuccessCode extends StatelessWidget {

  final Function response;

  const MessageSuccessCode(this.response, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Senha alterada com SUCESSO!", style:
        TextStyle(
          fontSize: 30,
        ),),
        Padding(
          padding: const EdgeInsets.all(10),
          child: BtnIconOutline(
              TypeColor.secondary,
              "Ir para area de login",
              const Icon(
                Icons.login,
                color: Colors.green,
              ), (){
              response();
            }
          ),
        ),
      ],
    );
  }
}
