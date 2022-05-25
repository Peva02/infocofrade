import 'package:infocofrade/models/procesion_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Future<Database> _openDb() async {
    return openDatabase(join(await getDatabasesPath(), 'procesiones.db'),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE procesiones(idCofradia TEXT PRIMARY KEY,nombre TEXT,iglesia TEXT,urlImagen TEXT,telefono TEXT,descripcion TEXT,ruta TEXT,fecha TEXT,altitud TEXT,latitud TEXT)");
    }, version: 1);
  }

  static Future<int> insert(Procesion procesion) async {
    Database database = await _openDb();

    return database.insert("procesiones", procesion.toMap());
  }

  static Future<List<Procesion>> listProcesioens() async {
    Database database = await _openDb();

    final List<Map<String, dynamic>> procesionesMap =
        await database.query("procesiones");

    return List.generate(
      procesionesMap.length,
      (index) => Procesion(
          idCofradia: procesionesMap[index]['idCofradia'],
          nombre: procesionesMap[index]['nombre'],
          iglesia: procesionesMap[index]['iglesia'],
          urlImagen: "",
          telefono: procesionesMap[index]['telefono'],
          descripcion: procesionesMap[index]['descripcion'],
          ruta: procesionesMap[index]['ruta'],
          fecha: procesionesMap[index]['fecha'],
          altitud: '0',
          latitud: '0'),
    );
  }
}
