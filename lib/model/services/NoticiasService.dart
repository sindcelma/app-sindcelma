import 'package:sindcelma_app/model/Config.dart';
import 'package:sindcelma_app/model/Request.dart';
import 'package:sindcelma_app/model/services/InfoService.dart';

class NoticiasService {

  static final bool wp_noticias = InfoService.getWpNoticiasStatus();
  static final String wp_categories = InfoService.getWpCategories();
  static final String _url = !wp_noticias ?
    Config.getUrlAPIString("") :
    //"https://www.papeleirosdemogi.com.br" ;
    "https://www.sindcelma.com.br/" ;

  static _response(String url) async {

    var req = Request();
    await req.get(url, full: true);
    if(req.code() != 200) {
      return;
    }

    if(wp_noticias){
      var message = req.response()['message'];
      var list = [];
      if(message is! List){
        message = [message];
      }
      for(int i = 0; i < message.length; i++) {
        var img = "";
        try {
          img =
          message[i]['_embedded']['wp\:featuredmedia'][0]['media_details']['file'];
        } catch (e) {
          img = "";
        }
        list.add({
          "id": message[i]['id'],
          "titulo": message[i]['title']['rendered'],
          "subtitulo":"",
          "text": message[i]['content']['rendered'],
          "data_created": "",
          "imagem": _url + '/wp-content/uploads/' + img
        });
      }
      return list;
    } else {
      return req.response()['message']['message'];
    }

  }

  static list({page=1}) async {

    String uri = wp_noticias
        ? "/wp-json/wp/v2/posts?_embed&categories="+wp_categories+"&per_page=10&order=desc&page=$page"
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
        ? "/wp-json/wp/v2/posts?_embed&categories="+wp_categories+"&per_page=1&order=desc&page=1"
        : "/noticias/last";
    String url = "$_url$uri";

    return await _response(url);

  }

}