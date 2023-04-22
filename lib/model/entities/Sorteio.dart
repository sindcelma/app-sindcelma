class Sorteio {

  int _id = 0;
  bool _sorteioStatus = false;
  bool inscrito = false;
  int _totalVencedores = 0;
  bool vencedor = false;
  String _titulo = "";
  String _premio = "";
  String _sorteio = "";

  String titulo() => _titulo;
  String premio() => _premio;
  bool   status() => _sorteioStatus;
  String   data() => "Sorteio dia: ${_fixData(_sorteio.split(' ')[0])}";
  int        id() => _id;

  void setId(int id){
    _id = id;
  }

  String _fixData(String data){
    var dataarr = data.split('-');
    return "${dataarr[2]}/${dataarr[1]}/${dataarr[0]}";
  }

  Duration difference(){
    // "2018-09-12 10:57:00"
    DateTime dt1 = DateTime.parse(_sorteio);
    DateTime dt2 = DateTime.now();
    return dt1.difference(dt2);
  }

  String totalVencedores(){
    return "$_totalVencedores ${_totalVencedores > 1 ? "vencedores" : "vencedor"}";
  }

  void setSorteioStatus(bool status) {
    _sorteioStatus = status;
  }

  void setTotalVencedores(int vencedores){
    _totalVencedores = vencedores;
  }

  void setTitulo(String titulo){
    _titulo = titulo;
  }

  void setPremio(String premio){
    _premio = premio;
  }

  void setDataSorteio(String data){
    _sorteio = data;
  }

}