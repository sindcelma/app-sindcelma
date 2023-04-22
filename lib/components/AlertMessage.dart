import 'package:flutter/material.dart';

class AlertMessage {

  String type;
  String message;

  AlertMessage({required this.type, required this.message});

  SnackBar alert(){
    return SnackBar(content: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: type == 'error' ? Colors.red : Colors.green,
          borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      child: Text(message,
        style: const TextStyle(
            fontSize: 20,
            color: Colors.white
        ),
      ),
    ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

}

