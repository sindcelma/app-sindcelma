import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/CameraFile.dart';

import '../../../components/Btn.dart';
import '../../../components/camera/PreviewImagem.dart';
import '../../../themes.dart';

class AlterarImagem extends StatefulWidget {

  //Function(File file) onFile;

  AlterarImagem({ Key? key}) : super(key: key);

  @override
  State<AlterarImagem> createState() => _AlterarImagemState();
}

class _AlterarImagemState extends State<AlterarImagem> {

  void showFile(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CameraFile(onRespose: (status, refresh){

            }, type: ImageType.fotoArquivo)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(child: Text("ALTERAR IMAGEM DE USUÁRIO",
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Oswald'
              ),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BtnIconOutline(TypeColor.primary,
                    "CAMERA",
                    const Icon(
                      Icons.camera_alt,
                      color: Colors.red,
                    ), () {
                      showFile();
                    }
                )
              ],
            )
          ],
      ),
    );
  }
}
