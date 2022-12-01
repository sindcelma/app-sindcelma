import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/Btn.dart';
import 'package:sindcelma_app/model/Request.dart';
import 'package:sindcelma_app/model/entities/User.dart';
import 'package:sindcelma_app/model/services/UserManagerService.dart';
import 'package:sindcelma_app/pages/login/CadastrarSocio.dart';
import 'package:sindcelma_app/pages/login/LoginArea.dart';
import 'package:sindcelma_app/pages/login/SouVisitante.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sindcelma_app/themes.dart';

class LoginPage extends StatelessWidget {

  final Function response;
  final String? subpage;

  const LoginPage(this.response, {Key? key, this.subpage}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget root = OptionsUser(response);

    if(subpage != null){
      switch(subpage){
        case 'login':
          root = LoginArea(response);
          break;
      }
    }

    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      routes: {
        '/': (context) => root,
        '/loginArea': (context) => LoginArea(response),
        '/cadastrarSocio': (context) => CadastrarSocio((){
          Navigator.pushNamed(context, '/loginArea');
        }),
        '/visitante': (context) => SouVisitante(response)
      },
    );
  }
}

class OptionsUser extends StatelessWidget {

  final Function response;

  const OptionsUser(this.response, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(padding: const EdgeInsets.all(40),
            child: Image.asset('assets/logo_full.jpg',
                alignment: Alignment.center,
                fit: BoxFit.fill
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
              child: Btn(
                TypeButton.elevated,
                TypeColor.primary,
                "SOU SÓCIO", () {
                Navigator.pushNamed(context,'/loginArea');
                }
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
            child: Btn(
                TypeButton.elevated,
                TypeColor.secondary,
                "QUERO SER SÓCIO", () {
                  Navigator.pushNamed(context,'/cadastrarSocio');
                }
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
            child: Btn(
                TypeButton.text,
                TypeColor.text,
                "SOU VISITANTE", () async {
                  User().status = 1;
                  await UserManagerService().saveUser(onlyUser: true);
                  response(true);
                }
            ),
          ),
        ],
      ),
    );
  }
}
