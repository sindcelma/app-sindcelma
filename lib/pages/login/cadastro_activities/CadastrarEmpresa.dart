import 'package:flutter/material.dart';
import 'package:sindcelma_app/model/entities/User.dart';
import 'package:sindcelma_app/components/Input.dart';
import 'package:sindcelma_app/pages/login/cadastro_activities/CadastroActivity.dart';

import '../../../components/DateInput.dart';

class CadastrarEmpresa extends StatelessWidget implements Activity {

  const CadastrarEmpresa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        const Text("Digite sua informações profissionais:"),
        Padding(padding: const EdgeInsets.all(10), child: Input(
          label: "Cargo",
          value: User().socio.getCargo() ?? "",
          onChanged: (str,status) => User().socio.setCargo(str)
          ),),
        Padding(padding: const EdgeInsets.all(10), child: DateInput(
          onChanged: (dataBr, dataEn){
            User().socio.setDataAdmissao(dataBr);
            User().socio.setDataEn(dataEn);
          },
          label: "Data de Admissão",
          value: User().socio.getDataAdmissao(),
        ),),
      ],
    );
  }

  @override
  Future<ResponseActivity> checkStatusActivity() async {
    String cargo = User().socio.getCargo() ?? "";
    if(User().socio.getDataAdmissao().isNotEmpty
        && cargo.isNotEmpty) {
      return ResponseActivity(status: true, response: "");
    }
    return ResponseActivity(status: false, response: "Há campos vazios");

  }

}
