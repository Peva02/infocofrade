import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:infocofrade/dbExterna/conector.dart';
import 'package:infocofrade/models/hermano_model.dart';
import 'package:infocofrade/views/elements_generator.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final Conector conector = Conector();
  late Hermano hermano;

  //Creamos TextEditingController para obtener el texto de los campos de los formularios
  final TextEditingController _dniText = TextEditingController();
  final TextEditingController _tlfText = TextEditingController();
  final TextEditingController _contraseniaText = TextEditingController();
  final TextEditingController _confirmcontraseniaText = TextEditingController();
  final TextEditingController _nombreText = TextEditingController();
  final TextEditingController _apellidoText = TextEditingController();

  //Instanciamos los focusNode para poder hacer referencia al foco de cada FormField
  late FocusNode tlf, dni, contrasenia, confirmcontrasenia, nombre, apellido;

  //Instanciamos una key para cada uno de los FormField, para poder verificar los campos
  final _formKey = GlobalKey<FormState>();
  final _dniKey = GlobalKey<FormFieldState>();
  final _tlfKey = GlobalKey<FormFieldState>();
  final _contraseniaKey = GlobalKey<FormFieldState>();
  final _confirmcontraseniaKey = GlobalKey<FormFieldState>();
  final _nombreKey = GlobalKey<FormFieldState>();
  final _apellidoKey = GlobalKey<FormFieldState>();

  //Validamos los campos al perder y recuperar el foco en el FormField
  @override
  void initState() {
    super.initState();
    hermano = Hermano();
    nombre = FocusNode();
    apellido = FocusNode();
    dni = FocusNode();
    tlf = FocusNode();
    contrasenia = FocusNode();
    confirmcontrasenia = FocusNode();

    //Validamos campos al perder el foco
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
    dni.addListener(() {
      if (dni.hasFocus || !dni.hasFocus) {
        _dniKey.currentState?.validate();
      }
    });
    tlf.addListener(() {
      if (tlf.hasFocus || !tlf.hasFocus) {
        _tlfKey.currentState?.validate();
      }
    });
    contrasenia.addListener(() {
      if (contrasenia.hasFocus || !contrasenia.hasFocus) {
        _contraseniaKey.currentState?.validate();
        _confirmcontraseniaKey.currentState?.validate();
      }
    });
    confirmcontrasenia.addListener(() {
      if (confirmcontrasenia.hasFocus || !confirmcontrasenia.hasFocus) {
        _confirmcontraseniaKey.currentState?.validate();
        _contraseniaKey.currentState?.validate();
      }
    });
  }

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
                                    'REGISTRO USUSARIO',
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
                                'Datos de hermano',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontFamily: 'title_font'),
                              )),
                              divisorExpanded(Colors.white),
                            ],
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              //Llamamos a los métodos encargados de añadir los campos y el botón de submit
                              children: <Widget>[
                                addFormField(
                                    nombre,
                                    _nombreKey,
                                    _nombreText,
                                    'Nombre',
                                    const Icon(Icons.abc, color: Colors.grey),
                                    TextInputType.name,
                                    false),
                                addFormField(
                                    apellido,
                                    _apellidoKey,
                                    _apellidoText,
                                    'Apellidos',
                                    const Icon(Icons.abc, color: Colors.grey),
                                    TextInputType.name,
                                    false),
                                addFormField(
                                    dni,
                                    _dniKey,
                                    _dniText,
                                    'DNI',
                                    const Icon(Icons.fingerprint,
                                        color: Colors.grey),
                                    TextInputType.text,
                                    false),
                                addFormField(
                                    tlf,
                                    _tlfKey,
                                    _tlfText,
                                    'Telefono',
                                    const Icon(Icons.call, color: Colors.grey),
                                    TextInputType.phone,
                                    false),
                                addFormField(
                                    contrasenia,
                                    _contraseniaKey,
                                    _contraseniaText,
                                    'Contraseña',
                                    const Icon(Icons.key, color: Colors.grey),
                                    TextInputType.visiblePassword,
                                    true),
                                addFormField(
                                    confirmcontrasenia,
                                    _confirmcontraseniaKey,
                                    _confirmcontraseniaText,
                                    'Confirmar contraseña',
                                    const Icon(Icons.key, color: Colors.grey),
                                    TextInputType.name,
                                    true),
                                submit(_formKey)
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
        ],
      ),
    );
  }

  ///Metodo encargado de crear el botón submit
  submit(_formKey) {
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
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              setState(
                () {
                  hermano.nombre = _nombreText.text.trim();
                  hermano.apellidos = _apellidoText.text.trim();
                  hermano.dni = _dniText.text.trim();
                  hermano.password = md5
                      .convert(utf8.encode(_contraseniaText.text.trim()))
                      .toString();
                  hermano.telefono = _tlfText.text.trim();
                },
              );
              if (!validationDni(hermano.dni.toString())) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Row(
                      children: const [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                        Expanded(
                          child: Text(
                            '¡Revise su DNI!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.white)),
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height - 100,
                        right: 20,
                        left: 20),
                  ),
                );
                return;
              }
              if (!validationTelf(hermano.telefono.toString())) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Row(
                      children: const [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                        Expanded(
                          child: Text(
                            '¡Revise su telefono!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.white)),
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height - 100,
                        right: 20,
                        left: 20),
                  ),
                );
                return;
              }
              bool insert = await conector.insertHermano(hermano);

              if (insert) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Row(
                      children: const [
                        Icon(
                          Icons.sentiment_satisfied,
                          size: 40,
                          color: Colors.white,
                        ),
                        Expanded(
                          child: Text(
                            '¡Bienvenido a InfoCofrade!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.white)),
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height - 100,
                        right: 20,
                        left: 20),
                  ),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Row(
                      children: const [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                        Expanded(
                          child: Text(
                            'Error al darse de alta',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.white)),
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height - 100,
                        right: 20,
                        left: 20),
                  ),
                );
              }
            }
          },
          child: const Text(
            'Crear cuenta',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  ///Metodo encargado de crear un nuevo FormField
  Padding addFormField(focusName, keyName, controllerName, hint, icono,
      keyboradType, obscureText) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.5, bottom: 0.5),
      child: SizedBox(
        height: 80,
        child: TextFormField(
            style: const TextStyle(fontFamily: 'Roboto'),
            keyboardType: keyboradType,
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
              } else if (obscureText &&
                  _contraseniaText.text != _confirmcontraseniaText.text) {
                return 'Las contraseñas deben coincidir';
              }
              return null;
            }),
      ),
    );
  }
}
