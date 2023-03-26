import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/Btn.dart';
import 'package:sindcelma_app/model/entities/User.dart';
import 'package:sindcelma_app/model/services/NoticiasService.dart';
import 'package:sindcelma_app/pages/app/SejaSocio.dart';
import 'package:sindcelma_app/pages/app/ccts/CCTHomeLink.dart';
import 'package:sindcelma_app/pages/app/noticias/NoticiaHome.dart';
import 'package:sindcelma_app/pages/app/sorteios/SorteioWidget.dart';
import 'package:sindcelma_app/themes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/AlertMessage.dart';
import '../../model/Config.dart';
import '../../model/Request.dart';
import '../../model/entities/Noticia.dart';
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

  Noticia? noticiaHome;

  @override
  void initState() {
    super.initState();
    carregarComunicado();
    carregarSorteio();
    carregarNotification();
    carregarUltimaNoticia();
  }

  Future carregarComunicado() async {

    var request = Request();
    await request.get('/comunicados/get_last_active');
    if(request.code() == 200){
      var res = request.response()['message'];
      if(res.length == 1){
        showComunicado(res[0]);
      }

    }

  }

  void showComunicado(comunicado){
    showModalBottomSheet(context: context,
        isScrollControlled: true,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: BtnIcon(TypeColor.primary, "fechar", const Icon(Icons.close, color: Colors.redAccent,), () { Navigator.pop(context); }),
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  comunicado['titulo'],
                  style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Oswald'
                  ),
                ),
            ),
            Image.network(comunicado['image']),
            Text(
                comunicado['texto'],
                style: const TextStyle(
                  fontFamily: 'Calibri',
                  fontSize: 16
                ),
            )
          ],
        )
      );
  }

  void showAlert(String message, {bool error = true}){
    ScaffoldMessenger.of(context).showSnackBar(
        AlertMessage(type: error ? 'error' : 'success', message: message)
            .alert()
    );
  }

  void carregarUltimaNoticia() async {

    var resp = await NoticiasService.last();

    noticiaHome = Noticia(
        id: resp[0]['id'],
        titulo: resp[0]['titulo'],
        subtitulo: resp[0]['subtitulo'],
        imagem: resp[0]['imagem'],
        data: resp[0]['data_created']
    );

    setState(() {});
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
  
  void acess(String uri) async {
    final Uri url = Uri.parse(uri);
    try {
      await launchUrl(url,mode: LaunchMode.externalApplication);
    } catch (e) {
      print("silencio... tem um erro acontecendo");
    }
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
                                  Config.getUrlAssetString("/images/fav/${User().email}.jpg"),
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
            onTap: () => Navigator.pushNamed(context, '/noticias'),
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
          ListTile(
            leading: const Icon(Icons.beach_access, size: 30,),
            title: const Text('Convênios'),
            selected: false,
            onTap: () => Navigator.pushNamed(context, '/convenios'),
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          const Padding(padding: EdgeInsets.all(10),
            child: Center(
              child: Text("Acesse:", style: TextStyle(
                fontFamily: 'Calibri',
                fontWeight: FontWeight.bold,
              ),),
            ),
          ),
          TextButton(
              onPressed: () => acess("https://www.sindcelma.com.br/"),
              child: const Text("sindcelma.com.br", style: TextStyle(
                color: Colors.red,
                fontFamily: 'Calibri',
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.facebookSquare,
                      size: 40,
                      color: Colors.blue,
                    ),
                    onPressed: () async {
                      acess("https://www.facebook.com/sindcelmacelulosepapel");
                    }
                ),
              ),
              Center(
                child: IconButton(
                  icon: const FaIcon(FontAwesomeIcons.instagramSquare,
                    size: 40,
                    color: Colors.redAccent,
                  ),
                  onPressed: () async {
                    acess("https://www.instagram.com/sindcelmacelulosepapel/");
                  }
                ),
              )
            ],
          )
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
          User().status > 1 ? TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/carteirinha'),
              icon: const Icon(
                Icons.badge_outlined,
                color: Colors.black54,
                size: 30,
              ),
              label: const Text("")
          ) : Container(),
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

    /// add noticias
    final noticiaHome = this.noticiaHome;
    if(noticiaHome != null) {
      lista.add(NoticiaHome(
          img: noticiaHome.imagem,
          titulo: noticiaHome.titulo,
          subtitulo: noticiaHome.subtitulo,
          id: noticiaHome.id,
          data: noticiaHome.data,
        )
      );
    }

    if (sorteio.status()) {
      lista.add(SorteioWidget(sorteio));
    }

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


