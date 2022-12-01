import 'package:flutter/material.dart';
import 'package:sindcelma_app/pages/app/ccts/CCTLoading.dart';

import '../../../model/Request.dart';

class CCTItemSelected extends StatefulWidget {

  final String title;
  final int id;
  final Function onRefresh;
  final bool fav;

  const CCTItemSelected({required this.fav, required this.title,  required this.id, required this.onRefresh, Key? key}) : super(key: key);

  @override
  State<CCTItemSelected> createState() => _CCTItemSelectedState();
}

class _CCTItemSelectedState extends State<CCTItemSelected> {

  bool favItem = false;
  bool loading = true;

  String img = "";
  String resumo = "";
  String texto = "";

  Widget getWidget(){
    return loading ? const CCTLoading() : generateDetail();
  }

  Widget generateDetail(){
    return Column(
      children: [
        Image.network(img,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(resumo,
            style: const TextStyle(
             fontFamily: 'Oswald',
             fontSize: 18,
             fontWeight: FontWeight.bold
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(texto,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontFamily: 'Calibri',
              fontSize: 18,
            ),
          ),
        )
      ],
    );
  }

  void setLoadingState(bool status){
    setState(() {
      loading = status;
    });
  }

  void getItemDetail() async {
    setLoadingState(true);
    var request = Request();
    await request.post('/cct/item_detail', {
      "item_id":widget.id
    });

    if(request.code() != 200){
      // mostra o erro
      return;
    }

    var response = request.response()['message'][0];
    img = response['imagem'];
    resumo = response['resumo'];
    texto = response['texto'];

    setLoadingState(false);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    favItem = widget.fav;
    getItemDetail();
  }

  void addFavItem() async {
    
    toggleFavItem(!favItem);
    
    var request = Request();
   
    await request.post('/cct/save_fav', {
      "item_id":widget.id
    });
    
    if(request.code() != 200){
      toggleFavItem(!favItem);
      // mostra erro
      return;
    }
    
    widget.onRefresh();

  }

  void toggleFavItem(status){
    setState(() {
      favItem = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.red,
                  ),
                ),
                Flexible(
                  child:  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: 'Oswald',
                          fontSize: 20,
                          color: Colors.red
                      ),
                    ),
                  ),
                )
                ,
                GestureDetector(
                  child: Icon(
                    favItem ? Icons.star : Icons.star_outline,
                    color: Colors.red,
                  ),
                  onTap: (){
                    addFavItem();
                  },
                )
              ],
            ),
          ),
          getWidget()
        ],
      ),
    );
  }
}
