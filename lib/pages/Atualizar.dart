import 'package:flutter/material.dart';
import 'package:sindcelma_app/model/entities/InfoApp.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/Btn.dart';
import '../themes.dart';

class Atualizar extends StatefulWidget {

  final Function response;

  const Atualizar(this.response, {Key? key}) : super(key: key);

  @override
  State<Atualizar> createState() => _AtualizarState();
}

class _AtualizarState extends State<Atualizar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Align(
                alignment: Alignment.center,
                child: Image.asset('assets/logo_horizontal.png'),
              ),
            ),
            const Padding(padding: EdgeInsets.all(20),
              child: Text("Há uma nova versão disponível!",
                style: TextStyle(
                    fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Padding(padding: EdgeInsets.all(20),
              child: Text("O aplicativo precisa ser atualizado!",
                style: TextStyle(
                    fontSize: 20
                ),
                textAlign: TextAlign.center,
              ),
            ),
            BtnIcon(
                TypeColor.secondary,
                "ATUALIZAR APP",
                const Icon(Icons.open_in_new,
                  color: Colors.green,
                ), () async {
                    final Uri url = Uri.parse(InfoApp().packages());
                  try {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } catch (e) {
                    print(e.toString());
                  }
                }
            )
          ],
        ),
      ),
    );
  }
}
