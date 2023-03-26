import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/AddDocumentsComponent.dart';


class AddDocumentsActivity extends StatefulWidget {

  final Function(bool status) onResponse;

  const AddDocumentsActivity(this.onResponse, {Key? key}) : super(key: key);

  @override
  State<AddDocumentsActivity> createState() => _AddDocumentsActivityState();
}

class _AddDocumentsActivityState extends State<AddDocumentsActivity> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AddDocumentsComponent(onResponse: widget.onResponse),
    );
  }
}
