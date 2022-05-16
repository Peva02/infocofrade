import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'elements_generator.dart';

class QR extends StatefulWidget {
  const QR({Key? key}) : super(key: key);

  @override
  State<QR> createState() => _QRState();
}

class _QRState extends State<QR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 500,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      controller: null,
                      primary: false,
                      children: [
                        SizedBox(
                          width: 400,
                          child: Column(
                            children: [
                              labelText(null, "Datos de hermano", Colors.white,
                                  Colors.white),
                              Card(
                                  child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      (DateTime.now().year - 1).toString() +
                                          '-' +
                                          DateTime.now().year.toString(),
                                      style: const TextStyle(
                                          fontFamily: 'title_font',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  dato("Usuario: ", "Usuario 1"),
                                  dato("Cofradía: ", "Cofradía 1"),
                                  dato("Antigüedad: ", "3 Años"),
                                  dato("Posición de salida: ", "Monaguillo"),
                                ],
                              )),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 400,
                          child: Column(
                            children: [
                              labelText(
                                  null, "Código", Colors.white, Colors.white),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Card(
                                    child: QrImage(
                                  data: 'Año:' +
                                      (DateTime.now().year - 1).toString() +
                                      '-' +
                                      DateTime.now().year.toString() +
                                      '\n'
                                          'Usuario: ...\n'
                                          'Cofradia: ...\n'
                                          'Antigüedad: ...\n'
                                          'Posicion de salida: ...',
                                  version: QrVersions.auto,
                                  gapless: true,
                                )),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Padding dato(String titulo, String contenido) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              titulo,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              contenido,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
