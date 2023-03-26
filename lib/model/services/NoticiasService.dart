import 'package:sindcelma_app/model/Config.dart';
import 'package:sindcelma_app/model/Request.dart';
import 'package:sindcelma_app/model/services/InfoService.dart';

class NoticiasService {

  static final bool wp_noticias = InfoService.getWpNoticiasStatus();
  static final String _url = !wp_noticias ?
    Config.getUrlAPIString("") :
    "https://www.papeleirosdemogi.com.br" ;
    //"https://www.sindcelma.com.br/" ;

  static _response(String url) async {

    var req = Request();
    await req.get(url, full: true);
    if(req.code() != 200) return false;

    if(wp_noticias){
      var message = req.response()['message'];
      var list = [];
      if(message is List){
        for(int i = 0; i < message.length; i++){
          list.add({
            "id":message[i]['id'],
            "titulo":message[i]['title'],
            "subtitulo":message[i]['excerpt'],
            "text":message[i]['content'],
            "data_created":"",
            "imagem":message[i]['image']
          });
        }
      } else {
        list.add({
          "id":message['id'],
          "titulo":message['title'],
          "subtitulo":message['excerpt'],
          "text":message['content']['rendered'],
          "data_created":message['date'],
          "imagem":message['image']
        });
      }
      return list;
    } else {
      return req.response()['message']['message'];
    }

  }

  static list({page=1}) async {

    String uri = wp_noticias
        ? "/wp-json/sapi/v0/posts?category_name=noticias&posts_per_page=10&order=DESC&paged=$page"
        : "/noticias/list/$page";
    String url = "$_url$uri";

    return await _response(url);

  }

  static get(int id) async {


    String uri = wp_noticias
        ? "/wp-json/wp/v2/posts/$id"
        : "/noticias/get/$id";
    String url = "$_url$uri";

    return await _response(url);

  }

  static last() async {

    String uri = wp_noticias
        ? "/wp-json/sapi/v0/posts?category_name=noticias&posts_per_page=1&order=DESC&paged=1"
        : "/noticias/last";
    String url = "$_url$uri";

    return await _response(url);
  }

}