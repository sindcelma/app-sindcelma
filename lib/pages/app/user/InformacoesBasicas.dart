import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/Btn.dart';
import 'package:sindcelma_app/components/LoadingComponent.dart';
import 'package:sindcelma_app/model/Request.dart';
import 'package:sindcelma_app/model/services/UserManagerService.dart';
import 'package:sindcelma_app/themes.dart';

import '../../../components/Input.dart';
import '../../../model/entities/User.dart';

class InformacoesBasicas extends StatefulWidget {

  final Function onResponse;

  const InformacoesBasicas({required this.onResponse, Key? key}) : super(key: key);

  @override
  State<InformacoesBasicas> createState() => _InformacoesBasicasState();
}

class _InformacoesBasicasState extends State<InformacoesBasicas> {

  String nome = "";
  String sobrenome = "";
  bool loading = false;

  void close(){
    Navigator.pop(context);
  }

  void saveData() async {
    setState(() {
      loading = true;
    });

    if(nome == ""){
      nome = User().nome;
    }

    if(sobrenome == ""){
      sobrenome = User().sobrenome;
    }

    var request = Request();
    await request.post('/user/socios/update_dados_socio', {
      "nome":nome,
      "sobrenome":sobrenome,
      "key":User().tempKey,
      "slug":User().socio.getSlug()
    });

    if(request.code() != 200){
      if(request.code() == 403){
        widget.onResponse(false, true);
        return close();
      }
      widget.onResponse(false, false);
    } else {
      User().nome = nome;
      User().sobrenome = sobrenome;
      UserManagerService().updateUser();
      widget.onResponse(true, false);
    }

    setState(() {
      loading = false;
    });

  }

  Widget getForm(){
    return ListView(
      children: [
        const Padding(padding: EdgeInsets.all(10),
          child:  Icon(Icons.person_outline,
            color: Colors.red,
            size: 40,
          ),
        ),
        const Center(
          child: Text('Alterar Informações Básicas',
            style: TextStyle(
                color: Colors.red,
                fontFamily: 'Oswald',
                fontSize: 22
            ),
          ),
        ),
        Padding(padding: const EdgeInsets.all(10),
          child: Input(
              label: "nome",
              value: User().nome,
              onChanged: (str, status){
                nome = str;
              }
          ),
        ),
        Padding(padding: const EdgeInsets.all(10),
          child: Input(
              label: "sobrenome",
              value: User().sobrenome,
              onChanged: (str, status){
                sobrenome = str;
              }
          ),
        ),
        Padding(padding: const EdgeInsets.all(10),
          child: Btn(TypeButton.elevated, TypeColor.secondary, "SALVAR", () async {
            saveData();
          }),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading ? const LoadingComponent("aguarde...", false): getForm(),
    );
  }
}
