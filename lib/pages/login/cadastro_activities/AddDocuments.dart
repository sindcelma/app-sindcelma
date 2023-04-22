import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/AddDocumentsComponent.dart';
import 'package:sindcelma_app/pages/login/cadastro_activities/CadastroActivity.dart';

class AddDocuments extends StatefulWidget implements Activity {

  static bool status = false;

  const AddDocuments({Key? key}) : super(key: key);

  @override
  Future<ResponseActivity> checkStatusActivity() async {
    var resp = !AddDocuments.status ? 'Envie as fotos solicitadas' : '';
    return ResponseActivity(status: AddDocuments.status, response: resp);
  }

  @override
  State<AddDocuments> createState() => _AddDocumentsState();
}

class _AddDocumentsState extends State<AddDocuments> {
  @override
  Widget build(BuildContext context) {
    return !AddDocuments.status ? AddDocumentsComponent(onResponse: (status){
      setState(() {
        AddDocuments.status = status;
      });
    }, activity: false) : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:CrossAxisAlignment.center,
        children: const [
          Text("FOTOS ENVIADAS COM SUCESSO!",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Oswald',
                fontSize: 25
            ),
          ),
          Icon(Icons.check_circle,
            color: Colors.green,
          )
        ]
    );
  }
}


