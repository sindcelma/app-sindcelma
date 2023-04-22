import 'package:flutter/material.dart';

class NotificationSelected extends StatelessWidget {

  final int id;

  const NotificationSelected(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Selected $id"),);
  }
}
