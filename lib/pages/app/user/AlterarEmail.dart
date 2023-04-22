import 'package:flutter/material.dart';
import 'package:sindcelma_app/model/Request.dart';
import 'package:sindcelma_app/model/entities/User.dart';
import 'package:sindcelma_app/model/services/UserManagerService.dart';

import '../../../components/Btn.dart';
import '../../../components/Input.dart';
import '../../../themes.dart';

class AlterarEmail extends StatefulWidget {

  final Function onResponse;

  const AlterarEmail({required this.onResponse, Key? key}) : super(key: key);

  @override
  State<AlterarEmail> createState() => _AlterarEmailState();
}

class _AlterarEmailState extends State<AlterarEmail> {

  String novoEmail = "";
  bool emailStatus = false;

  void close(){
    Navigator.pop(context);
  }

  void saveData() async {

    // checar se email é válido
    if(!emailStatus){
      widget.onResponse(false, false);
      return;
    }

    var request = Request();

    await request.post('/user/socios/update_email', {
      "slug":User().socio.getSlug(),
      "key":User().tempKey,
      "email":novoEmail
    });

    if(request.code() != 200){
      if(request.code() == 403){
        widget.onResponse(false, true);
        return close();
      }
      widget.onResponse(false, false);
    } else {
      widget.onResponse(true, false);
      await UserManagerService().reset();
      Request.reloadApp();
    }

  }

  @override
  Widget build(BuildContext context) {

    DinamicInput dinamicInputEmail = Input(label: "alterar e-mail", value: "",
        onChanged: (str, status) {
          novoEmail = str;
          emailStatus = status;
        });
    dinamicInputEmail.setRules(RegExp(r'^[a-z0-9.]+@[a-z0-9]+\.[a-z]+(\.[a-z]+)?$'), "e-mail não é válido");
    Widget inputEmail = dinamicInputEmail as Widget;

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
            child: Text('Alterar Email',
              style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Oswald',
                  fontSize: 22
              ),
            ),
          ),
          const Center(
            child: Text('email atual:',
              style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Oswald',
                  fontSize: 18
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(User().email,
                style: const TextStyle(
                    color: Colors.black54,
                    fontFamily: 'Calibri',
                    fontSize: 19
                ),
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
                    child: Text('ATENÇÃO! APÓS ALTERAÇÃO DO EMAIL',
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
            child: inputEmail,
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

