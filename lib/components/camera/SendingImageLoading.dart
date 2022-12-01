import 'package:flutter/material.dart';

class SendingImageLoading extends StatefulWidget {

  const SendingImageLoading({Key? key}) : super(key: key);

  @override
  State<SendingImageLoading> createState() => _SendingImageLoadingState();
}

class _SendingImageLoadingState extends State<SendingImageLoading> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Align(
            alignment: Alignment.center,
            child: Image.asset('assets/logo_horizontal.png'),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Image.asset('assets/loading.gif'),
        ),
        const Align(
          alignment: Alignment.center,
          child: Text("Salvando imagem...",
            style: const TextStyle(
                fontSize: 20
            ),
          ),
        )
      ],
    );
  }
}
