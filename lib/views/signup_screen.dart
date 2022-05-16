// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infocofrade/views/elements_generator.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

late String passOne, passTwo;

String itemSeleccionadoPaisProvincias = "";
String itemSeleccionadoPais = "";
String itemSeleccionadoProvincias = "";
List<String> itemsPaisProvincias = [];

class _SignupState extends State<Signup> {
  //Creamos dos controladres para obtener el texto de los FormFields, uno para el usuario y otro para la contraseña
  final TextEditingController _usuarioText = TextEditingController();
  final TextEditingController _contraseniaText = TextEditingController();
  final TextEditingController _confirmcontraseniaText = TextEditingController();
  final TextEditingController _mailText = TextEditingController();
  final TextEditingController _nombreText = TextEditingController();
  final TextEditingController _apellidoText = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  //Instanciamos los focusNode para poder hacer referencia al foco de cada FormField
  late FocusNode usuario,
      contrasenia,
      confirmcontrasenia,
      mail,
      nombre,
      apellido;
  //Instanciamos una key para cada uno de los FormField
  final _usuarioKey = GlobalKey<FormFieldState>();
  final _contraseniaKey = GlobalKey<FormFieldState>();
  final _confirmcontraseniaKey = GlobalKey<FormFieldState>();
  final _mailKey = GlobalKey<FormFieldState>();
  final _nombreKey = GlobalKey<FormFieldState>();
  final _apellidoKey = GlobalKey<FormFieldState>();
  //Declaramos el checkBox para mantener la sesion iniciada como false o desmarcado por defecto
  bool checkBoxValue = false;

  //final Controller controller = Controller();

  //Validamos los campos al perder y recuperar el foco en el FormField
  @override
  void initState() {
    super.initState();
    usuario = FocusNode();
    contrasenia = FocusNode();
    confirmcontrasenia = FocusNode();
    mail = FocusNode();
    nombre = FocusNode();
    apellido = FocusNode();
    //Validamos usuario
    usuario.addListener(() {
      if (usuario.hasFocus || !usuario.hasFocus) {
        _usuarioKey.currentState?.validate();
      }
    });
    //Validamos contraseña
    contrasenia.addListener(() {
      if (contrasenia.hasFocus || !contrasenia.hasFocus) {
        passOne = _contraseniaText.text;
        _contraseniaKey.currentState?.validate();
        _confirmcontraseniaKey.currentState?.validate();
      }
    });
    confirmcontrasenia.addListener(() {
      if (confirmcontrasenia.hasFocus || !confirmcontrasenia.hasFocus) {
        passTwo = _confirmcontraseniaText.text;
        _confirmcontraseniaKey.currentState?.validate();
        _contraseniaKey.currentState?.validate();
      }
    });
    mail.addListener(() {
      if (mail.hasFocus || !mail.hasFocus) {
        _mailKey.currentState?.validate();
      }
    });
    nombre.addListener(() {
      if (nombre.hasFocus || !nombre.hasFocus) {
        _nombreKey.currentState?.validate();
      }
    });
    apellido.addListener(() {
      if (apellido.hasFocus || !apellido.hasFocus) {
        _apellidoKey.currentState?.validate();
      }
    });

    //convertFutureListToList();
  }

