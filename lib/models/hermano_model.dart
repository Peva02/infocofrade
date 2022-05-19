class Hermano {
  String? idHermano;
  String? nombre;
  String? apellidos;
  String? dni;
  String? password;
  String? telefono;
  String? antiguedad;
  String? activo;

  Hermano(
      {this.idHermano,
      this.nombre,
      this.apellidos,
      this.dni,
      this.password,
      this.telefono,
      this.antiguedad});

  //method that assign values to respective datatype vairables
  Hermano.fromJson(Map<String, dynamic> json) {
    idHermano = json['idHermano'];
    nombre = json['nombre'];
    apellidos = json['apellidos'];
    dni = json['dni'];
    password = json['password'];
    telefono = json['telefono'];
    antiguedad = json['fIngreso'];
  }
}
