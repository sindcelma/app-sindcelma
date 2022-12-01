import 'package:flutter/material.dart';

class SouVisitante extends StatefulWidget {

  final Function response;

  const SouVisitante(this.response, {Key? key}) : super(key: key);

  @override
  State<SouVisitante> createState() => _SouVisitanteState();
}

class _SouVisitanteState extends State<SouVisitante> {
  @override
  Widget build(BuildContext context) {
    return Container(child: TextButton(child: Text('entrar'), onPressed: (){
      Navigator.pop(context);
      widget.response('login', true);
    },),);
  }
}
