import 'package:flutter/material.dart';
import 'package:sindcelma_app/pages/app/ccts/CCTLoading.dart';

import '../../../model/Request.dart';
import 'CCTSelected.dart';

class CCTList extends StatefulWidget {
  const CCTList({Key? key}) : super(key: key);

  @override
  State<CCTList> createState() => _CCTListState();
}

class _CCTListState extends State<CCTList> {
  
  List<Widget> itens = [];
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setList();
  }
  
  void loadingState(bool status){
    setState(() {
      loading = status;
    });
  }

  Widget generateItem(String titulo, int id){
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CCTSelected(title: titulo, id: id)
            )
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListTile(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.red, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          title: Text(titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 20,
                fontFamily: 'Oswald'
            ),
          ),
        ),
      ),
    );
  }
  
  void setList() async {

    loadingState(true);

    itens = [];

    var request = Request();
    await request.post('/cct/list', {});
    if( request.code() != 200){
      return;
    }

    itens.add(
        Row(
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
        )
      );
    itens.add(const Padding(
      padding: EdgeInsets.all(15),
      child: Icon(
        Icons.book_outlined,
        color: Colors.red,
        size: 40,
      ),
    ));
    itens.add(const Text(
      "Convenções Coletivas de Trabalho",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 18,
          fontFamily: 'Oswald',
          color: Colors.red
      ),
    ));

    var list = request.response()['message'];
    for(var item in list ){
      itens.add(generateItem(item['titulo'], item['id']));
    }

    loadingState(false);
  }
  
  Widget generateList(){
    return ListView(
      children: itens,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading ? const Center(child: CCTLoading(),) : generateList(),
    );
  }
}
