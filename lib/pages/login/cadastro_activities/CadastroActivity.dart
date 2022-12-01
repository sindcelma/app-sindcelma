import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/AlertMessage.dart';
import 'package:sindcelma_app/components/Btn.dart';
import 'package:sindcelma_app/model/services/SocioManagerService.dart';
import 'package:sindcelma_app/model/services/UserManagerService.dart';
import 'package:sindcelma_app/pages/login/cadastro_activities/CadastrarDados.dart';
import 'package:sindcelma_app/pages/login/cadastro_activities/CadastrarEmpresa.dart';
import 'package:sindcelma_app/pages/login/cadastro_activities/CadastrarNome.dart';
import 'package:sindcelma_app/model/entities/User.dart';
import 'package:sindcelma_app/themes.dart';

class ResponseActivity {

  bool status;
  String response;

  ResponseActivity({required this.status, required this.response});

}

abstract class Activity {
  Future<ResponseActivity> checkStatusActivity();
}


class CadastroActivity extends StatefulWidget {

  User user;

  Function response;

  CadastroActivity(this.response, this.user, {Key? key}) : super(key: key);

  @override
  State<CadastroActivity> createState() => _CadastroActivityState();
}

class _CadastroActivityState extends State<CadastroActivity> {

  int  _step = 0;
  Activity part = CadastrarNome();
  Widget p = Container();
  Widget btnNext = Container();
  Widget floattingButton = Container();
  Widget loadingBtn = Container(
    child: Image.asset('assets/loading.gif',
      width: 50,
    ),
  );

  List<Activity> parts = [];


  @override
  void initState(){
    super.initState();
    parts = [
      CadastrarNome(),
      CadastrarEmpresa(),
      CadastrarDados()
    ];

    p = parts[_step] as Widget;

    floattingButton = OutlinedButton(
      onPressed: nextStep,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(color: Colors.green),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("PRÓXIMO", style: TextStyle(
              fontSize: 18,
              color: Colors.green[900]
          ),),
          Icon(Icons.arrow_forward, color: Colors.green[900],)
        ],
      ),
    );
    btnNext = floattingButton;
  }

  Future<void> finalizar() async {

    var response = await SocioManagerService().saveSocio();

    if(!response.getStatus()) {
      showAlert('error', response.getResponse());
      return;
    }

    await UserManagerService().saveUser();
    widget.response();

  }

  void loading(bool status){
    setState(() {
      btnNext = status ? loadingBtn : floattingButton;
    });
  }

  void addStep(){
    setState(() {
      _step++;
      part = parts[_step];
      p = part as Widget;
    });
  }

  void showAlert(String type, String message){
    ScaffoldMessenger.of(context).showSnackBar(
        AlertMessage(type: type, message: message)
            .alert()
    );
  }

  void nextStep() async {
    loading(true);
    ResponseActivity res = await part.checkStatusActivity();
    if(_step == parts.length-1){
      await finalizar();
    } else {
      if(!res.status){
        showAlert('error', res.response);
      }
      else {
        addStep();
      }
    }
    loading(false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: btnNext,
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          Align(
            alignment: AlignmentDirectional.topStart,
            child: Container(
              child: BtnIcon(TypeColor.text, "Voltar", const Icon(Icons.arrow_back), () {
                setState(() {
                  if(_step == 0){
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      _step--;
                      part = parts[_step];
                      p = part as Widget;
                    });
                  }
                });
              }),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.topCenter,
            child: Container(
              height: 100,
              child: Image.asset('assets/logo_horizontal.png',
                height: 200,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
            child: p,
          ),
        ],
      ),
    );
  }
}
