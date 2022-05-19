import 'dart:io';

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:infocofrade/conection/conector.dart';
import 'package:infocofrade/models/hermano_model.dart';
import 'package:infocofrade/views/elements_generator.dart';
import 'package:infocofrade/views/nav_bar_screen.dart';
import 'package:infocofrade/views/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const InfoCofradeScreen());
}

class InfoCofradeScreen extends StatelessWidget {
  const InfoCofradeScreen({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InfoCofrade',
      theme: ThemeData(
          errorColor: Colors.redAccent,
          primarySwatch: Colors.purple,
          scaffoldBackgroundColor: Colors.purple.shade900),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//Creamos dos controladres para obtener el texto de los FormFields, uno para el usuario y otro para la contraseña
final TextEditingController dniText = TextEditingController();
final TextEditingController contraseniaText = TextEditingController();
late bool canLog;

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  //Instanciamos los focusNode para poder hacer referencia al foco de cada FormField
  late FocusNode dni, contrasenia;

  //Instanciamos una key para cada uno de los FormField
  final _dniKey = GlobalKey<FormFieldState>();
  final _contraseniaKey = GlobalKey<FormFieldState>();

  //Declaramos el checkBox para mantener la sesion iniciada como false o desmarcado por defecto
  bool checkBoxValue = false;
  Conector conector = Conector();

  //Cargamos las preferencias
  _loadPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      checkBoxValue = preferences.getBool("checkBox")!;
      dniText.text = preferences.getString("dni")!;
      contraseniaText.text = preferences.getString("passwd")!;
    });
  }

  //Validamos los campos al perder y recuperar el foco en el FormField
  @override
  void initState() {
    super.initState();
    //Al iniciar la app, cargaremos las preferencias
    _loadPreferences();
    dni = FocusNode();
    contrasenia = FocusNode();
    //Validamos usuario
    dni.addListener(() {
      if (dni.hasFocus || !dni.hasFocus) {
        _dniKey.currentState?.validate();
      }
    });
    //Validamos contraseña
    contrasenia.addListener(() {
      if (contrasenia.hasFocus || !contrasenia.hasFocus) {
        _contraseniaKey.currentState?.validate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(
        primary: false,
        children: [
          Center(
            child: SizedBox(
              width: 500,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/icono.png",
                      height: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 20.0, right: 20.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              divisorExpanded(Colors.white),
                              const Center(
                                child: Text(
                                  "BIENVENIDO",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontFamily: "title_font"),
                                ),
                              ),
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
                                    dni,
                                    _dniKey,
                                    dniText,
                                    'Dni ',
                                    const Icon(Icons.person,
                                        color: Colors.grey),
                                    false),
                                addFormField(
                                    contrasenia,
                                    _contraseniaKey,
                                    contraseniaText,
                                    'Contraseña',
                                    const Icon(Icons.key, color: Colors.grey),
                                    true),
                                submit(_formKey, context, dniText,
                                    contraseniaText),
                              ],
                            ),
                          ),
                          /*Esta sección pertenece a la posicionada debajo del formulario, donde se encuentra el checkBox de mantener sesion iniciada
                              y el restablecer contraseña*/

                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      onChanged(checkBoxValue);
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                          value: checkBoxValue,
                                          side: BorderSide(
                                              color: Colors.amber.shade700),
                                          onChanged: onChanged,
                                          activeColor: Colors.white,
                                          checkColor: Colors.purple.shade900,
                                        ),
                                        const Text("Mantener Iniciado",
                                            style:
                                                TextStyle(color: Colors.white))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          //En esta seccion encontramos la opción de crear una cuenta en la aplicación
                          Row(children: [divisorExpanded(Colors.white)]),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Text("¿No estas registrado?",
                                    style: TextStyle(color: Colors.white)),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Signup(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    " Crear cuenta",
                                    style: TextStyle(
                                        color: Colors.yellow.shade700,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Text(
                                  " o ",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        changePrefreces();
                                        canLog = false;
                                        Hermano hermano = Hermano();
                                        hermano =
                                            await conector.getHermano('0');

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Navegation(hermano)),
                                        );
                                      },
                                      child: Text(
                                        "Acceder como anónimo",
                                        style: TextStyle(
                                            color: Colors.yellow.shade700,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
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

  //Metodo encargado de cambiar el estado del CheckBox
  void onChanged(bool? value) {
    setState(() {
      if (checkBoxValue) {
        checkBoxValue = false;
      } else {
        checkBoxValue = true;
      }
    });
  }

  //Guarda el valor de los campos en las preferencias, el metodo será Future,
  //por si falla la carga, que no bloque la app
  Future<void> changePrefreces() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      if (checkBoxValue) {
        preferences.setString("dni", dniText.text);
        preferences.setString("passwd", contraseniaText.text);
        preferences.setBool("checkBox", checkBoxValue);
      } else {
        preferences.setString("dni", "");
        preferences.setString("passwd", "");
        preferences.setBool("checkBox", checkBoxValue);
      }
    });
  }

  //Metodo encargado de crear el botón
  submit(_formKey, context, TextEditingController usuario,
      TextEditingController passwd) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
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
            canLog = await conector.canLogin(
                usuario.text, md5.convert(utf8.encode(passwd.text)).toString());

            if (_formKey.currentState!.validate()) {
              if (canLog) {
                Hermano hermano = Hermano();
                hermano = await conector.getHermano(dniText.text);
                changePrefreces();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Navegation(hermano)),
                  (route) => false,
                );
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
                            'Credenciales incorrectas',
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
            'Iniciar sesion',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

//Metodo encargado de crear un nuevo FormField
addFormField(focusName, keyName, TextEditingController controllerName, hint,
    icono, obscureText) {
  return Padding(
    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
    child: SizedBox(
      height: 80,
      child: TextFormField(
          style: const TextStyle(fontFamily: "Roboto"),
          controller: controllerName,
          focusNode: focusName,
          key: keyName,
          obscureText: obscureText,
          onChanged: (value) {
            //print(controllerName.text);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            //El borde que se mostrará cuando el campo este habilitado y no seleccionado
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
            if (value == null || value.trim().isEmpty) {
              return "Por favor, rellene todos los campos";
            }
            return null;
          }),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
