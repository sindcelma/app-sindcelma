import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/Btn.dart';
import 'package:sindcelma_app/components/CameraFile.dart';
import 'package:sindcelma_app/components/Input.dart';
import 'package:sindcelma_app/components/LoadingComponent.dart';
import 'package:sindcelma_app/model/Request.dart';
import 'package:sindcelma_app/pages/app/user/AlterarEmail.dart';
import 'package:sindcelma_app/pages/app/user/AlterarSenha.dart';
import 'package:sindcelma_app/pages/app/user/CancelarInscricao.dart';
import 'package:sindcelma_app/pages/app/user/InformacoesBasicas.dart';
import 'package:sindcelma_app/pages/app/user/InformacoesPessoais.dart';
import 'package:sindcelma_app/pages/app/user/InformacoesProfissionais.dart';
import 'package:sindcelma_app/pages/login/login/ForgotPage.dart';

import '../../../components/AlertMessage.dart';
import '../../../model/Config.dart';
import '../../../model/entities/User.dart';
import '../../../themes.dart';

class SocioArea extends StatefulWidget {

  const SocioArea({Key? key}) : super(key: key);

  @override
  State<SocioArea> createState() => _SocioAreaState();

}

class _SocioAreaState extends State<SocioArea> {

  String senha = "";
  String message = "Aguarde! Estamos verificando a senha...";
  bool loading = false;
  int count = 0;

  void checkRefresh(status){
    if(status){
      showAlert('Você precisa digitar sua senha novamente.');
      setState(() {
        User().tempKey = "";
        senha = "";
      });
    }
  }

  void setLoading(bool status, String message){
    this.message = message;
    setState(() {
      loading = status;
    });
  }

  void getKey() async {

    setLoading(true, "Aguarde! Estamos verificando a senha...");

    var request = Request();

    await request.post('/user/generate_temp_key', {
      "senha":senha
    });

    if(request.code() == 200){

      User().tempKey = request.response()['message']['key'];
    } else {
      if(request.code() == 402) {
        showAlert("Senha incorreta");
      } else {
        showAlert("Erro no servidor, tente novamente mais tarde");
      }
    }

    setLoading(false, "");
  }

  void showAlert(String message, {bool error = true}){
    ScaffoldMessenger.of(context).showSnackBar(
        AlertMessage(type: error ? 'error' : 'success', message: message)
            .alert()
    );
  }

