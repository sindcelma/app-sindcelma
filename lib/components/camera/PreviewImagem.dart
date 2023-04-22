import 'package:flutter/material.dart';
import 'dart:io';

import 'package:sindcelma_app/components/Btn.dart';
import 'package:sindcelma_app/themes.dart';

class PreviewImagem extends StatelessWidget {

  final Function(File file) onFile;
  final File file;

  const PreviewImagem({required this.file, required this.onFile, Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 4,
              child: Image.file(file, fit: BoxFit.cover,)),
          Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(child: BtnIcon(
                    TypeColor.primary,
                    "",
                    const Icon(
                      Icons.close,
                      color: Colors.red,
                    ), (){ Navigator.pop(context); }
                  )),
                  Expanded(child: BtnIcon(
                      TypeColor.secondary,
                      "OK",
                      const Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 40,
                      ), (){
                        onFile(file);
                        Navigator.pop(context);
                    }
                  )),
                ],
              )
          )
        ],
      ),
    );
  }
}
