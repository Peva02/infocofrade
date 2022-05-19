// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:infocofrade/main.dart';
import '../models/hermano_model.dart';
import 'elements_generator.dart';

class Profile extends StatefulWidget {
  const Profile(this.hermano, {Key? key}) : super(key: key);
  final Hermano hermano;

  @override
  State<Profile> createState() => _ProfileState();
}

late String passOne, passTwo;

class _ProfileState extends State<Profile> {
  //Creamos los controladres para obtener el texto de los campos de los formularios
  final TextEditingController _dniText = TextEditingController();
  final TextEditingController _tlfText = TextEditingController();
  final TextEditingController _contraseniaText = TextEditingController();
  final TextEditingController _confirmcontraseniaText = TextEditingController();
  final TextEditingController _nombreText = TextEditingController();
  final TextEditingController _apellidoText = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final Hermano hermano;

  //Instanciamos los focusNode para poder hacer referencia al foco de cada FormField
  late FocusNode tlf, dni, contrasenia, confirmcontrasenia, nombre, apellido;

  //Instanciamos una key para cada uno de los FormField, para poder verificar los campos
  final _dniKey = GlobalKey<FormFieldState>();
  final _tlfKey = GlobalKey<FormFieldState>();
  final _contraseniaKey = GlobalKey<FormFieldState>();
  final _confirmcontraseniaKey = GlobalKey<FormFieldState>();
  final _nombreKey = GlobalKey<FormFieldState>();
  final _apellidoKey = GlobalKey<FormFieldState>();

  //Declaramos el checkBox para mantener la sesion iniciada (false/desmarcado por defecto)
  bool checkBoxValue = false;

  //Validamos los campos al perder y recuperar el foco en el FormField
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

    //Validamos campos
    dni.addListener(() {
      if (dni.hasFocus || !dni.hasFocus) {
        _dniKey.currentState?.validate();
      }
    });
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
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 20.0, right: 20.0),
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
                        labelText(null, "Datos Personales", Colors.white,
                            Colors.white),

                        //Creamos el formulario donde estableceremmos el contenido de este
                        //Llamamos a los métodos encargados de añadir los campos y el botón de submit
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
            ),
          ),
        ],
      ),
    );
  }

//-------------------------------------------------------------------------------------------------------------------------

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
  button(_formKey, text, colorButton, colorElem) {
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
                        onPressed: () => checkValues(_formKey, context),
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
                        onPressed: () => clear(),
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
                        Text('¡ADVERTENCIA!',
                            style: TextStyle(
                                fontFamily: 'Roboto', color: Colors.red))
                      ],
                    ),
                    content: const Text(
                      '¿Esta seguro de que desea eliminar la cuenta? No podrá recuperarla una vez eliminada',
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

  checkValues(_formKey, context) {
    _formKey.currentState!.validate();
    Navigator.pop(context);
  }

  deleteAcount(context) {
    Navigator.pop(context);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const InfoCofradeScreen()),
        (route) => false);
  }

  clear() {
    setState(() {
      _dniText.text = "";
      _tlfText.text = "";
      _contraseniaText.text = "";
      _confirmcontraseniaText.text = "";
      _nombreText.text = "";
      _apellidoText.text = "";
    });
    Navigator.of(context).pop();
  }
}
