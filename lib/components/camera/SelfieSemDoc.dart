import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/Btn.dart';
import 'package:sindcelma_app/components/camera/PreviewImagem.dart';
import 'package:sindcelma_app/themes.dart';
import 'dart:io';

class SelfieSemDoc extends StatefulWidget {

  final Function(File file) onFile;

  const SelfieSemDoc(this.onFile, {Key? key}) : super(key: key);

  @override
  State<SelfieSemDoc> createState() => _SelfieSemDocState();
}

class _SelfieSemDocState extends State<SelfieSemDoc> {
  @override
  Widget build(BuildContext context) {

    void showPreview(file, Function(File file) onFile){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => PreviewImagem(
                file: file,
                onFile: onFile,
              )
          )
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:CrossAxisAlignment.center,
      children: [
        const Text("TIRE UMA SELFIE",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 25
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('assets/user_selfie.png')
          ],
        ),
        const Padding(padding: EdgeInsets.all(20),
          child: Text("Esta imagem será a foto da sua carteirinha... Então Capriche!",
            textAlign: TextAlign.center,

            style: TextStyle(
              fontFamily: 'Calibri',
              fontSize: 18
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BtnIconOutline(TypeColor.primary,
                "CAMERA",
                const Icon(
                  Icons.camera_alt,
                  color: Colors.red,
                ), () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_){
                            return CameraCamera(
                              onFile: (file) {
                                showPreview(file, (file) {
                                  widget.onFile(file);
                                  Navigator.pop(context);
                                  setState(() {});
                                });
                              },
                            );
                          }
                      )
                  );
                }
            )
          ],
        )
      ],
    );

  }
}
