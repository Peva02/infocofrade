// ignore_for_file: import_of_legacy_library_into_null_safe
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:infocofrade/dbExterna/conector.dart';
import 'package:infocofrade/main_screen.dart';
import 'package:infocofrade/views/nav_bar_screen.dart';
import 'package:infocofrade/models/hermano_model.dart';
import 'elements_generator.dart';

class Profile extends StatefulWidget {
  const Profile(this.hermano, {Key? key}) : super(key: key);
  final Hermano hermano;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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

  //Declaramos el checkBox para mantener la sesion iniciada (false/desmarcado por defecto)
  bool checkBoxValue = false;

  @override
  void initState() {
    super.initState();
    hermano = widget.hermano;
    tlf = FocusNode();
    dni = FocusNode();
    contrasenia = FocusNode();
    confirmcontrasenia = FocusNode();
    nombre = FocusNode();
    apellido = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(
        primary: false,
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: 500,
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: [
                      //Imagen y nombre de ususario
                      Row(
                        children: [
                          divisorExpanded(Colors.white),
                          SizedBox(
                            child: Center(
                              child: Text(
                                '¡Hola, ' + hermano.nombre.toString() + '!',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'title_font'),
                              ),
                            ),
                          ),
                          divisorExpanded(Colors.white),
                        ],
                      ),
                      labelText(
                          null, "Datos Personales", Colors.white, Colors.white),
                      //Creamos el formulario donde estableceremos el contenido de este
                      //Llamamos a los métodos encargados de añadir los campos y los botones
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            addFormField(
                                nombre,
                                _nombreKey,
                                _nombreText,
                                hermano.nombre.toString(),
                                const Icon(Icons.abc, color: Colors.grey),
                                false),
                            addFormField(
                                apellido,
                                _apellidoKey,
                                _apellidoText,
                                hermano.apellidos.toString(),
                                const Icon(Icons.abc, color: Colors.grey),
                                false),
                            addFormField(
                                dni,
                                _dniKey,
                                _dniText,
                                hermano.dni.toString(),
                                const Icon(Icons.fingerprint,
                                    color: Colors.grey),
                                false),
                            addFormField(
                                tlf,
                                _tlfKey,
                                _tlfText,
                                hermano.telefono.toString(),
                                const Icon(Icons.call, color: Colors.grey),
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
                            SizedBox(
                              width: 500,
                              child: Column(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: button(
                                              _formKey,
                                              'Modificar',
                                              Colors.amber.shade700,
                                              Colors.white)),
                                      Expanded(
                                          child: button(
                                        _formKey,
                                        'Cancelar',
                                        Colors.red,
                                        Colors.white,
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            button(_formKey, 'Eliminar cuenta',
                                Colors.grey.shade200, Colors.red)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  ///Metodo encargado de crear un nuevo FormField
  Padding addFormField(
      focusName, keyName, controllerName, hint, icono, obscureText) {
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
            //Dependiendo del estado del campo el borde se pintará de un color u otro
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
          //Realizamos la validacion y comprobamos si el FormField cumple
          //con las restricciones
          validator: (value) {
            if (obscureText &&
                _contraseniaText.text != _confirmcontraseniaText.text) {
              return 'Las contraseñas deben coincidir';
            } else if (focusName == dni &&
                !validationDni(_dniText.text) &&
                value.toString().isNotEmpty) {
              return 'Compruebe su dni';
            } else if (focusName == tlf &&
                !validationTelf(_tlfText.text) &&
                value.toString().isNotEmpty) {
              return 'Compruebe su telefono';
            }
            return null;
          },
        ),
      ),
    );
  }

  ///Metodo encargado de crear los botones
  Padding button(_formKey, text, colorButton, colorElem) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 20.0, bottom: 25.0, left: 5.0, right: 5.0),
      child: SizedBox(
        height: 40,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: colorButton,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            side: BorderSide(color: colorElem, width: 2),
          ),
          onPressed: () {
            switch (text) {
              case 'Modificar':
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => AlertDialog(
                    title: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.warning,
                            color: Colors.red,
                          ),
                        ),
                        Text('Advertencia',
                            style: TextStyle(fontFamily: 'Roboto'))
                      ],
                    ),
                    content: const Text(
                      '¿Esta seguro de que desea modificar su perfil?',
                      style: TextStyle(fontFamily: 'Roboto'),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'No',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () => modificarValues(_formKey, context),
                        child: const Text('Si'),
                      ),
                    ],
                  ),
                );
                break;
              case 'Cancelar':
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => AlertDialog(
                    title: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.warning,
                            color: Colors.red,
                          ),
                        ),
                        Text('Advertencia',
                            style: TextStyle(fontFamily: 'Roboto'))
                      ],
                    ),
                    content: const Text(
                      '¿Esta seguro de que desea cancelar?',
                      style: TextStyle(fontFamily: 'Roboto'),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'No',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () => cancel(),
                        child: const Text('Si'),
                      ),
                    ],
                  ),
                );
                break;
              case 'Eliminar cuenta':
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => AlertDialog(
                    title: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.warning,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          '¡ADVERTENCIA!',
                          style: TextStyle(
                              fontFamily: 'Roboto', color: Colors.red),
                        )
                      ],
                    ),
                    content: const Text(
                      '¿Esta seguro de que desea eliminar la cuenta? No podrá recuperarla una vez eliminada.',
                      style:
                          TextStyle(fontFamily: 'Roboto', color: Colors.black),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () => deleteAcount(context),
                        child: const Text(
                          'Eliminar',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
                break;
            }
          },
          child: Text(
            text,
            style: TextStyle(fontSize: 20, color: colorElem),
          ),
        ),
      ),
    );
  }

  ///Cargas los datos introducidos en los campos, en un objeto "Hermano" y
  ///llama al metodo encargado de actualizar los datos en la base de datos
  void modificarValues(_formKey, context) async {
    if (_formKey.currentState!.validate()) {
      setState(
        () {
          if (_nombreText.text.isNotEmpty) {
            hermano.nombre = _nombreText.text.trim();
          }
          if (_apellidoText.text.isNotEmpty) {
            hermano.apellidos = _apellidoText.text.trim();
          }
          if (validationDni(_dniText.text)) {
            hermano.dni = _dniText.text.trim();
          }
          if (validationTelf(_tlfText.text)) {
            hermano.telefono = _tlfText.text.trim();
          }
          if (_contraseniaText.text.isNotEmpty) {
            hermano.password = md5
                .convert(utf8.encode(_contraseniaText.text.trim()))
                .toString();
          }
        },
      );
      await conector.updateHermano(hermano).then(
        (value) {
          return ScaffoldMessenger.of(context).showSnackBar(
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
                      '¡Usuario actualiazdo correctamente!',
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
        },
      ).catchError((err) {
        return ScaffoldMessenger.of(context).showSnackBar(
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
                    'Ocurrió un error inesperado',
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
      });
      cancel();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.amber.shade700,
          content: Row(
            children: const [
              Icon(
                Icons.sentiment_dissatisfied,
                size: 40,
                color: Colors.white,
              ),
              Expanded(
                child: Text(
                  'Compruebe la información de los campos.',
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
    }
  }

  ///Llama al metodo encargado de eliminar usuario,
  ///y elimina el hermano indicado por parámetros
  void deleteAcount(context) async {
    await conector.deleteHermano(hermano).then(
      (bool value) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Main()),
            (route) => false);
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Row(
              children: const [
                Icon(
                  Icons.sentiment_dissatisfied_outlined,
                  size: 40,
                  color: Colors.white,
                ),
                Expanded(
                  child: Text(
                    'Esperamos que vuelva pronto.',
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
      },
    ).catchError(
      (error) {
        Navigator.of(context).pop();
        return ScaffoldMessenger.of(context).showSnackBar(
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
                    'Sucedió un error al eliminar su cuenta.',
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
      },
    );
  }

  ///Elimina la pantalla actual y redirige al usuario a la pantalla
  ///de itinerario
  void cancel() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Navegation(hermano)),
        (route) => false);
  }
}
