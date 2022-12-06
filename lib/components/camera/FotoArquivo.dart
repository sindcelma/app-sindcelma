import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../themes.dart';
import '../Btn.dart';
import 'PreviewImagem.dart';

class FotoArquivo extends StatefulWidget {

  final Function onFile;
  final Function? onBack;

  const FotoArquivo(this.onFile, { this.onBack, Key? key}) : super(key: key);

  @override
  State<FotoArquivo> createState() => _FotoArquivoState();
}

class _FotoArquivoState extends State<FotoArquivo> {

  final imagePicker = ImagePicker();

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

    void preview(File file, Function close){
      showPreview(file, (file) {
        widget.onFile(file);
        Navigator.pop(context);
        close();
      });
    }


    Future getImageGalery() async {

      final file = await imagePicker.pickImage(source: ImageSource.gallery);
      if(file == null) return;
      preview(File(file.path), (){});

    }


    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: (){
                  widget.onBack!();
                  Navigator.pop(context);
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.red,
                      ),
                      Text("voltar",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 18
                        ),
                      )
                    ]
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 40),
              child: Text("ALTERAR IMAGEM DE USUÁRIO",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Oswald'
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BtnIconOutline(TypeColor.primary,
                    "USAR CAMERA",
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
                                    preview(file, () => Navigator.pop(context));
                                  },
                                );
                              }
                          )
                      );
                    }
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Text("OU",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Oswald'
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BtnIconOutline(TypeColor.primary,
                    "GALERIA DE IMAGEM",
                    const Icon(
                      Icons.image_outlined,
                      color: Colors.red,
                    ), () {
                      getImageGalery();
                    }
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
