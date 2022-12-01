import 'package:flutter/material.dart';

class LoadingComponent extends StatelessWidget {

  final bool error;
  final String message;

  const LoadingComponent(this.message, this.error, {Key? key}) : super(key: key);

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
        !error ? Align(
          alignment: Alignment.center,
          child: Text(message,
            style: const TextStyle(
                fontSize: 20
            ),
          ),
        ) :  Padding(padding: EdgeInsets.all(20), child: Align(
          alignment: Alignment.center,
          child: Text(message,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.red,
            ),
          ),
        ),),
      ],
    );
  }
}
