import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/Btn.dart';
import 'package:sindcelma_app/model/entities/Noticia.dart';
import 'package:sindcelma_app/model/services/NoticiasService.dart';
import 'package:sindcelma_app/pages/app/noticias/NoticiaHome.dart';
import 'package:sindcelma_app/pages/app/noticias/NoticiaItemList.dart';
import 'package:sindcelma_app/themes.dart';


class NoticiasList extends StatefulWidget {

  const NoticiasList({Key? key}) : super(key: key);

  @override
  State<NoticiasList> createState() => _NoticiasListState();

}

class _NoticiasListState extends State<NoticiasList> {

  int page = 1;
  String search = "";
  List<Noticia> list = [];
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState(){
    super.initState();
    generateNoticias();
  }

  generateNoticias() async {

    var resp = await NoticiasService.list(page: page);
    if(resp != false) {
      setState(() {
        isLoading = false;
      });
    }

    hasMore = resp.length > 0;

    for(int i = 0; i < resp.length; i++ ){
      list.add(Noticia(
          id: resp[i]['id'],
          titulo: resp[i]['titulo'],
          subtitulo: resp[i]['subtitulo'],
          imagem: resp[i]['imagem'],
          data: resp[i]['data_created']
        )
      );
    }

    setState(() {
      isLoading = false;
    });

  }

  List<Widget> listNoticias(){

    List<Widget> lista = [];

    for(int i = 0; i < list.length; i++){
      Noticia noticia = list[i];
      if(i == 0){
        lista.add(NoticiaHome(img: noticia.imagem, titulo: noticia.titulo, subtitulo: noticia.subtitulo, data: noticia.data, id: noticia.id));
        continue;
      }
      lista.add(NoticiaItemList(noticia: noticia));
    }

    return lista;

  }

  @override
  Widget build(BuildContext context) {

    List<Widget> mylist = listNoticias();
    var btn = !isLoading ?
    BtnIcon(
        TypeColor.secondary,
        "Carregar mais",
        const Icon(Icons.more_horiz,
          color: Colors.green,
        ),
        () {
          page = page + 1;
          setState(() {
            isLoading = true;
          });
          generateNoticias();
        }
    ) :
    BtnIcon(
        TypeColor.primary,
        "carregando...",
        const Icon(Icons.more_horiz),
        () {}
    );

    if(hasMore){
      mylist.add(btn);
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
                    const Text("Notícias",
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
                children: mylist,
              ),
            )
        ],
      ),
    );

  }
}
