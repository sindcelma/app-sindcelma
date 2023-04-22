import 'package:flutter/material.dart';

class SelectInput extends StatefulWidget {

  List<String> list;
  Function onChange;
  Function isError;
  String label;
  String? valueinit;

  SelectInput({ this.valueinit, required this.label, required this.list, required this.onChange, required this.isError, Key? key}) : super(key: key);

  @override
  State<SelectInput> createState() => _SelectInputState();
}

class _SelectInputState extends State<SelectInput> {

  String dropdownValue = "";
  bool init = true;
  bool error = true;
  String message = "";

  Widget successW = Container(
    height: 1,
    color: Colors.green,
  );

  Widget errorW = Container(
    height: 3,
    color: Colors.red,
  );

  @override
  Widget build(BuildContext context) {

    if(init) {
      message = "O campo '${widget.label}' não pode ficar vazio";
      if(widget.valueinit == null || widget.valueinit == ""){
        dropdownValue = widget.list.first;
      } else {
        error = false;
        dropdownValue = widget.valueinit!;
      }
      init = false;
    }

    return Column(children: [
      DropdownButton<String>(
      value: dropdownValue,
      hint: Text(widget.label),
      icon: const Icon(Icons.arrow_downward),
      style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontFamily: 'Calibri'
      ),
      underline: (error ? errorW : successW),
      onChanged: (String? value) {
        String val = value ?? "";
        setState(() {
          error = widget.isError(val);
          dropdownValue = value!;
        });
        widget.onChange(val);
      },
      items: widget.list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ),
      Text(error ? message : "", style: const TextStyle(color: Colors.red),)
    ],);
  }
}
