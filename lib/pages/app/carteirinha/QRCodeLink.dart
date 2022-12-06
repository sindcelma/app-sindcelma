import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sindcelma_app/components/Btn.dart';
import 'package:sindcelma_app/model/Config.dart';
import 'package:sindcelma_app/themes.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/entities/User.dart';

class QRCodeLink extends StatefulWidget {
  const QRCodeLink({Key? key}) : super(key: key);

  @override
  State<QRCodeLink> createState() => _QRCodeLinkState();
}

class _QRCodeLinkState extends State<QRCodeLink> {

  String data = "";
  int sec = 30;
  bool reloading = true;

  @override
  void initState() {
    super.initState();
    data = generateData();
    realoadQRCode();
  }

  String generateData(){

    String slug  = User().socio.getSlug();
    String salt  = User().socio.getSalt();
    int duration = DateTime.now().millisecondsSinceEpoch + 2 * 60 * 60 * 1000;
    // int duration = DateTime.now().millisecondsSinceEpoch + 35 * 1000; // + 35 segundos
    String data  = '{"slug":"$slug", "duration":$duration}';
    String key   = slug+salt+data;
    var bytes    = utf8.encode(key);
    var hash     = sha256.convert(bytes);

    var link     = "${Config.getUrl('/socio_verify/')}${base64.encode(utf8.encode(data))}.$hash";
    print(link);
    return link;

  }

  void realoadQRCode() async {
    while(reloading){
      await Future.delayed(const Duration(seconds: 1));
      if(sec == 0){
        if(reloading) {
          setState(() {
            sec = 30;
            data = generateData();

          });
        }
      } else {
        if(reloading) {
          setState(() {
            sec--;
          });
        }
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QrImage(
          data: data,
          backgroundColor: Colors.white,
          size: 200,
        ),
        Padding(padding: const EdgeInsets.all(20),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text("atualizando em $sec segundos",
                style: const TextStyle(
                    backgroundColor: Colors.white
                ),
              ),
            ),
          ),
        ),
        /*
        // implementar botão para link
        Padding(padding: const EdgeInsets.all(20),
          child: BtnIconOutline(
            TypeColor.secondary,
            "Verificar",
            const Icon(Icons.open_in_new),
              () async {
                final Uri url = Uri.parse(data);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  print("Nao é possivel");
                }
              }
          ),)
          */

      ],
    );
  }

  @override
  void dispose() {
    reloading = false;
    super.dispose();
  }
}
