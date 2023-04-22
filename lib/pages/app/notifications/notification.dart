import 'package:flutter/material.dart';
import 'package:sindcelma_app/pages/app/notifications/notification_list.dart';
import 'package:sindcelma_app/pages/app/notifications/notification_selected.dart';

class Notifications extends StatefulWidget {

  Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationState();
}

class _NotificationState extends State<Notifications> {



  @override
  Widget build(BuildContext context) {

    var routes = ModalRoute.of(context)?.settings.arguments;
    Map<String, dynamic> r = {};
    if(routes != null){
      r = routes as Map<String,dynamic>;
    }
    if(r['selected'] != null){
      return NotificationSelected(r['selected']);
    } else {
      return NotificationList();
    }
  }
}
