import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/Btn.dart';
import 'package:sindcelma_app/model/entities/Sorteio.dart';
import 'package:sindcelma_app/pages/app/sorteios/SorteioFull.dart';
import 'package:sindcelma_app/themes.dart';

import '../../../model/Request.dart';

class SorteioWidget extends StatefulWidget {

  final Sorteio sorteio;
  bool isFull;

  SorteioWidget(this.sorteio, { this.isFull = false, Key? key}) : super(key: key);

  @override
  State<SorteioWidget> createState() => _SorteioWidgetState();
}

class _SorteioWidgetState extends State<SorteioWidget> {

  int dias = 0;
  int horas = 0;
  int minutos = 0;
  int segundos = 0;

  String strdias = "";
  String strhoras = "";
  String strminutos = "";
  String strsegundos = "";
  String errorMessage = "";

  bool podeInscrever = false;
  bool isLoading = false;

  void refresh(){
    setState(() {});
  }

  void inscreverse() async {
    setState(() {
      isLoading = true;
    });
    var request = Request();
    await request.post('/sorteios/inscricao', {
      "sorteio_id": widget.sorteio.id()
    });
    if(request.code() == 200){
      widget.sorteio.inscrito = true;
      errorMessage = "";
    } else {
      errorMessage = request.response()['message'];
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget btnAtual = Container();

  Widget infoFinalizado = Padding(
    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
    child: Text("INSCRIÇÕES FINALIZADAS",
      style: TextStyle(
          fontFamily: 'Oswald',
          fontSize: 25,
          color: Colors.red.shade900
      ),
    ),
  );

  Widget sorteioFinalizado = Padding(
    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
    child: Text("SORTEIO FINALIZADO",
      style: TextStyle(
          fontFamily: 'Oswald',
          fontSize: 25,
          color: Colors.red.shade900
      ),
    ),
  );

  Widget btnInscricao = Container(
    color: Colors.green.shade900,
    child: const Padding(
      padding: EdgeInsets.all(10),
      child: Text("INSCREVA-SE!",
        style: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 30,
            color: Colors.lightGreen
        ),
      ),
    ),
  );



  Widget infoInscrito = const Padding(
    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
    child: Text("INSCRITO",
      style: TextStyle(
        fontFamily: 'Oswald',
        fontSize: 30,
        color: Colors.lightGreenAccent
      ),
    ),
  );

  Widget infoVencedor = const Padding(
    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
    child: Text("PARABÉNS! VOCÊ GANHOU!",
      style: TextStyle(
          fontFamily: 'Oswald',
          fontSize: 30,
          color: Colors.limeAccent
      ),
    ),
  );

  Widget btnLoading = Padding(
    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
    child: Container(
      width: 24,
      height: 24,
      padding: const EdgeInsets.all(2.0),
      child: const CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 3,
      ),
    ),
  );

  @override
  void initState() {

    super.initState();
    int seguntosTotal = widget.sorteio.difference().inSeconds;

    if(seguntosTotal > 2){
      podeInscrever = true;
      dias = (seguntosTotal / 86400).floor();
      horas = ((seguntosTotal - (dias * 86400)) / 3600).floor();
      minutos = ((seguntosTotal - (dias * 86400) - (horas * 3600)) / 60 ).floor();
      segundos = (seguntosTotal - dias * 86400 - horas * 3600 - minutos * 60).floor();
    } else {
      showTime();
    }

    decrement();

  }

  void addDay(){
    int day = dias - 1;
    if(day < 0){
      dias = 0;
    } else {
      dias = day;
    }
  }

  void addHour(){
    int hour = horas - 1;
    if(hour < 0){
      if(dias > 0){
        horas = 23;
        addDay();
      } else {
        horas = 0;
      }
    } else {
      horas = hour;
    }
  }

  void addMin(){
    int min = minutos - 1;
    if(min < 0){
      if(horas > 0 || dias > 0){
        minutos = 59;
        addHour();
      } else {
        minutos = 0;
      }
    } else {
      minutos = min;
    }
  }

  void addSec(){
    int sec = segundos - 1;
    if(sec < 0){
      if(horas > 0 || dias > 0 || minutos > 0){
        segundos = 59;
        addMin();
      } else {
        segundos = 0;
      }
    } else {
      segundos = sec;
    }
    if(timerInitiated) {
      showTime();
    }

  }

  void showTime(){
    setState(() {
      strdias = dias < 10 ? "0$dias" : "$dias";
      strhoras = horas < 10 ? "0$horas" : "$horas";
      strminutos = minutos < 10 ? "0$minutos" : "$minutos";
      strsegundos = segundos < 10 ? "0$segundos" : "$segundos";
    });
  }

  bool timerInitiated = true;

  void decrement() async {
    while(timerInitiated){
      await Future.delayed(const Duration(seconds: 1));
      if(dias == 0 && horas == 0 && minutos == 0 && segundos == 0){
        setState(() {
          btnAtual = infoFinalizado;
        });
        break;
      }
      addSec();
    }
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      btnAtual = btnLoading;
    }
    else if(widget.sorteio.vencedor){
      btnAtual = infoVencedor;
    }
    else if(widget.sorteio.inscrito){
      btnAtual = infoInscrito;
    }
    else {
      if(podeInscrever){
        btnAtual = widget.isFull ? GestureDetector(
          onTap: (){
            inscreverse();
          },
          child: Container(
            color: Colors.green.shade900,
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Text("INSCREVA-SE!",
                style: TextStyle(
                    fontFamily: 'Oswald',
                    fontSize: 30,
                    color: Colors.lightGreen
                ),
              ),
            ),
          ),
        ) : btnInscricao;
      } else {
        btnAtual = infoFinalizado;
      }
    }

    return Container(
      color: Colors.green,
      child: Column(
        children: [
          Image.asset('assets/sorteio_logo.png'),
          Text(
            widget.sorteio.titulo(),
            style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Calibri'
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(80))
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Icon(Icons.card_giftcard),
                      subtitle: Text(widget.sorteio.premio(),
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
                      subtitle: Text(widget.sorteio.totalVencedores(),
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
                      subtitle: Text(widget.sorteio.data(),
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

          /// TIMER
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                      children: [
                        Text(strdias,
                          style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Oswald'
                          ),
                        ),
                        const Text("dias",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        )
                      ],
                    )
                ),
                Expanded(
                    child: Column(
                      children: [
                        Text(strhoras,
                          style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Oswald'
                          ),
                        ),
                        const Text("horas",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        )
                      ],
                    )
                ),
                Expanded(
                    child: Column(
                      children: [
                        Text(strminutos,
                          style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Oswald'
                          ),
                        ),
                        const Text("minutos",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        )
                      ],
                    )
                ),
                Expanded(
                    child: Column(
                      children: [
                        Text(strsegundos,
                          style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Oswald'
                          ),
                        ),
                        const Text("segundos",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        )
                      ],
                    )
                ),
              ],
            ),
          ),

          !widget.isFull
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => SorteioFull(sorteio: widget.sorteio,)
                          )
                      );
                    },
                    child: btnAtual,
                  ),
                )
              : btnAtual,
          errorMessage != "" ? Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              color: Colors.red[900],
              child: Padding(padding: const EdgeInsets.all(10),
                child: Text(errorMessage, style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white
                ),),
              ),
            ),
          ) : Container()
        ],
      ),
    );
  }

  @override
  void dispose() {
    timerInitiated = false;
    super.dispose();
  }

}
