import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sindcelma_app/components/Input.dart';
import 'package:sindcelma_app/components/LoadingComponent.dart';
import 'package:sindcelma_app/model/Request.dart';

import '../../../components/Btn.dart';
import '../../../components/DateInput.dart';
import '../../../components/SelectInput.dart';
import '../../../model/entities/User.dart';
import '../../../themes.dart';

class InformacoesPessoais extends StatefulWidget {

  final Function(bool status, bool refresh) onResponse;

  const InformacoesPessoais({required this.onResponse, Key? key}) : super(key: key);

  @override
  State<InformacoesPessoais> createState() => _InformacoesPessoaisState();
}

class _InformacoesPessoaisState extends State<InformacoesPessoais> {

  bool loading = true;

  String cpf = "";
  String rg = "";
  String genero = "Gênero";
  String data_nascimento = "";
  String data_nascimento_en = "";
  String estado_civil = "Estado Civil";
  String telefone = "";

  void close(){
    Navigator.pop(context);
  }

  void saveData() async {
    var request = Request();

    if(rg.trim() == "" || estado_civil == "Estado Civil" || data_nascimento_en == "" || rg == ""){
      widget.onResponse(false, false);
      return;
    }

    await request.post('/user/socios/update_dados_pessoais', {
      "slug":User().socio.getSlug(),
      "key":User().tempKey,
      "rg":rg,
      "estado_civil":estado_civil,
      "data_nascimento":data_nascimento_en,
      "telefone":telefone,
      "sexo":genero[0].toUpperCase()
    });

    if(request.code() != 200){
      if(request.code() == 403){
        widget.onResponse(false, true);
        return close();
      }
      widget.onResponse(false, false);
    } else {
      widget.onResponse(true, false);
      setState(() {
        loading = false;
      });
      close();
    }

  }

  void afterLoading(){
    setState(() {
      loading = false;
    });
  }

  void getDataSocio() async {

    var request = Request();

    await request.post('/user/socios/get_dados_pessoais', {
      "slug":User().socio.getSlug(),
      "key":User().tempKey
    });

    if(request.code() != 200){
      if(request.code() == 404){
        afterLoading();
        return;
      }
      if(request.code() == 403){
        widget.onResponse(false, true);
        return close();
      }
      widget.onResponse(false, false);
      return close();
    }

    var response = request.response()['message'];

    final DateFormat formatterBr = DateFormat('dd/MM/yyyy');
    final DateFormat formatterEn = DateFormat('yyyy-MM-dd');

    switch(response['sexo'].toString().toLowerCase()){
      case 'f': genero = 'Feminino'; break;
      case 'm': genero = 'Masculino'; break;
      case 'n':
      default:
        genero = 'Nenhum';
    }

    if(response['data_nascimento'] != null){
      DateTime data = DateTime.parse(response['data_nascimento']);
      data_nascimento = formatterBr.format(data);
      data_nascimento_en = formatterEn.format(data);
    }


    rg = response['rg'] ?? "";
    estado_civil = response['estado_civil'] ?? "";
    telefone = response['telefone'] ?? "";
    cpf = response['cpf'] ?? "";

    afterLoading();

  }

  @override
  void initState() {
    super.initState();
    getDataSocio();
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
          child:  Icon(Icons.verified_user_outlined,
            color: Colors.red,
            size: 40,
          ),
        ),
        const Center(
          child: Text('Alterar Informações Pessoais',
            style: TextStyle(
                color: Colors.red,
                fontFamily: 'Oswald',
                fontSize: 22
            ),
          ),
        ),
        const Center(
          child: Text('CPF:',
            style: TextStyle(
                color: Colors.red,
                fontFamily: 'Oswald',
                fontSize: 22
            ),
          ),
        ),
        Center(
          child: Text(cpf,
            style: const TextStyle(
                color: Colors.black54,
                fontFamily: 'Oswald',
                fontSize: 22
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: SelectInput(
              label: 'Gênero',
              list: const ['Gênero','Masculino', 'Feminino', 'Nenhum'],
              onChange: (String value){
                genero = value;
              },
              isError: (String value){
                return value == 'Gênero' || value.isEmpty;
              },
              valueinit: genero,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: SelectInput(
              label: 'Estado Civil',
              list: const ['Estado Civil','Soltero(a)', 'Casado(a)'],
              onChange: (String value){
                estado_civil = value;
              },
              isError: (String value){
                return value == 'Estado Civil' || value.isEmpty;
              },
              valueinit: estado_civil,
          ),
        ),
        Padding(padding: const EdgeInsets.all(10),
          child: DateInput(
              label: "Data de Nascimento",
              value: data_nascimento,
              onChanged: (dataBr, dataEn){
                if(dataBr != null){
                  data_nascimento = dataBr;
                  data_nascimento_en = dataEn;
                }
              }
          ),
        ),
        Padding(padding: const EdgeInsets.all(10),
          child: Input(
              label: "rg",
              value: rg,
              onChanged: (str, status){
                rg = str;
              }
          ),
        ),
        Padding(padding: const EdgeInsets.all(10),
          child: Input(
              label: "telefone",
              value: telefone,
              onChanged: (str, status){
                telefone = str;
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
      body: loading ? const LoadingComponent("Aguarde...", false) : getForm(),
    );
  }


}
