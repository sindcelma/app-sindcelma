import 'package:flutter/material.dart';

class ConvenioItemList extends StatelessWidget {

  final int id;
  final String titulo;
  final String imagem;
  final String texto;

  const ConvenioItemList({Key? key, required this.id, required this.titulo, required this.imagem, required this.texto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 25,
                    fontFamily: 'Oswald'
                ),
              ),
            ),
            Row(
              children: [
                Expanded(child: Image.network(imagem))
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  texto,
                  style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Calibri'
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }
}