  void showActivity(Widget wdgt){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => wdgt
        )
    );
  }

  Widget getWidget(){

    if(loading){
      return LoadingComponent(message, false);
    }

    return
      User().tempKey == ""
          ? checkPass()
          : getListOptions();
  }

  Widget checkPass(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: Colors.red,
                  ),
                  Text("voltar",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 18
                    ),
                  )
                ]
            ),
          ),
        ),

        const Padding(padding: EdgeInsets.only(top: 20),
          child: Center(
            child: Text('DIGITE SUA SENHA',
              style: TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 22
              ),
            ),
          ),
        ),
        Padding(padding: const EdgeInsets.all(20),
          child: Input(
            hideContent: true,
            label: "senha",
            value: "",
            onChanged: (str, status){
              senha = str;
            },
          ),
        ),
        Btn(
            TypeButton.elevated,
            TypeColor.primary,
            "ENTRAR",
            () => getKey()),
        Btn(
            TypeButton.text,
            TypeColor.primary,
            "esqueci minha senha",
            () {
              showActivity(
                MaterialApp(
                  home: Scaffold(
                    body: ForgotPage((){

                    }, showLogo: true,),
                  ),
                )
              );
            })
      ],
    );
  }

  Widget getListOptions(){
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: Colors.red,
                  ),
                  Text("voltar",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 18
                    ),
                  )
                ]
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: CircleAvatar(
              radius: 50.0,
              backgroundColor: SindcelmaTheme.color_primary,
              child: ClipOval(
                child: getImage(),
              )
          ),
        ),
        Text(
          "${User().nome} ${User().sobrenome}",
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Calibri'
          ),
        ),
        Text(
          User().email.trim(),
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Calibri'
          ),
        ),
        const Divider(
          height: 50,
          thickness: 1,
          indent: 20,
          endIndent: 20,
          color: Colors.grey,
        ),
        BtnIcon(
            TypeColor.primary,
            "alterar imagem",
            const Icon(Icons.camera_alt_outlined,
              color: Colors.red,
            ), () {
              setLoading(true, "alterando imagem, aguarde!");
              showActivity(
                  CameraFile(
                      onBack: (){
                        setLoading(false, "");
                      },
                      loading: false,
                      onRespose: (status, refresh) {
                        setLoading(false, "");
                        checkRefresh(refresh);
                        setState(() {
                          count++;
                        });
                        if(status) {
                          showAlert('Imagem alterada com sucesso.', error: false);
                        } else {
                          if(!refresh){
                            showAlert('Ocorreu um erro ao tentar alterar a imagem');
                          }
                        }
                      },
                      type: ImageType.fotoArquivo
                  )
              );
            }
        ),
        BtnIcon(
            TypeColor.primary,
            "Informações Básicas",
            const Icon(Icons.person_outline,
              color: Colors.red,
            ),
                () => showActivity(
                InformacoesBasicas(
                    onResponse: (status, refresh){
                      checkRefresh(refresh);
                      if(status){
                        showAlert("Informações alteradas com sucesso!", error: false);
                      } else {
                        if(!refresh){
                          showAlert("Erro ao tentar realizar alterações");
                        }
                      }
                    }
                )
            )
        ),
        BtnIcon(
            TypeColor.primary,
            "Informações Pessoais",
            const Icon(Icons.verified_user_outlined,
              color: Colors.red,
            ),
                () => showActivity(
                InformacoesPessoais(
                    onResponse: (status, refresh){
                      checkRefresh(refresh);
                      if(status){
                        showAlert("Dados Pessoais alterados com sucesso!", error: false);
                      } else {
                        if(!refresh){
                          showAlert("Erro ao tentar realizar alterações");
                        }
                      }
                    }
                )
            )
        ),
        BtnIcon(
            TypeColor.primary,
            "Informações Profissionais",
            const Icon(Icons.energy_savings_leaf_outlined,
              color: Colors.red,
            ),
            () => showActivity(
                InformacoesProfissionais(
                    onResponse: (status, refresh){
                      checkRefresh(refresh);
                      if(status){
                        showAlert("Dados profissionais alterados com sucesso!", error: false);
                      } else {
                        if(!refresh){
                          showAlert("Erro ao tentar realizar alterações");
                        }
                      }
                    }
                )
            )
        ),
        BtnIcon(
            TypeColor.primary,
            "Alterar Email",
            const Icon(Icons.email_outlined,
              color: Colors.red,
            ), () => showActivity(
                AlterarEmail(
                    onResponse: (status, refresh){
                      checkRefresh(refresh);
                      if(status){
                        //showAlert("Senha alterada com sucesso!", error: false);
                      } else {
                        if(!refresh){
                          showAlert("Erro ao tentar realizar alterações");
                        }
                      }
                    }
                )
            )
        ),
        BtnIcon(
            TypeColor.primary,
            "Alterar Senha",
            const Icon(Icons.lock_outline,
              color: Colors.red,
            ),
                () => showActivity(
                AlterarSenha(
                    onResponse: (status, refresh, senha){
                      checkRefresh(refresh);
                      if(status){
                        //showAlert("Senha alterada com sucesso!", error: false);
                      } else {
                        if(!refresh && senha){
                          showAlert("A senha está errada");
                        }
                        if(!refresh && !senha){
                          showAlert("Erro ao tentar salvar a nova senha");
                        }
                      }
                    }
                )
            )
        ),

        BtnIcon(
            TypeColor.primary,
            "Exluir Conta",
            const Icon(
              Icons.logout,
              color: Colors.red,
            ),
                () => showActivity(CancelarInscricao(
                  onResponse: (code){
                    if(code == 403){
                      return checkRefresh(true);
                    }
                    if(code == 402){
                      return showAlert("A senha está errada");
                    }
                  },
                ))
        )
      ],
    );
  }

  Image getImage(){
    return
      User().status < 2
      ? Image.asset('assets/user_icon.png', color: Colors.white,)
      : Image.network(
        Config.getUrlAssetString("/images/fav/${User().email.trim()}.jpg"),
        width: 90,
        height: 90,
        fit: BoxFit.cover
      );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: getWidget()
    );
  }
}
