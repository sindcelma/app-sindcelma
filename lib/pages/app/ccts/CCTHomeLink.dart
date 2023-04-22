import 'package:flutter/material.dart';
import 'package:sindcelma_app/model/entities/User.dart';
import 'package:sindcelma_app/pages/app/ccts/CCTSelected.dart';

import '../../../model/Request.dart';


class CCTHomeLink extends StatefulWidget {

  final Function onErrorResponse;

  const CCTHomeLink({required this.onErrorResponse, Key? key}) : super(key: key);

  @override
  State<CCTHomeLink> createState() => _CCTHomeLinkState();
}

class _CCTHomeLinkState extends State<CCTHomeLink> {

  String title = "";
  int id = 0;
  bool loaded  = false;

  void _loaded(){

    setState(() {
      loaded = true;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLastCCT();
  }

  void getLastCCT() async {

    var request = Request();
    await request.post('/cct/get_last_cct', {});
    if(request.code() != 200){
      widget.onErrorResponse("Ocorreu um erro ao tentar carregar a CCT");
      return;
    }

    if(request.response()['message'].isEmpty) return;

    var response = request.response()['message'][0];
    title = response['titulo'];
    id = response['id'];
    _loaded();

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(User().status == 1){
          widget.onErrorResponse("Apenas Sócios podem acessar a CCT");
          return;
        }
        if(loaded){
          // abre a cct
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CCTSelected(title: title, id: id)
              )
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    color:Colors.red,
                    border: Border.all(
                      color: Colors.red,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(80))
                ),
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Icon(
                    Icons.book_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                )
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Oswald',
                    color: Colors.red
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
