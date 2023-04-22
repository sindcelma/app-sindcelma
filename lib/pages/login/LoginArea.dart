import 'package:flutter/material.dart';
import 'package:sindcelma_app/pages/login/login/ForgotPage.dart';
import 'package:sindcelma_app/pages/login/login/LoginPage.dart';

class LoginArea extends StatefulWidget {

  Function response;

  LoginArea(this.response, {Key? key}) : super(key: key);

  @override
  State<LoginArea> createState() => _LoginAreaState();
}

class _LoginAreaState extends State<LoginArea> {

  List<Widget> pages = [];
  Widget? page;

  @override
  void initState() {
    super.initState();

    pages = [
      LoginPage((int goto, {bool status = true}){
        if(goto == 0){
          widget.response(status, loading: true);
        } else {
          setState(() {
            page = pages[goto];
          });
        }
      }),
      ForgotPage((){
        setState(() {
          page = pages[0];
        });
      })
    ];

    page = pages[0];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          Align(
            alignment: AlignmentDirectional.topCenter,
            child: SizedBox(
              height: 100,
              child: Image.asset('assets/logo_horizontal.png',
                height: 200,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
            child: page,
          ),
        ],
      ),
    );
  }
}
