class Qr {
  String? usuario;
  String? cofradia;
  String? antiguedad;
  String? posicion;
  String? fecha;

  Qr({this.usuario, this.cofradia, this.antiguedad, this.posicion, this.fecha});

  //method that assign values to respective datatype vairables
  Qr.fromJson(Map<String, dynamic> json) {
    usuario = json['usuario'];
    cofradia = json['cofradia'];
    antiguedad = json['antiguedad'];
    posicion = json['posicion'];
    fecha = json['fecha'];
  }
}
