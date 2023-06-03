import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/Input.dart';

import '../../../components/Btn.dart';
import '../../../model/Request.dart';
import '../../../model/entities/User.dart';
import '../../../model/services/UserManagerService.dart';
import '../../../themes.dart';

class CancelarInscricao extends StatefulWidget {
  final Function onResponse;
  const CancelarInscricao({Key? key, required this.onResponse}) : super(key: key);

  @override
  State<CancelarInscricao> createState() => _CancelarInscricaoState();
}

class _CancelarInscricaoState extends State<CancelarInscricao> {

  String senha = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
            child:  Icon(Icons.logout,
              color: Colors.red,
              size: 40,
            ),
          ),
          const Center(
            child: Text('CANCELAR INSCRIÇÃO',
              style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Oswald',
                  fontSize: 22
              ),
            ),
          ),

          Container(
            color: Colors.red,
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Center(
                    child: Text('ATENÇÃO! DEPOIS DE CANCELAR SUA INSCRIÇÃO, TODOS OS SEUS DADOS SERÃO DELETADOS',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Oswald',
                          fontSize: 18
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Input(
              label: "senha",
              value: "",
              onChanged: (value, status){
                senha = value;
              },
            ),
          ),

          Padding(padding: const EdgeInsets.all(10),
            child: Btn(TypeButton.elevated, TypeColor.secondary, "EXCLUIR CONTA", () async {
              cancelarInscricao();
            }),
          )

        ],
      ),
    );
  }

  void close(){
    Navigator.pop(context);
  }

  Future<void> cancelarInscricao() async {

    var request = Request();
    await request.post('/user/socios/cancelar_inscricao', {
      "pass":senha,
      "key":User().tempKey
    });

    if(request.code() != 200){
      widget.onResponse(request.code());
    } else {
      widget.onResponse(request.code());
      await UserManagerService().reset();
      Request.reloadApp();
    }

  }
}
