import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sindcelma_app/model/services/NoticiasService.dart';

import '../../../model/entities/Noticia.dart';
import '../../../model/services/InfoService.dart';


class NoticiaSelected extends StatefulWidget {

  final Noticia noticia;

  const NoticiaSelected({ required this.noticia, Key? key}) : super(key: key);

  @override
  State<NoticiaSelected> createState() => _NoticiaSelectedState();
}

class _NoticiaSelectedState extends State<NoticiaSelected> {

  String text = "";

  @override
  void initState() {
    super.initState();
    getText();
  }

  void getText() async {

    var res = await NoticiasService.get(widget.noticia.id);
    if(res == false || res.length == 0) return;
    setState(() {
      text = res[0]['text'];
    });

  }

  @override
  Widget build(BuildContext context) {

    Widget html = Text(text);

    if(InfoService.getWpNoticiasStatus()){
      html = Html(
          data:text
      );
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top:20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const Text("Voltar",
                    style: TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 25
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Image.network(widget.noticia.imagem),
                Padding(padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Text(widget.noticia.titulo,
                    style: const TextStyle(
                        fontSize: 25,
                        height: 1,
                        fontFamily: 'Oswald',
                        color: Colors.red
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(widget.noticia.subtitulo,
                    style: const TextStyle(
                        fontSize: 17,
                        fontFamily: 'Calibri',
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),

                Padding(padding: const EdgeInsets.only(left: 10, right: 10, top:10),
                  child: html,
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}
