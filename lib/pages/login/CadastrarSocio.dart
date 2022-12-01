import 'package:flutter/material.dart';
import 'package:sindcelma_app/model/entities/User.dart';
import 'package:sindcelma_app/pages/login/cadastro_activities/CadastroActivity.dart';

class CadastrarSocio extends StatelessWidget {

  User user = User();

  Function response;

  CadastrarSocio(this.response, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CadastroActivity(response, user);
  }
}

