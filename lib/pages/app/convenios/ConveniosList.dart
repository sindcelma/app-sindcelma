import 'package:flutter/material.dart';
import 'package:sindcelma_app/model/Request.dart';
import 'package:sindcelma_app/model/entities/Convenio.dart';
import 'package:sindcelma_app/pages/app/ccts/CCTLoading.dart';
import 'package:sindcelma_app/pages/app/convenios/ConvenioItemList.dart';

class ConveniosList extends StatefulWidget {
  const ConveniosList({Key? key}) : super(key: key);

  @override
  State<ConveniosList> createState() => _ConveniosListState();
}

class _ConveniosListState extends State<ConveniosList> {

  List<Widget> lista = [];
  bool carregando = true;
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lista.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.red,
                  ),
                ),
              )
          ),
          Expanded(
            flex: 4,
            child: Container(),
          )
        ]
    ));
    lista.add(const Padding(
      padding: EdgeInsets.all(15),
      child: Icon(
        Icons.beach_access,
        color: Colors.red,
        size: 40,
      ),
    ));
    lista.add(const Text(
      "Convênios",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 18,
          fontFamily: 'Oswald',
          color: Colors.red
      ),
    ));
    getList();
  }

  void getList() async {

      setState(() {
        carregando = true;
      });

      Request req = Request();
      await req.get('/convenios/list');
      if(req.code() != 200) return;

      var res = req.response()['message'];

      for(int i = 0; i < res.length; i++){
        lista.add(ConvenioItemList(
          id: res[i]['id'],
          titulo: res[i]['titulo'],
          imagem: res[i]['imagem'],
          texto: res[i]['texto']
        ));
      }

      setState(() {
        carregando = false;
      });

  }

  Widget generateList(){
    return ListView(
      scrollDirection: Axis.vertical,
      children: lista,
    );
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        body: !carregando ? generateList() : const Center(
          child: CCTLoading(),
        ),
      );
  }

}
