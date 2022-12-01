import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/Btn.dart';
import 'package:sindcelma_app/model/entities/User.dart';
import 'package:sindcelma_app/pages/app/SejaSocio.dart';
import 'package:sindcelma_app/pages/app/ccts/CCTHomeLink.dart';
import 'package:sindcelma_app/pages/app/sorteios/SorteioWidget.dart';
import 'package:sindcelma_app/themes.dart';

import '../../components/AlertMessage.dart';
import '../../model/Config.dart';
import '../../model/Request.dart';
import '../../model/entities/Sorteio.dart';

class Home extends StatefulWidget {

  final Function closeApp;

  const Home(this.closeApp, {Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Sorteio sorteio = Sorteio();

  var iconNotification = Icons.notifications_outlined;
  Color colorIcon = Colors.black54;
  Widget textNotification = const Text("");

  @override
  void initState() {
    super.initState();
    carregarSorteio();
    carregarNotification();
  }

  void showAlert(String message, {bool error = true}){
    ScaffoldMessenger.of(context).showSnackBar(
        AlertMessage(type: error ? 'error' : 'success', message: message)
            .alert()
    );
  }

  void carregarSorteio() async {

    var request = Request();
    if(User().socio.status > 2){
      await request.post('/sorteios/last_by_user', {});
    } else {
      await request.post('/sorteios/last', {});
    }

    if(request.code() != 200){
      return;
    }
    var response = request.response()['message'];

    if(response.length == 0){
      return;
    }

    sorteio.setTitulo(response['titulo']);
    sorteio.setPremio(response['premios']);
    sorteio.setTotalVencedores(response['qt_vencedores']);
    sorteio.setDataSorteio(response['data']);
    sorteio.setId(response['id']);

    if(User().socio.status > 2) {
      sorteio.inscrito = response['inscrito'];
      sorteio.vencedor = response['vencedor'];
    }

    setState(() {
      sorteio.setSorteioStatus(true);
    });
  }

  void carregarNotification() async {
    setNotification("2");
  }

  Drawer drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: const Icon(Icons.menu_open),
            title: const Text('MENU'),
            selected: true,
            onTap: () => {},
            selectedColor: Colors.red,
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                    child: CircleAvatar(
                        radius: 60.0,
                        backgroundColor: SindcelmaTheme.color_primary,
                        child: ClipOval(
                          child:
                              User().status < 2
                              ? Image.asset('assets/user_icon.png', color: Colors.white,)
                              : Image.network(
                                  Config.getUrl("/images/fav/${User().email}.jpg"),
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                        )
                    ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text(User().nome),
                    Text(User().email,
                      style: const TextStyle(
                          fontSize: 12
                      ),
                    ),
                    User().status > 1 ? Btn(
                          TypeButton.text,
                          TypeColor.primary,
                          "EDITAR", () {
                            Navigator.pushNamed(context, '/user');
                          }
                      )
                    : Container()
                  ],
                ),
              )
            ],
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.feed_outlined, size: 30,),
            title: const Text('Noticias'),
            selected: false,
            onTap: () => {},
          ),
          ListTile(
            leading: const Icon(Icons.book_outlined, size: 30,),
            title: const Text('Convenção Coletiva'),
            selected: false,
            onTap: () => Navigator.pushNamed(context, '/ccts'),
          ),
          ListTile(
            leading: const Icon(Icons.redeem_outlined, size: 30,),
            title: const Text('Sorteios'),
            selected: false,
            onTap: () => Navigator.pushNamed(context, '/sorteios'),
          ),

        ],
      )
    );
  }

  void setNotification(String quant) {
    iconNotification = Icons.notifications_active_outlined;
    colorIcon = Colors.red;
    textNotification = Container(
      decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(
            color: Colors.red,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(80))
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Text(
            quant,
            style: const TextStyle(
                color: Colors.white
            )
        ),
      ),
    );
  }

  void removeNotification() {
    textNotification = const Text("");
    colorIcon = Colors.black54;
    iconNotification = Icons.notifications_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(),
      appBar: AppBar(
        actions: [
          TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/carteirinha'),
              icon: const Icon(
                Icons.badge_outlined,
                color: Colors.black54,
                size: 30,
              ),
              label: const Text("")
          ),
          /*
          TextButton.icon(
              onPressed: () {
                setState(() {
                  // removeNotification();
                  // Request().post('/user/unauthorized', {});
                });
              },
              icon: Icon(
                iconNotification,
                color: colorIcon,
                size: 30,
              ),
              label: textNotification
          )
          */
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.red,
                size: 30,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations
                  .of(context)
                  .openAppDrawerTooltip,
            );
          },
        ),
        backgroundColor: Colors.white,
        title: Image.asset('assets/logo_horizontal.png'),
      ),
      body: ListView(
        children: loadingHome(),
      ),
    );
  }

  List<Widget> loadingHome() {
    List<Widget> lista = [];
    if (sorteio.status()) {
      lista.add(SorteioWidget(sorteio));
    }
    /// add comunicado
    /// add noticias

    lista.add(
      CCTHomeLink(
        onErrorResponse: (message){
          showAlert(message);
        }
      )
    );

    if(User().status == 1){
      lista.add(SejaSocio(() => widget.closeApp()));
    }
    return lista;
  }

}


