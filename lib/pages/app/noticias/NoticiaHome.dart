import 'package:flutter/material.dart';
import 'package:sindcelma_app/model/entities/Noticia.dart';

import 'NoticiaSelected.dart';

class NoticiaHome extends StatelessWidget {

  final String img;
  final String titulo;
  final String subtitulo;
  final String data;
  final int id;

  const NoticiaHome({required this.img, required this.titulo, required this.subtitulo, required this.id, required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => NoticiaSelected(
                  noticia: Noticia(
                      id: id,
                      titulo: titulo,
                      subtitulo: subtitulo,
                      imagem: img,
                      data: data
                  ),
                )
            )
        );
      },
      child: Column(
        children: [
          Image.network(img),
          Padding(padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Text(titulo,
              style: const TextStyle(
                  fontSize: 25,
                  height: 1,
                  fontFamily: 'Oswald',
                  color: Colors.red
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(subtitulo,
              style: const TextStyle(
                  fontSize: 17,
                  fontFamily: 'Calibri',
                  color: Colors.black
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Divider(
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
