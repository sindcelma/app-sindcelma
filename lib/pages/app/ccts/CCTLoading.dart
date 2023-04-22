import 'package:flutter/material.dart';

class CCTLoading extends StatelessWidget {
  const CCTLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/loading.gif')
      ],
    );
  }
}
