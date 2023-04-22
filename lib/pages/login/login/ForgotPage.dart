import 'package:flutter/material.dart';
import 'package:sindcelma_app/pages/login/login/CodeArea.dart';
import 'package:sindcelma_app/pages/login/login/MessageSuccessCode.dart';
import 'package:sindcelma_app/pages/login/login/ResetPassword.dart';
import 'package:sindcelma_app/pages/login/login/SendEmail.dart';

import '../../../components/AlertMessage.dart';

class ForgotPage extends StatefulWidget {

  Function response;
  bool showLogo;

  ForgotPage(this.response, { this.showLogo = false, Key? key}) : super(key: key);

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {

  List<Widget> pages = [];
  int keyPage = 0;
  String email = "";
  String codigo = "";

  void onError(String message){
    ScaffoldMessenger.of(context).showSnackBar(
        AlertMessage(
            type: "error",
            message: message
        ).alert()
    );
  }

  @override
  Widget build(BuildContext context) {

    pages = [
      SendEmail((email){
        setState(() {
          this.email = email;
          keyPage++;
        });
      }, onError, widget.showLogo),
      CodeArea((novoCodigo){
        setState(() {
          codigo = novoCodigo;
          keyPage++;
        });
      }, onError, email, widget.showLogo),
      ResetPassword((){
        setState(() {
          keyPage++;
        });
      }, onError, email, codigo, widget.showLogo)
    ];
    return pages[keyPage];
  }
}
