import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:infocofrade/models/hermano_model.dart';
import 'package:infocofrade/models/procesion_model.dart';
import 'package:infocofrade/models/qr_model.dart';

import '../main.dart';

class Conector {
  late String domain = 'http://iesayala.ddns.net/eduardo/';

  //Este método es el encargado de cargar todos los países
  Future<List<Procesion>> getProcesiones() async {
    HttpOverrides.global = MyHttpOverrides();

    String url = domain + 'selectCofradias.php';

    http.Response response = await http.get(Uri.parse(url));
    late List<Procesion> result;
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      result = data.map<Procesion>((e) => Procesion.fromJson(e)).toList();
    }
    return result;
  }

  Future<bool> canLogin(String dni, String passwd) async {
    HttpOverrides.global = MyHttpOverrides();
    String url =
        domain + "selectLogin.php?dni='" + dni + "'&password='" + passwd + "'";

    http.Response response = await http.get(Uri.parse(url));
    late Map<String, dynamic> existe;

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      existe = data[0];
      if (existe['exist'] == '1') {
        return true;
      }
    }
    return false;
  }

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
    } else {
      return false;
    }
  }

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
}
