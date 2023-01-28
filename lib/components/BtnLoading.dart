import 'package:flutter/material.dart';

class BtnLoading extends StatelessWidget {
  const BtnLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Container(
        width: 24,
        height: 24,
        padding: const EdgeInsets.all(2.0),
        child: const CircularProgressIndicator(
          color: Colors.redAccent,
          strokeWidth: 3,
        ),
      ),
    );
  }
}
