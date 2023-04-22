import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/Btn.dart';
import 'package:sindcelma_app/themes.dart';

import '../model/entities/User.dart';

class Firewall extends StatelessWidget {

  final Widget child;
  final Function onCheckMessage;

  const Firewall({ required this.child, required this.onCheckMessage, Key? key}) : super(key: key);

  Widget layoutStatus(Icon icon, String title, String message, BuildContext context){
    return Container(
      color: Colors.white,
      child: Padding(padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 10), child: Image.asset('assets/logo_horizontal.png'),),
            Padding(padding: const EdgeInsets.only(top: 10), child: icon,),
            Text(title, style: const TextStyle(
                fontSize: 25,
                fontFamily: 'Oswald'
            ),),
            Padding(padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(message, style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Calibri'
              ),),),
            Btn(TypeButton.elevated, TypeColor.secondary, "OK!", () => onCheckMessage())
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    int statusSocio = User().socio.status;
    switch(statusSocio){
      case 0:
      case 1:
        // nao tem permissao
        return layoutStatus(
          const Icon(Icons.block,
            color: Colors.red,
            size: 100,
          ),
          "Você não tem permissão",
          "Apenas sócios do sindicato tem acesso à este serviço",
          context
        );
      case 2:
        // você ainda não foi aprovado
        return layoutStatus(
            const Icon(Icons.fmd_bad_outlined,
              color: Colors.deepOrange,
              size: 100,
            ),
            "Aguarde!",
            "Você ainda está em aprovação! Por favor, aguarde até que seus dados sejam verificados para acessar os serviços do aplicativo",
            context
        );
      case 3:
        // pode acessar
        return child;
      case 4:
        // está bloqueado
        return layoutStatus(
            const Icon(Icons.block,
              color: Colors.red,
              size: 100,
            ),
            "Você está bloqueado!",
            "Para saber mais, entre em contato com o Sindcelma",
            context
        );
    }
    return Container();
  }
}
