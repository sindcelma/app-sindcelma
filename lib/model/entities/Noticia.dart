class Noticia {

  final int id;
  final String titulo;
  final String subtitulo;
  final String imagem;
  late final String data;

  String _genData(String data){
    return data;
  }

  Noticia({required this.id, required this.titulo, required this.subtitulo, required this.imagem, required String data}){
    this.data = _genData(data);
  }

}