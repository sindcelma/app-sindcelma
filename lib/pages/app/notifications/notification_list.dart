import 'package:flutter/material.dart';

class NotificationList extends StatefulWidget {

  NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {

    return ListView(
      children: [
        Container(
          child: Row(
            children: [
              Text('item1'),
              TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/notifications', arguments: {'selected':1}),
                  child: Icon(Icons.add)
              )
            ],
          ),
        )
      ],
    );

    /*
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('$i'),
          onTap: () {}, // Handle your onTap here.
        );
      });
      */

  }
}
