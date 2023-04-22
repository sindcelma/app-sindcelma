import 'package:flutter/material.dart';


abstract class DinamicInput {

  void setRules(RegExp rules, String message);
  void setFunctionError(Function functionError);
  void setValue(String val);
  void showError(bool val, String messageErrorProg);

}

class Input extends StatefulWidget implements DinamicInput {

  final String label;
  final Function onChanged;
  String value;
  RegExp rules = RegExp(r'.*');
  String messageErrorRules = "";
  String messageErrorProg = "";
  bool statusSuccess = false;
  bool created = true;
  bool hideContent;
  Function? functionError;
  _InputState inputState = _InputState();

  Input({Key? key, required this.label, required this.value, required this.onChanged, this.hideContent = false, this.functionError}) : super(key: key);

  @override
  State<Input> createState(){
    return inputState;
  }

  @override
  setRules(RegExp rules, String messageErrorRules){
    this.rules = rules;
    this.messageErrorRules = messageErrorRules;
  }

  @override
  setValue(String val){
    inputState._text = val;
  }

  @override
  void showError(bool val, String messageErrorProg) {
    this.messageErrorProg = messageErrorProg;
    statusSuccess = val;
    inputState.changeState();
  }

  @override
  void setFunctionError(Function functionError) {
    this.functionError = functionError;
  }

}


class _InputState extends State<Input> {

  final TextEditingController controller = TextEditingController();
  Color atualColor = Colors.black54;
  var _text = "";
  bool started = false;
  bool other_error = false;

  void changeState(){
    setState(() {
      _text = "";
    });
  }

  String? get _error {

    if(!started) return null;

    if (controller.value.text.isEmpty) {
      return 'Não pode ser vazio';
    }

    if(widget.functionError != null && !widget.functionError!()){
      return widget.messageErrorRules;
    }

    if(!widget.statusSuccess){
      return (widget.messageErrorProg != "" ? widget.messageErrorProg : widget.messageErrorRules);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.created){
      controller.text = widget.value;
    }

    return TextField(
      obscureText: widget.hideContent,
      onChanged: (str){
        widget.created = false;
        started = true;
        widget.statusSuccess = widget.rules.hasMatch(str.trim());
        widget.onChanged(str, widget.statusSuccess);
        setState(() {
          _text = str;
        });
      },
      controller: controller,
      style: const TextStyle(
          fontSize: 18,
          fontFamily: 'Calibri'
      ),
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
             borderSide: BorderSide(color: Colors.black54),
          ),
          border: const OutlineInputBorder(),
          labelText: widget.label,
          labelStyle: const TextStyle(color: Colors.black54),
          errorText: _error,
          hintStyle: const TextStyle(
              color: Colors.black54
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal)
          )
      ),
    );

  }

}


