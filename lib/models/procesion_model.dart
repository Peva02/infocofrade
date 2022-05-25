class Procesion {
  String? idCofradia;
  String? nombre;
  String? iglesia;
  String? urlImagen;
  String? telefono;
  String? descripcion;
  String? ruta;
  String? fecha;
  String? altitud;
  String? latitud;

  Procesion(
      {required this.idCofradia,
      required this.nombre,
      required this.iglesia,
      required this.urlImagen,
      required this.telefono,
      required this.descripcion,
      required this.ruta,
      required this.fecha,
      required this.altitud,
      required this.latitud});

  Procesion.fromJson(Map<String, dynamic> json) {
    idCofradia = json['idCofradia'];
    nombre = json['nombre'];
    iglesia = json['iglesia'];
    urlImagen = json['urlImagen'];
    telefono = json['telefono'];
    descripcion = json['descripcion'];
    ruta = json['ruta'];
    fecha = json['fecha'];
    altitud = json['altitud'];
    latitud = json['latitud'];
  }

  Map<String, dynamic> toMap() {
    return {
      'idCofradia': idCofradia.toString(),
      'nombre': nombre.toString(),
      'iglesia': iglesia.toString(),
      'urlImagen': urlImagen.toString(),
      'telefono': telefono.toString(),
      'descripcion': descripcion.toString(),
      'ruta': ruta.toString(),
      'fecha': fecha.toString(),
      'altitud': altitud.toString(),
      'latitud': latitud.toString()
    };
  }
}
