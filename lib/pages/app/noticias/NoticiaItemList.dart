import 'package:flutter/material.dart';
import 'package:sindcelma_app/model/entities/Noticia.dart';
import 'package:sindcelma_app/pages/app/noticias/NoticiaSelected.dart';

class NoticiaItemList extends StatelessWidget {

  final Noticia noticia;

  const NoticiaItemList({required this.noticia, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => NoticiaSelected( noticia: noticia,)
            )
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: ListTile(
          shape: const Border(
            bottom: BorderSide(),
          ),
          title: Text(
            noticia.titulo,
            style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontFamily: 'Oswald',
                height: 1
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              noticia.subtitulo.length > 100 ? "${noticia.subtitulo.substring(0, 97)}..." :  noticia.subtitulo,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13
              ),
            ),
          ),
          leading: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 100,
              maxWidth: 120,
            ),
            child: Image.network(noticia.imagem, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
