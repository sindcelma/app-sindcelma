import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/Firewall.dart';
import 'package:sindcelma_app/model/entities/User.dart';
import 'package:sindcelma_app/pages/app/ccts/CCTItemSelected.dart';

import 'package:sindcelma_app/pages/app/ccts/CCTLoading.dart';

import '../../../model/Request.dart';

class CCTSelected extends StatefulWidget {

  final int id;
  final String title;

  const CCTSelected({required this.title, required this.id, Key? key}) : super(key: key);

  @override
  State<CCTSelected> createState() => _CCTSelectedState();
}

class _CCTSelectedState extends State<CCTSelected> {

  String searchText = "";
  String searchTextAtual = "";
  bool searching = false;
  bool loading = true;
  List<Widget> itens = [];

  Widget generateItem(int id, bool fav, String item, String resumo){
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CCTItemSelected(
                  fav: fav,
                  id: id,
                  title: item,
                  onRefresh: (){
                    getAllList();
                  },
                )
            )
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.red,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10))
          ),
          child: ListTile(
            leading: Icon(fav ? Icons.star : Icons.star_outline,
              color: fav ? Colors.red : Colors.black54,
            ),
            title: Text(item,
              style: const TextStyle(
                fontFamily: 'Oswald',
                fontSize: 20,
              ),
            ),
            subtitle: Text(resumo,
              style: const TextStyle(
                  fontFamily: 'Calibri',
                  fontSize: 16
              ),
            ),
          )
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllList();
  }

  Widget generateList(){
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: itens,
    );
  }

  Widget getWidget(){
    return searching || loading ? const CCTLoading() : generateList();
  }

  void setSearching(bool status){
    setState(() {
      searching = status;
    });
  }

  void setLoading(bool status){
    setState(() {
      loading = status;
    });
  }

  void getSeachedList() async {

    itens = [];

    setLoading(true);

    var request = Request();

    await request.post('/cct/list_itens_by_search', {
      "cct_id":widget.id,
      "search":searchTextAtual
    });
    if(request.code() != 200){
      // precisa mostrar erro
      return;
    }

    var response = request.response()['message'];

    for (var item in response) {
      itens.add(generateItem(item['id'], item['fav'] == 1, item['item'], item['resumo']));
    }

    setLoading(false);
  }

  void getAllList() async {

    itens = [];

    setLoading(true);

    var request = Request();

    await request.post('/cct/itens_by_socio', {
      "cct_id":widget.id,
      "slug":User().socio.getSlug()
    });
    if(request.code() != 200){
      // precisa mostrar erro
      return;
    }

    var response = request.response()['message'];

    for (var item in response) {
      itens.add(generateItem(item['id'], item['fav'] == 1, item['item'], item['resumo']));
    }

    setLoading(false);

  }

  void getDataSearch() async {

    if(searching) return;
    setSearching(true);

    while(searchTextAtual != searchText){

      searchTextAtual = searchText;
      await Future.delayed(const Duration(seconds: 2));

      if(searchText == ""){
        getAllList();
        setSearching(false);
        return;
      }
      // faz a busca
      getSeachedList();
    }

    setSearching(false);

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Firewall(
            onCheckMessage: () => Navigator.pop(context),
            child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // header
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.red,
                          ),
                        ),
                      )
                  ),
                  Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(top:5, left: 20, right: 20),
                        child: TextField(
                          onChanged: (str){
                            searchText = str;
                            getDataSearch();
                          },
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search_rounded,
                                color: Colors.red,
                              ),
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white, width: 32.0),
                                  borderRadius: BorderRadius.circular(25.0)
                              )
                          ),
                        ),
                      )
                  )
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color:Colors.red,
                            border: Border.all(
                              color: Colors.red,
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(80))
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(15),
                          child: Icon(
                            Icons.book_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Oswald',
                            color: Colors.red
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: getWidget(),
                    )
                  ],
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
