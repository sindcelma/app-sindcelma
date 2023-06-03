import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/Firewall.dart';
import 'package:sindcelma_app/pages/app/ccts/CCTLoading.dart';
import 'package:sindcelma_app/pages/app/sorteios/SorteioWidget.dart';

import '../../../model/Request.dart';
import '../../../model/entities/Sorteio.dart';

class SorteioFull extends StatefulWidget {

  final Sorteio sorteio;

  const SorteioFull({ required this.sorteio, Key? key}) : super(key: key);

  @override
  State<SorteioFull> createState() => _SorteioFullState();
}

class _SorteioFullState extends State<SorteioFull> {

  List<Widget> itens = [];
  List<String> participantes = [];
  bool loading = true;

  void refresh(){
    setState(() {});
  }

  Future<List<Widget>> carregarVencedores() async {

    var request = Request();
    await request.get('/sorteios/${widget.sorteio.id()}/vencedores');
    List<Widget> lista = [];
    lista.add(const Padding(
      padding: EdgeInsets.all(20),
      child:  Text(
        "VENCEDORES",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 30,
          fontFamily: 'Oswald',
          color: Colors.white,
        ),
      ),
    ));

    if(request.code() == 404){

      lista.add( Text(
        "ainda não há vencedores",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.green.shade900,
            fontFamily: 'Calibri',
            fontSize: 18
        ),
      ));
      return lista;
    }
    var response = request.response()['message'];
    for(var vencedor in response){
      lista.add(Container(
        color: Colors.green.shade900,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text("${vencedor['nome']} ${vencedor['sobrenome']}",
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.limeAccent,
                fontFamily: 'Calibri',
                fontSize: 18
            ),
          ),
        ),
      ));
    }
    return lista;
  }

  @override
  void initState() {
    super.initState();
  }

  void carregarLista() async {
    if(itens.isEmpty){
      itens.add(Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                Text("voltar",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),
                )
              ]
          ),
        ),
      ));
      itens.add(SorteioWidget(widget.sorteio, isFull: true,));
      List<Widget> vencedores = await carregarVencedores();
      itens.addAll(vencedores);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    carregarLista();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.green,
        body: Firewall(child: loading ? const CCTLoading() :  ListView(
          children:  itens,
        ), onCheckMessage: () => Navigator.pop(context)),
      ),
    );
  }
}
