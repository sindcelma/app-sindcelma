import 'package:flutter/material.dart';

abstract class DateInputInterface {
  List<String> getValues();
}

class DateInput extends StatefulWidget implements DateInputInterface {

  final Function onChanged;
  String value;
  String label;
  bool created = true;

  String dataBr = "";
  String dataEn = "";

  DateInput({Key? key, required this.label, required this.value, required this.onChanged}) : super(key: key);

  @override
  State<DateInput> createState() => _DateInputState();

  @override
  List<String> getValues() {
    return [ dataBr, dataEn ];
  }

}

class _DateInputState extends State<DateInput> {

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    if(widget.created) {
      controller.text = widget.value;
    }

    return TextField(
      controller: controller,
      style: const TextStyle(
          fontSize: 18,
          fontFamily: 'Calibri'
      ),
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          border: const OutlineInputBorder(),
          labelText: widget.label,
          labelStyle: const TextStyle(color: Colors.green),
          hintStyle: TextStyle(
              color: Colors.green[900]
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green)
          )
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime(2100));

        if (pickedDate == null){
          return;
        }

        var parts = pickedDate.toString().split(' ');
        var toBr = parts[0].split('-');
        widget.dataEn = parts[0];
        widget.value = "${toBr[2]}/${toBr[1]}/${toBr[0]}";
        controller.text = widget.value;
        widget.created = false;
        widget.onChanged(widget.value, widget.dataEn);

      },
    );
  }
}

