import 'package:flutter/material.dart';
import '../../../components/Btn.dart';

import '../../../components/Input.dart';
import '../../../model/Request.dart';
import '../../../model/entities/User.dart';
import '../../../model/services/UserManagerService.dart';
import '../../../themes.dart';

class AlterarSenha extends StatefulWidget {

  final Function onResponse;

  const AlterarSenha({required this.onResponse, Key? key}) : super(key: key);

  @override
  State<AlterarSenha> createState() => _AlterarSenhaState();
}

class _AlterarSenhaState extends State<AlterarSenha> {

  String senhaAntiga = "";
  String novaSenha = "";
  bool senhaStatus = false;

  void close(){
    Navigator.pop(context);
  }

  void saveData() async {
    
    if(!senhaStatus){
      widget.onResponse(false,false);
      return;
    }
    
    var request = Request();
    await request.post('/user/change_password', {
      "oldPass":senhaAntiga,
      "newPass":novaSenha,
      "key":User().tempKey
    });

    if(request.code() != 200){
      if(request.code() == 403){
        widget.onResponse(false, true, false);
        return close();
      }
      if(request.code() == 402){
        widget.onResponse(false, false, true);
      } else {
        widget.onResponse(false, false, false);
      }
    } else {
      widget.onResponse(true, false, false);
      await UserManagerService().reset();
      Request.reloadApp();
    }
    
  }

  @override
  Widget build(BuildContext context) {

    DinamicInput dinamicInputSenha = Input(label: "nova senha", value: "",
        onChanged: (str, status) {
          novaSenha = str;
          senhaStatus = status;
        });
    dinamicInputSenha.setRules(RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$'), "min. 6 caracteres com letras e números");
    Widget inputSenha = dinamicInputSenha as Widget;

    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Icon(
                      Icons.arrow_back,
                      color: Colors.red,
                    ),
                    Text("voltar",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 18
                      ),
                    )
                  ]
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(10),
            child:  Icon(Icons.email_outlined,
              color: Colors.red,
              size: 40,
            ),
          ),
          const Center(
            child: Text('Alterar Senha',
              style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Oswald',
                  fontSize: 22
              ),
            ),
          ),
          Container(
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: const [
                  Center(
                    child: Text('ATENÇÃO! APÓS ALTERAÇÃO DA SENHA',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Oswald',
                          fontSize: 18
                      ),
                    ),
                  ),
                  Center(
                    child: Text('VOCÊ PRECISARÁ REALIZAR O LOGIN NOVAMENTE.',
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
          Padding(
            padding: const EdgeInsets.only(
              top: 30,
              left: 10,
              right: 10,
            ),
            child: Input(
                label: "senha antiga",
                value: "",
                onChanged: (str, status){
                  senhaAntiga = str;
                }
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: inputSenha,
          ),
          Padding(padding: const EdgeInsets.all(10),
            child: Btn(TypeButton.elevated, TypeColor.secondary, "SALVAR", () async {
              saveData();
            }),
          )
        ],
      ),
    );
  }
}
