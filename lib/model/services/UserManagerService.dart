import 'package:sindcelma_app/model/entities/User.dart';
import 'package:sindcelma_app/model/services/DatabaseService.dart';
import 'package:sqflite/sqflite.dart';

class UserManagerService {

  int lastIdInserted = 0;

  Future<bool> saveUser({bool onlyUser = false}) async {

    Database db = await DatabaseService().db;
    User user   = User();

    try {
      List userQ  = await db.query('user', limit: 1);
      if(userQ.isNotEmpty){
        await db.update('user', user.toMap(),  where: 'id = 1');
        if(!onlyUser){
          await db.update('socio', user.socio.toMap(),  where: 'user_id = 1');
        }
      } else {
        int id = await db.insert('user', user.toMap());
        if(!onlyUser) {
          await db.insert('socio', user.socio.toMap());
        }
      }
      return true;
    } catch(err){
      return false;
    }
  }

  Future<bool> updateUser() async {

    Database db = await DatabaseService().db;
    User user   = User();

    int updateCount = await db.update('user', user.toMap(),  where: 'id = 1');

    return updateCount > 0;

  }

  Future<bool> updateSocio() async {

    User user = User();
    Database db = await DatabaseService().db;

    int updateCount = await db.update('socio', user.socio.toMap(),  where: 'user_id = 1');

    return updateCount > 0;

  }

  Future<bool> generateUser() async {

    Database db = await DatabaseService().db;
    User user   = User();

    List userQ  = await db.query('user', limit: 1);

    if(userQ.isEmpty) return true;
    var userS = userQ.first;
    user.setDataMap(userS);
    user.status = userS['status'];

    return true;

  }

  Future<bool> reset() async {

    Database db = await DatabaseService().db;

    try {

      db.delete("socio");
      db.delete("user");
      db.execute("UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE NAME='user';");
      User().reset();
      return true;
    } catch(err){
      return false;
    }
    
  }


}