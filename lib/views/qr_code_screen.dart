import 'package:flutter/material.dart';
import 'package:infocofrade/conection/conector.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/qr_model.dart';
import 'elements_generator.dart';

class QR extends StatefulWidget {
  const QR(this.idHermano, {Key? key}) : super(key: key);
  final String idHermano;
  @override
  State<QR> createState() => _QRState();
}

class _QRState extends State<QR> {
  Qr qrCode = Qr();
  late String idHermano;
  Conector conector = Conector();

  @override
  void initState() {
    super.initState();
    idHermano = widget.idHermano;
    conector.getQr(idHermano).then(
      (value) {
        setState(() {
          qrCode = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
        future: conector.getQr(idHermano),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Center(
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
                                  labelText(null, "Datos de hermano",
                                      Colors.white, Colors.white),
                                  Card(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            qrCode.fecha.toString(),
                                            style: const TextStyle(
                                                fontFamily: 'title_font',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ),
                                        dato("Usuario: ",
                                            qrCode.usuario.toString()),
                                        dato("Cofradía: ",
                                            qrCode.cofradia.toString()),
                                        dato("Antigüedad: ",
                                            qrCode.antiguedad.toString()),
                                        dato("Posición de salida: ",
                                            qrCode.posicion.toString()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 400,
                              child: Column(
                                children: [
                                  labelText(null, "Código", Colors.white,
                                      Colors.white),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Card(
                                        child: QrImage(
                                      data: 'Año:' +
                                          qrCode.fecha.toString() +
                                          '\nUsuario: ' +
                                          qrCode.usuario.toString() +
                                          '\nCofradia: ' +
                                          qrCode.cofradia.toString() +
                                          '\nAntigüedad: ' +
                                          qrCode.antiguedad.toString() +
                                          '\nPosicion de salida: ' +
                                          qrCode.posicion.toString(),
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
            );
          } else {
            return screenCircularProgress();
          }
        },
      ),
    );
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
