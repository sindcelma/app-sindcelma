import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/Btn.dart';

class SejaSocio extends StatelessWidget {

  final Function closeApp;

  const SejaSocio(this.closeApp, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Column(
        children: [
          ElevatedButton(
              onPressed: () => closeApp(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                "CLIQUE AQUI E FIQUE SÓCIO!",
                style: TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 25,
                ),
              )
          ),
          const Padding(padding: EdgeInsets.all(10), child: Text(
            "Ajude o SINDCELMA a ficar cada vez maior!",
            style: TextStyle(
              fontFamily: 'Calibri',
              fontSize: 18,
              color: Colors.white,
            ),
          ),)
        ],
      ),
    );
  }
}
