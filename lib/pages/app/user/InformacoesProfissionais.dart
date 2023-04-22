import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sindcelma_app/components/Btn.dart';
import 'package:sindcelma_app/components/DateInput.dart';

import '../../../components/Input.dart';
import '../../../components/LoadingComponent.dart';
import '../../../model/Request.dart';
import '../../../model/entities/User.dart';
import '../../../model/services/UserManagerService.dart';
import '../../../themes.dart';

class InformacoesProfissionais extends StatefulWidget {

  final Function onResponse;

  const InformacoesProfissionais({required this.onResponse, Key? key}) : super(key: key);

  @override
  State<InformacoesProfissionais> createState() => _InformacoesProfissionaisState();
}

class _InformacoesProfissionaisState extends State<InformacoesProfissionais> {

  String cargo = "";
  String data_admissao = "";
  String num_matricula = "";
  String data_en = "";

  bool loading = true;

  void close(){
    Navigator.pop(context);
  }

  void afterLoad(){
    setState(() {
      loading = false;
    });
  }
  
  void getData() async {
    var request = Request();
    await request.post('/user/socios/get_dados_profissionais', {
      "empresa_id":1,
      "key":User().tempKey,
      "slug":User().socio.getSlug()
    });

    if(request.code() != 200){
      if(request.code() == 403){
        widget.onResponse(false, true);
        return close();
      }
      widget.onResponse(false, false);
      return close();
    }

    var response = request.response()['message'];
    cargo = response['cargo'] ?? "";
    final DateFormat formatterBr = DateFormat('dd/MM/yyyy');
    final DateFormat formatterEn = DateFormat('yyyy-MM-dd');
    if(response['data_admissao'] != null){
      DateTime data = DateTime.parse(response['data_admissao']);
      data_admissao = formatterBr.format(data);
      data_en = formatterEn.format(data);
    }

    num_matricula = response['num_matricula'] ?? "";

    afterLoad();

  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void saveData() async {
    setState(() {
      loading = true;
    });

    var request = Request();

    await request.post('/user/socios/update_dados_profissionais', {
      "cargo":cargo,
      "data_admissao":data_en,
      "num_matricula":num_matricula,
      "empresa_id":1,
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
      widget.onResponse(true, false);
    }

    setState(() {
      loading = false;
    });

  }

  Widget getForm(){
    return ListView(
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
          child:  Icon(Icons.energy_savings_leaf_outlined,
            color: Colors.red,
            size: 40,
          ),
        ),
        const Center(
          child: Text('Alterar Informações Profissionais',
            style: TextStyle(
                color: Colors.red,
                fontFamily: 'Oswald',
                fontSize: 22
            ),
          ),
        ),
        const Center(
          child: Text('Suzano S/A',
            style: TextStyle(
                color: Colors.red,
                fontFamily: 'Oswald',
                fontSize: 22
            ),
          ),
        ),
        Padding(padding: const EdgeInsets.all(10),
          child: Input(
              label: "cargo",
              value: cargo,
              onChanged: (str, status){
                cargo = str;
              }
          ),
        ),
        Padding(padding: const EdgeInsets.all(10),
          child: Input(
              label: "número da matrícula",
              value: num_matricula,
              onChanged: (str, status){
                num_matricula = str;
              }
          ),
        ),
        Padding(padding: const EdgeInsets.all(10),
          child: DateInput(
              label: "Data de Admissão",
              value: data_admissao,
              onChanged: (dataBr, dataEn){
                if(dataBr != null){
                  data_admissao = dataBr;
                  data_en = dataEn;
                }
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
