import 'package:flutter/material.dart';
import 'package:sindcelma_app/model/Request.dart';

import '../../../components/Btn.dart';
import '../../../components/Input.dart';
import '../../../themes.dart';

class CadastrarCPF extends StatefulWidget {

  final Function response;
  final Function onError;
  final String np;

  const CadastrarCPF(this.response, this.onError, { required this.np,  Key? key}) : super(key: key);

  @override
  State<CadastrarCPF> createState() => _CadastrarCPFState();
}

class _CadastrarCPFState extends State<CadastrarCPF> {

  String cpf = "";

  void save_doc() async {

    var request = Request();
    await request.post('/user/socios/update_doc_by_np', {
      "cpf":cpf,
      "np":widget.np
    });

    if(request.code() != 200){
      widget.onError(request.response()['message']);
      return;
    }

    widget.response(cpf);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text("Cadastrar CPF", style: TextStyle(
            fontSize: 20,
          ),),
        ),
        const Text("Digite seu CPF abaixo", style: TextStyle(
          fontSize: 16,
        ),),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Input(
            label: 'CPF',
            value: "",
            onChanged: (str, status){
              cpf = str;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: BtnIconOutline(
              TypeColor.secondary,
              "SALVAR",
              const Icon(
                Icons.arrow_forward,
                color: Colors.green,
              ), (){
                save_doc();
              }
          ),
        ),
      ],
    );
  }
}
