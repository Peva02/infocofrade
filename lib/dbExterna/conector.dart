import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infocofrade/models/hermano_model.dart';
import 'package:infocofrade/models/procesion_model.dart';
import 'package:infocofrade/models/qr_model.dart';

class Conector {
  final String domain = 'http://iesayala.ddns.net/eduardo/';

  ///Este método es el encargado de cargar las procesiones
  Future<List<Procesion>> getProcesiones() async {
    HttpOverrides.global = MyHttpOverrides();

    String url = domain + 'selectCofradias.php';

    http.Response response = await http.get(Uri.parse(url));
    late List<Procesion> procesionesList;
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      procesionesList =
          data.map<Procesion>((e) => Procesion.fromJson(e)).toList();
    }
    return procesionesList;
  }

  ///Comprueba si las credenciales del usuario son correctas
  Future<bool> canLogin(String dni, String passwd) async {
    HttpOverrides.global = MyHttpOverrides();
    String url =
        domain + "selectLogin.php?dni='" + dni + "'&password='" + passwd + "'";

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data[0]['exist'] == '1') {
        return true;
      }
    }
    return false;
  }

  ///Ejecuta la consuta necesaria para dar de alta un usuario, pasandole
  ///por parametros un objeto 'hermano'
  Future<bool> insertHermano(Hermano hermano) async {
    HttpOverrides.global = MyHttpOverrides();
    String url = domain +
        'insertHermanos.php?nombre="' +
        hermano.nombre.toString() +
        '"&apellidos="' +
        hermano.apellidos.toString() +
        '"&dni="' +
        hermano.dni.toString() +
        '"&passwd="' +
        hermano.password.toString() +
        '"&tlf=' +
        hermano.telefono.toString();
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200 &&
        response.body.toString().trim().isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  ///Obtiene los datos de un hermano mediante su dni
  Future<Hermano> getHermano(String dni) async {
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse(domain + 'selectHermano.php?dni=' + dni);

    http.Response response = await http.get(url);
    Hermano hermano = Hermano();
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      hermano.idHermano = data[0]['idHermano'];
      hermano.nombre = data[0]['nombre'];
      hermano.apellidos = data[0]['apellidos'];
      hermano.telefono = data[0]['telefono'];
      hermano.dni = data[0]['dni'];
      hermano.antiguedad = data[0]['antiguedad'];
      hermano.password = data[0]['password'];
    }
    return hermano;
  }

  ///Ejecuta la consulta encargada de modificar los datos de un 'hermano'
  Future<bool> updateHermano(Hermano hermano) async {
    HttpOverrides.global = MyHttpOverrides();
    String url = domain +
        'updateHermano.php?idHermano="' +
        hermano.idHermano.toString() +
        '"&nombre="' +
        hermano.nombre.toString() +
        '"&apellidos="' +
        hermano.apellidos.toString() +
        '"&dni="' +
        hermano.dni.toString() +
        '"&password="' +
        hermano.password.toString() +
        '"&telefono=' +
        hermano.telefono.toString();
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200 &&
        response.body.toString().trim().isNotEmpty) {
      return true;
    }
    return false;
  }

  ///Ejecuta la consulta encargada de eliminar un 'hermano'
  Future<bool> deleteHermano(Hermano hermano) async {
    HttpOverrides.global = MyHttpOverrides();
    String url =
        domain + 'deleteHermano.php?idHermano=' + hermano.idHermano.toString();
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200 &&
        response.body.toString().trim().isNotEmpty) {
      return true;
    }
    return false;
  }

  ///Obtiene los datos necesario para generar un QR con los datos
  ///del idHermano indicado
  Future<Qr> getQr(String idHermano) async {
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse(domain + 'selectQr.php?idHermano=' + idHermano);
    http.Response response = await http.get(url);
    Qr qrCode = Qr();
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      qrCode.usuario = data[0]['usuario'];
      qrCode.cofradia = data[0]['cofradia'];
      qrCode.antiguedad = data[0]['antiguedad'];
      qrCode.posicion = data[0]['posicion'];
      qrCode.fecha = data[0]['fecha'];
    }
    return qrCode;
  }

  ///Obtiene la localización actual de la cofradía
  Future<List<String>> getLocationProcesion(String idCofradia) async {
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse(
        domain + 'selectLocationCofradia.php?idCofradia=' + idCofradia);
    http.Response response = await http.get(url);
    List<String> localizacion = [];

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      localizacion.add(data[0]['altitud']);
      localizacion.add(data[0]['latitud']);
    }
    return localizacion;
  }
}

///Clase necesaria para generar las consutas a la base de datos debido a que la conexion no esta certificada, por lo que debemos
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
