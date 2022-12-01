import 'package:flutter/material.dart';
import 'package:sindcelma_app/model/Request.dart';
import 'package:sindcelma_app/model/entities/Sorteio.dart';
import 'package:sindcelma_app/pages/app/ccts/CCTLoading.dart';

import 'SorteioFull.dart';

class SorteioList extends StatefulWidget {
  const SorteioList({Key? key}) : super(key: key);

  @override
  State<SorteioList> createState() => _SorteioListState();
}

class _SorteioListState extends State<SorteioList> {

  List<Widget> sorteios = [];
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
  }

  void loadingStatus(bool status){
    setState(() {
      loading = status;
    });
  }

  void getList() async {

    loadingStatus(true);

    var request = Request();
    await request.post('/sorteios/list', {});

    if(request.code() != 200) return;

    var response = request.response()['message'];
    for( var res in response ){
      sorteios.add(
          getItem(
              res['sorteio_id'],
              res['titulo'],
              res['premios'],
              res['data'],
              res['qt_vencedores'],
              res['inscrito'],
              res['vencedor']
          )
      );
    }

    loadingStatus(false);

  }


  Widget getItem(int id, String item, String premio, String data, int total, bool inscrito, bool vencedor){

    Sorteio sorteio = Sorteio();
    sorteio.setId(id);
    sorteio.setTitulo(item);
    sorteio.setPremio(premio);
    sorteio.setDataSorteio(data);
    sorteio.setTotalVencedores(total);
    sorteio.inscrito = inscrito;
    sorteio.vencedor = vencedor;

    var status = sorteio.difference().inSeconds > 10;
    var textStatus = "";

    if(vencedor){
      textStatus = "PARABÉNS! VOCÊ GANHOU!";
    } else
    if(!status){
      textStatus = "INSCRIÇÕES FINALIZADAS";
    } else
    if(inscrito){
      textStatus = "INSCRITO";
    } else {
      textStatus = "INSCREVA-SE";
    }





    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => SorteioFull(sorteio: sorteio)
            )
        );
      },
      child: Column(
        children: [
          Text(item,
            style: const TextStyle(
                fontSize: 25,
                fontFamily: 'Oswald'
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.green,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(30))
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Icon(Icons.card_giftcard),
                      subtitle: Text(premio,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Icon(Icons.people_outline),
                      subtitle: Text(sorteio.totalVencedores(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Icon(Icons.calendar_month_outlined),
                      subtitle: Text(sorteio.data(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(textStatus,
            style: TextStyle(
                color: !status && !sorteio.vencedor ? Colors.red : Colors.green,
                fontFamily: 'Oswald',
                fontSize: 18
            ),
          ),
          const Divider(
            color: Colors.black54,
          )
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Container(
              color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.only(top:20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        flex: 3,
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset('assets/sorteio_logo.png')
                        )
                    ),
                    Expanded(
                        flex: 1,
                        child: Container()
                    )
                  ],
                ),
              ),
            ),
            loading ?
            const CCTLoading() :
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: sorteios,
            )
          ],
        ),
      ),
    );
  }
}
