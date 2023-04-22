
class Socio {

  static const int user_id = 1;

  String imageRoute = "https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png";

  String _session = "";
  String _slug = "";
  String _salt = "";
  String _token = "";
  String _cpf = "";
  String _rg = "";
  String? _cargo;
  String _dataNascimento = "";
  String _dataNascimentoEn = "";
  String _dataAdmissao = "";
  String _dataEn = "";
  String _genero = "";
  String _estadoCivil = "";
  String _empresa = "";

  bool _initiated = false;
  int _aproved = 0;
  int status = 0;

  Map<String, dynamic> toMap(){
    return {
      'slug':_slug,
      'salt': _salt,
      'token': _token,
      'cargo': _cargo,
      'data_nascimento': _dataNascimento,
      'data_nascimento_en': _dataNascimentoEn,
      'data_admissao': _dataAdmissao,
      'data_en': _dataEn,
      'user_id': user_id,
      'genero': _genero,
      'estado_civil':_estadoCivil,
      'aproved': _aproved,
      'empresa': _empresa
    };
  }

  String getSession(){
    return _session;
  }

  void setSession(String session){
    _session = session;
  }

  void setEmpresa (empresa){
    _empresa = empresa;
    _initiated = true;
  }

  void setGenero (genero){
    _genero = genero;
    _initiated = true;
  }

  void setSlug (slug){
    _slug = slug;
    _initiated = true;
  }

  void setSalt (salt){
    _salt = salt;
    _initiated = true;
  }
  void setToken (token) {
    _token = token;
    _initiated = true;
  }

  void setRG(rg){
    _rg = rg;
    _initiated = true;
  }

  void setEstadoCivil (estadoCivil){
    _estadoCivil = estadoCivil;
    _initiated = true;
  }
  void setCPF (cpf){
    _cpf = cpf;
    _initiated = true;
  }
  void setCargo (String cargo){
    _cargo = cargo;
    _initiated = true;
  }
  void setDataAdmissao (dataAdmissao){
    _dataAdmissao = dataAdmissao;
    _initiated = true;
  }
  void setDataEn (dataEn){
    _dataEn = dataEn;
    _initiated = true;
  }
  void setAproved (aproved){
    _aproved = aproved;
    _initiated = true;
  }
  void setDataNascimento (dataNascimento){
    _dataNascimento = dataNascimento;
    _initiated = true;
  }
  void setDataNascimentoEn (dataNacimentoEn){
    _dataNascimentoEn = dataNacimentoEn;
    _initiated = true;
  }

  String getEstadoCivil () => _estadoCivil;
  String getDataNascimento () => _dataNascimento;
  String getDataNascimentoEn () => _dataNascimentoEn;
  String getGenero() => _genero;
  String getSlug () => _slug;
  String getSalt () => _salt;
  String getToken () => _token;
  String getCPF () => _cpf;
  String getRG () => _rg;
  String? getCargo () => _cargo;
  String getDataAdmissao () => _dataAdmissao;
  String getDataEn () => _dataEn;
  String getEmpresa () => _empresa;
  int getAproved () => _aproved;

  bool isAproved () => _aproved == 1;
  bool isInitiated () => _initiated;

}
