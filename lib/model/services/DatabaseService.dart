import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DatabaseService {

  static final DatabaseService _databaseService = DatabaseService._();

  static Database? _database;

  factory DatabaseService(){
    return _databaseService;
  }

  DatabaseService._();

  Future<Database> get db async {
    return _database ??= await _databaseInit();
  }

  Future<Database> _databaseInit() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'sindcelma.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS user (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nome TEXT NOT NULL,
              sobrenome TEXT NOT NULL,
              email TEXT NOT NULL,
              telefone TEXT,
              status INTEGER NOT NULL
          )
        '''
        );
        await db.execute('''
          CREATE TABLE IF NOT EXISTS socio (
              user_id INTEGER,
              cargo TEXT NOT NULL,
              genero TEXT NOT NULL,
              estado_civil TEXT NOT NULL,
              empresa TEXT NOT NULL,
              data_nascimento TEXT NOT NULL,
              data_nascimento_en TEXT NOT NULL,
              data_admissao TEXT NOT NULL,
              data_en TEXT NOT NULL,
              slug TEXT NOT NULL,
              salt TEXT NOT NULL,
              token TEXT NOT NULL,
              aproved INTEGER NOT NULL,
              PRIMARY KEY (user_id),
              FOREIGN KEY (user_id) REFERENCES user(id)
          )
        '''
        );
      }
    );
  }

}