  /*void convertFutureListToList() async {
    //Cargamos la lista de provincias y paises
    Future<List<ProvincesCountryModel>> futureOfListProvinces =
        controller.getProvincesCountry();
    List<ProvincesCountryModel> listProvinces = await futureOfListProvinces;
    for (var prov in listProvinces) {
      setState(() {
        itemsPaisProvincias.add(
            prov.nombrePais.toString() + ', ' + prov.nombreProvin.toString());
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.purple),
        backgroundColor: Colors.white,
        title: const Text(
          'InfoCofrade',
          style: TextStyle(
              overflow: TextOverflow.fade,
              fontSize: 35,
              fontFamily: 'title_font',
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: ListView(
        primary: false,
        children: [
          Center(
            child: SizedBox(
              width: 500,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 20.0, right: 20.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                divisorExpanded(Colors.white),
                                const SizedBox(
                                  child: Center(
                                    child: Text(
                                      'REGISTRO',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontFamily: 'title_font'),
                                    ),
                                  ),
                                ),
                                divisorExpanded(Colors.white),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                    child: Text(
                                  'Cuenta',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: 'title_font'),
                                )),
                                divisorExpanded(Colors.white),
                              ],
                            ),
                            //Creamos el formulario donde estableceremmos el contenido de este
                            Form(
                              key: _formKey,
                              child: Column(
                                //Llamamos a los métodos encargados de añadir los campos y el botón de submit
                                children: <Widget>[
                                  addFormField(
                                      usuario,
                                      _usuarioKey,
                                      _usuarioText,
                                      'Usuario',
                                      const Icon(Icons.person,
                                          color: Colors.grey),
                                      false),
                                  addFormField(
                                      contrasenia,
                                      _contraseniaKey,
                                      _contraseniaText,
                                      'Contraseña',
                                      const Icon(Icons.key, color: Colors.grey),
                                      true),
                                  addFormField(
                                      confirmcontrasenia,
                                      _confirmcontraseniaKey,
                                      _confirmcontraseniaText,
                                      'Confirmar contraseña',
                                      const Icon(Icons.key, color: Colors.grey),
                                      true),
                                  ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://assets.stickpng.com/images/585e4bd7cb11b227491c3397.png',
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.account_circle,
                                        size: 75,
                                        color: Colors.white,
                                      ),
                                      height: 85,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        child: Text(
                                          'Datos personales',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontFamily: 'title_font'),
                                        ),
                                      ),
                                      divisorExpanded(Colors.white),
                                    ],
                                  ),
                                  addFormField(
                                      mail,
                                      _mailKey,
                                      _mailText,
                                      'Mail',
                                      const Icon(Icons.mail,
                                          color: Colors.grey),
                                      false),
                                  addFormField(
                                      nombre,
                                      _nombreKey,
                                      _nombreText,
                                      'Nombre',
                                      const Icon(Icons.abc, color: Colors.grey),
                                      false),
                                  addFormField(
                                      apellido,
                                      _apellidoKey,
                                      _apellidoText,
                                      'Apellidos',
                                      const Icon(Icons.abc, color: Colors.grey),
                                      false),
                                  submit(_formKey, context)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//-------------------------------------------------------------------------------------------------------------------------
}

//Metodo encargado de crear un nuevo FormField
addFormField(focusName, keyName, controllerName, hint, icono, obscureText) {
  return Padding(
    padding: const EdgeInsets.only(top: 0.5, bottom: 0.5),
    child: SizedBox(
      height: 80,
      child: TextFormField(
          style: const TextStyle(fontFamily: 'Roboto'),
          controller: controllerName,
          focusNode: focusName,
          key: keyName,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            /** Dependiendo del estado del campo el borde se pintará de un color u otro
             * El borde que se mostrará cuando el campo este habilitado y no seleccionado
             */
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.grey, width: 2)),
            //El borde que se mostrará cuando al campo esté habilitado y seleccionado
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.white, width: 2)),
            //El borde que se mostrará cuando el campo este deshabilitado y no seleccionado
            errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.red, width: 2)),
            //El borde que se mostrará cuando el campo este deshabilitado y seleccionado
            focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.orange, width: 2)),
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
            ),
            prefixIcon: icono,
          ),
          //Realizamos la validacion y comprobamos si el FormField se encuentra vacío
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, rellene todos los campos';
            } else if (obscureText && value.length < 6) {
              return 'La contraseña debe tener al menos 6 caracteres';
            } else if (obscureText && passOne != passTwo) {
              return 'Las contraseñas deben coincidir';
            }
            return null;
          }),
    ),
  );
}

//Metodo encargado de crear el botón
submit(_formKey, context) {
  return Padding(
    padding: const EdgeInsets.only(top: 20.0, bottom: 16.0),
    child: SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.amber.shade700,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          side: const BorderSide(color: Colors.white, width: 2),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {}
        },
        child: const Text(
          'Crear cuenta',
          style: TextStyle(fontSize: 20),
        ),
      ),
    ),
  );
}
