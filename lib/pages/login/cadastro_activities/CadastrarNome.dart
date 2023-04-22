import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/Input.dart';
import 'package:sindcelma_app/model/Request.dart';
import 'package:sindcelma_app/model/entities/User.dart';
import 'CadastroActivity.dart';

class CadastrarNome extends StatelessWidget implements Activity {

  Widget cpf_input = Container();
  DinamicInput? dinamicInput;
  CadastrarNome({Key? key}) : super(key: key);
  ScaffoldMessengerState? scaffoldMessenger;

  void onChangeNome(String str, bool status){
    User().setNome(str);
  }

  void onChangeSobrenome(String str, bool status){
    User().setSobrenome(str);
  }

  void onChangeCPF(String str, bool status){
    User().socio.setCPF(str);
  }


  @override
  Widget build(BuildContext context) {

    scaffoldMessenger = ScaffoldMessenger.of(context);

    dinamicInput = Input(
      onChanged: (str, status) => onChangeCPF(str, status),
      label:"CPF",
      value: User().socio.getCPF(),
    );
    dinamicInput?.setRules(RegExp(r'\d{2,3}\.?\d{3}\.?\d{3}-?\d{2}'), "Não é um CPF válido");
    cpf_input = dinamicInput as Widget;
    return Column(
      children: [
        const Text("Digite as informações solicitadas abaixo:"),
        Padding(padding: const EdgeInsets.all(10), child: Input(
            label:"nome",
            value: User().nome,
            onChanged: (str,status) => onChangeNome(str, status)
        )),
        Padding(padding: const EdgeInsets.all(10), child: Input(
          label: "Sobrenome",
          value: User().sobrenome,
          onChanged: (str, status) => onChangeSobrenome(str, status) ),
          ),
        Padding(padding: const EdgeInsets.all(10), child: cpf_input,),
      ],
    );
  }

  @override
  Future<ResponseActivity> checkStatusActivity() async {

    if(User().socio.getCPF().isEmpty || User().nome.isEmpty || User().sobrenome.isEmpty) {
      return ResponseActivity(status: false, response: "Há campos vazios");
    }

    if(!User.isValidCPF(User().socio.getCPF())){
      return ResponseActivity(status: false, response: "CPF nõ é válido");
    }

    var request = Request();
    await request.post('/user/socios/check_document',{
      'doc':User().socio.getCPF()
    });

    if(request.code() == 200){
      return ResponseActivity(status: true, response: "");
    } else {
      return ResponseActivity(status: false, response: "Já existe um sócio com este documento cadastrado!");
    }

  }

}
