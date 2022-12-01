import 'package:sindcelma_app/model/Request.dart';
import 'package:sindcelma_app/model/entities/User.dart';
import 'package:sindcelma_app/model/services/DatabaseService.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sindcelma_app/model/entities/ResponseService.dart';

class SocioManagerService {

  Future<ResponseService> saveSocio() async {
    
    User user = User();

    await Request().post('/user/socios/check_document', {
      'doc': User().socio.getCPF()
    });

    var request = Request();
    await request.post('/user/socios/cadastrar_full_socio', {
      'nome':user.nome,
      'sobrenome':user.sobrenome,
      'cpf':user.socio.getCPF(),
      'email':user.email,
      'senha':user.senha,
      'cargo':user.socio.getCargo(),
      'data_admissao':user.socio.getDataEn(),
      'rg':user.socio.getRG(),
      'sexo':user.socio.getGenero(),
      'estado_civil':user.socio.getEstadoCivil(),
      'data_nascimento':user.socio.getDataNascimentoEn(),
      'telefone':user.telefone
    });

    if(request.code() != 200){
      return ResponseService(false, request.response()['message']);
    }

    var dataUser = request.response()['message'];

    User().socio.setSlug(dataUser['slug']);
    User().socio.setSalt(dataUser['salt']);
    User().socio.setCPF(dataUser['cpf']);
    User().status = 2;
    User().socio.status = 1;

    return const ResponseService(true, '');

  }

  Future<bool> generateSocio() async {

    User user = User();
    Database db = await DatabaseService().db;

    List socioQ = await db.query('socio', limit:1);

    if(socioQ.isNotEmpty){
      user.setSocioMapDB(socioQ.first);
    }

    return true;

  }


}