import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/BtnLoading.dart';

import '../../../components/Btn.dart';
import '../../../components/Input.dart';
import '../../../themes.dart';

class PasswordArea extends StatefulWidget {

  Function response;
  bool loading;

  PasswordArea(this.response, {Key? key, required this.loading}) : super(key: key);

  @override
  State<PasswordArea> createState() => _PasswordAreaState();
}

class _PasswordAreaState extends State<PasswordArea> {

  String senha = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {

    loading = widget.loading;

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
          hideContent: true,
          label: 'senha',
          value: senha,
          onChanged: (str, status){
            senha = str;
          },
        ),
      ),
      loading ? const BtnLoading() : Padding(
        padding: const EdgeInsets.all(10),
        child: BtnIconOutline(
            TypeColor.secondary,
            "Entrar",
            const Icon(
              Icons.arrow_forward,
              color: Colors.green,
            ),
                (){
                  setState(() {
                    widget.loading = true;
                  });
                  widget.response(senha, true);
                }
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
          child: Btn(
              TypeButton.text,
              TypeColor.text,
              "esqueci minha senha",
                  () => widget.response('', false)

          ),
        )
      ],
    );
  }
}

