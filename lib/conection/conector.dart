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
    }
    return hermano;
  }

  Future<Qr> getQr(String idHermano) async {
    /* HttpOverrides.global = MyHttpOverrides();
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
    return qrCode;*/
    return Qr();
  }
}
  

  /*//-------------------------------------------------------------------------------------------------------------------------
  //Este método es el encargado de cargar todas las poblaciones

  Future<List<PopulationsModel>> getPopulations() async {
    HttpOverrides.global = MyHttpOverrides();
    var url =
        'http://tripeducation.es.desarrollo/mobile_app_web_service/selectPopulations.php';

    http.Response response = await http.get(url);

    var result;

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      result = data
          .map<PopulationsModel>((e) => PopulationsModel.fromJson(e))
          .toList();
    }

    return result;
  }

  //-------------------------------------------------------------------------------------------------------------------------

  //-------------------------------------------------------------------------------------------------------------------------

  //Este es el método encargado de cargar las opiniones

  Future<List<ReviewsModel>> getReviews() async {
    HttpOverrides.global = MyHttpOverrides();
    var url =
        'https://tripeducation.es.desarrollo/mobile_app_web_service/selectReviews.php';
    http.Response response = await http.get(url);

    List<ReviewsModel> listaReviews = [];

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (var review in data) {
        listaReviews.add(ReviewsModel.fromJson(review));
      }
    }
    return listaReviews;
  }

  //-------------------------------------------------------------------------------------------------------------------------

  //-------------------------------------------------------------------------------------------------------------------------

  //Este es el método encargado de cargar los centros

  Future<List<CentersModels>> getCenters() async {
    HttpOverrides.global = MyHttpOverrides();
    var url =
        'https://tripeducation.es.desarrollo/mobile_app_web_service/selectCenters.php';
    http.Response response = await http.get(url);

    List<CentersModels> listaCentros = [];

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (var center in data) {
        listaCentros.add(CentersModels.fromJson(center));
      }
    }

    return listaCentros;
  }

  //-------------------------------------------------------------------------------------------------------------------------

  //-------------------------------------------------------------------------------------------------------------------------

  //Este es el método encargado de obtener un centro, siendo identificado este mediante un id

  Future<CentersModels> getOneCenter(idCentro) async {
    HttpOverrides.global = MyHttpOverrides();
    var url =
        'https://tripeducation.es.desarrollo/mobile_app_web_service/selectOneCenter.php/?id_centro=' +
            idCentro;
    http.Response response = await http.get(url);

    CentersModels centro = CentersModels();

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (var center in data) {
        centro = CentersModels.fromJson(center);
      }
    }

    return centro;
  }

  //-------------------------------------------------------------------------------------------------------------------------

  //-------------------------------------------------------------------------------------------------------------------------

  //Este es el método encargado de sacar las formaciones que pertenecen a 1 centro en específico mediante el id

  Future<List<FormationModel>> getFormations(idCentro) async {
    HttpOverrides.global = MyHttpOverrides();
    var url =
        'https://tripeducation.es.desarrollo/mobile_app_web_service/selectFormacion.php/?id_centro=' +
            idCentro;
    http.Response response = await http.get(url);

    List<FormationModel> listaFormaciones = [];

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (var formation in data) {
        listaFormaciones.add(FormationModel.fromJson(formation));
      }
    }

    return listaFormaciones;
  }

  //-------------------------------------------------------------------------------------------------------------------------

  //-------------------------------------------------------------------------------------------------------------------------

  //Este es el método encargado de sacar los centros que pertenecen a 1 centro en específico mediante el id

  Future<List<ReviewsModel>> getReviewsCenter(idCentro) async {
    HttpOverrides.global = MyHttpOverrides();
    var url =
        'https://tripeducation.es.desarrollo/mobile_app_web_service/selectReviewsValoration.php/?id_centro=' +
            idCentro;
    http.Response response = await http.get(url);

    List<ReviewsModel> listaReviews = [];

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (var review in data) {
        listaReviews.add(ReviewsModel.fromJson(review));
      }
    }
    return listaReviews;
  }

  //-------------------------------------------------------------------------------------------------------------------------

  //-------------------------------------------------------------------------------------------------------------------------

  //Este es el método encargado de realizar la búsqueda por nombre y obtener los resultado coincidentes

  Future<List<CentersModels>> getCenterNames(nomCentro) async {
    HttpOverrides.global = MyHttpOverrides();
    var url =
        'https://tripeducation.es.desarrollo/mobile_app_web_service/selectSearchCenter.php/?nombre=' +
            nomCentro;
    http.Response response = await http.get(url);

    List<CentersModels> listaCentros = [];

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (var center in data) {
        listaCentros.add(CentersModels.fromJson(center));
      }
    }

    return listaCentros;
  }

  //-------------------------------------------------------------------------------------------------------------------------

  //-------------------------------------------------------------------------------------------------------------------------

  //Este método es el encargado de cargar todas las provincias

  Future<List<ProvincesCountryModel>> getProvincesCountry() async {
    HttpOverrides.global = MyHttpOverrides();
    var url =
        'https://tripeducation.es.desarrollo/mobile_app_web_service/selectProvincesCountry.php';

    http.Response response = await http.get(url);

    var result;

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      result = data
          .map<ProvincesCountryModel>((e) => ProvincesCountryModel.fromJson(e))
          .toList();
    }

    return result;
  }

  //-------------------------------------------------------------------------------------------------------------------------

  //-------------------------------------------------------------------------------------------------------------------------

  //Este es el método encargado de obtener un centro, siendo identificado este mediante un id

  Future<CenterValorationModel> getCentrosValoracion(idCentro) async {
    HttpOverrides.global = MyHttpOverrides();
    var url =
        'https://tripeducation.es.desarrollo/mobile_app_web_service/selectCentersValoration.php/?id_centro=' +
            idCentro;
    http.Response response = await http.get(url);

    CenterValorationModel centro = CenterValorationModel();

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (var center in data) {
        centro = CenterValorationModel.fromJson(center);
      }
    }

    return centro;
  }

  //-------------------------------------------------------------------------------------------------------------------------

  //-------------------------------------------------------------------------------------------------------------------------

  //Este método es el encargado de cargar todos los roles

  Future<List<RolesModel>> getRoles() async {
    HttpOverrides.global = MyHttpOverrides();
    var url =
        'https://tripeducation.es.desarrollo/mobile_app_web_service/selectRoles.php';

    http.Response response = await http.get(url);

    var result;

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      result = data.map<RolesModel>((e) => RolesModel.fromJson(e)).toList();
    }

    return result;
  }

  //-------------------------------------------------------------------------------------------------------------------------

  //-------------------------------------------------------------------------------------------------------------------------

  //Este método es el encargado de cargar todos los roles

  Future<bool> insertReview(idUser, idCentro, val, title, opinion, visible, rol,
      ubi, ens, prof, inst, serv) async {
    HttpOverrides.global = MyHttpOverrides();
    var url =
        'https://tripeducation.es.desarrollo/mobile_app_web_service/insertReviews.php/?id_usuario=' +
            idUser +
            '&id_centro=' +
            idCentro +
            '&valoracion=' +
            val +
            '&titulo=%22' +
            title +
            '%22&opinion=%22' +
            opinion +
            '%22&visible=' +
            visible +
            '&rol=%22' +
            rol +
            '%22&ubicacion_ptos=' +
            ubi +
            '&ense%C3%B1anza_ptos=' +
            ens +
            '&profesores_ptos=' +
            prof +
            '&instalaciones_ptos=' +
            inst +
            '&servicios_ptos=' +
            serv;

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
*/
  //-------------------------------------------------------------------------------------------------------------------------

