import 'package:flutter/material.dart';
import 'package:sindcelma_app/model/Request.dart';

import '../../../components/Btn.dart';
import '../../../components/Input.dart';
import '../../../themes.dart';

class UserArea extends StatelessWidget {

  String doc = "";

  Function response;
  Function onError;

  UserArea(this.response, this.onError, {Key? key}) : super(key: key);

  void check_doc() async {

    var request = Request();

    await request.post('/user/check_login', {
      'doc':doc
    });

    if(request.code() != 200){
     onError("Não há um associado cadastrado com este e-mail ou CPF");
      return;
    }

    var res   = request.response()['message'];
    if(res['email'] == false){
      response("", false, res['cpf']);
    } else {
      response(res['email'], true, res['cpf']);
    }


  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
              child: Text("Login", style: TextStyle(
              fontSize: 20,
              ),),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Input(
              label: 'e-mail ou CPF',
              value: "",
              onChanged: (str, status){
                doc = str;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: BtnIconOutline(
                TypeColor.secondary,
                "Verificar",
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.green,
                ),
                    (){
                  check_doc();
                }
            ),
          ),
        ],
    );
  }
}
