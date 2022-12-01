import 'package:flutter/material.dart';
import 'package:sindcelma_app/pages/app/carteirinha/QRCodeLink.dart';
import '../../../model/Config.dart';
import '../../../model/entities/User.dart';
import '../../../themes.dart';

class CarteirinhaSocio extends StatefulWidget {
  const CarteirinhaSocio({Key? key}) : super(key: key);

  @override
  State<CarteirinhaSocio> createState() => _CarteirinhaSocioState();
}

class _CarteirinhaSocioState extends State<CarteirinhaSocio> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade100,
              Colors.green.shade100,
              Colors.greenAccent.shade400
            ],
          )
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
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
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 10),
                child: Image.asset('assets/logo_horizontal.png',
                  scale: 1.2,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: CircleAvatar(
                    radius: 65.0,
                    backgroundColor: SindcelmaTheme.color_primary,
                    child: ClipOval(
                      child: Image.network(
                          Config.getUrl("/images/fav/${User().email}.jpg"),
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover
                      ),
                    )
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Text("${User().nome} ${User().sobrenome}",
                      style: const TextStyle(
                          fontSize: 30,
                          fontFamily: 'Oswald'
                      )
                  ),
                  Text(User().email),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 0, left: 30, right: 30),
                    child: Text(User().socio.getSlug()),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(20),
              child: Divider(indent: 20, endIndent: 20, color: Colors.black,),
            ),
            const QRCodeLink()
          ],
        ),
      ),
    );
  }
}
