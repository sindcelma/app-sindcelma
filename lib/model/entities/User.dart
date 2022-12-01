import 'package:sindcelma_app/model/entities/Socio.dart';

class User {

  bool atualizado  = true;

  String nome      = "";
  String sobrenome = "";
  String email     = "";
  String telefone  = "";
  String senha     = "";
  String confirm   = "";
  String tempKey   = "";

  int status = 0;

  Socio socio = Socio();

  static final User _user = User._internal();

  factory User(){
    return _user;
  }

  User._internal();

  void setSocio(Socio socio) => this.socio = socio;
  void setNome(String nome) => this.nome = nome;
  void setSobrenome(String sobrenome) => this.sobrenome = sobrenome;

  static bool isValidCPF(String str) {
    bool res = RegExp(r'\d{2,3}\.?\d{3}\.?\d{3}-?\d{2}').hasMatch(str);
    return res;
  }

  void setDataMap(Map dados){
    nome      = dados['nome'];
    sobrenome = dados['sobrenome'];
    email     = dados['email'];
    telefone  = dados['telefone'];
  }

  void setSocioMapDB(Map dados){
    socio.setCargo(dados['cargo']);
    socio.setDataAdmissao(dados['data_admissao']);
    socio.setDataEn(dados['data_en']);
    socio.setDataAdmissao(dados['data_nascimento']);
    socio.setDataEn(dados['data_nascimento_en']);
    socio.setSalt(dados['salt']);
    socio.setToken(dados['token']);
    socio.setAproved(dados['aproved']);
    socio.setGenero(dados['genero']);
    socio.setEstadoCivil(dados['estado_civil']);
    socio.setEmpresa(dados['empresa']);
    socio.setSlug(dados['slug']);
  }

  void setSocioMap(Map dados){
    socio.setCargo(dados['cargo']);
    socio.setDataAdmissao(dados['data_admissao']);
    socio.setDataEn(dados['data_en']);
    socio.setDataAdmissao(dados['data_nascimento']);
    socio.setDataEn(dados['data_nascimento_en']);
    socio.setSalt(dados['salt']);
    socio.setGenero(dados['sexo']);
    socio.setEstadoCivil(dados['estado_civil']);
    socio.setEmpresa(dados['empresa']);
    socio.setSlug(dados['slug']);
  }

  Map<String, dynamic> toMap() {
    return {
      'nome'     : nome,
      'sobrenome': sobrenome,
      'email'    : email,
      'telefone' : telefone,
      'status'   : status
    };
  }

  void reset(){
    nome       = "";
    sobrenome  = "";
    email      = "";
    telefone   = "";
    senha      = "";
    confirm    = "";
    atualizado = true;
    status     = 0;
    socio      = Socio();
  }

}