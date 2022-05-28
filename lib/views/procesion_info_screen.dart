// ignore_for_file: import_of_legacy_library_into_null_safe,
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infocofrade/dbExterna/conector.dart';
import 'package:infocofrade/models/procesion_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'elements_generator.dart';

class ProcesionInfo extends StatefulWidget {
  const ProcesionInfo(this.procesion, {Key? key}) : super(key: key);
  final Procesion procesion;

  @override
  State<ProcesionInfo> createState() => _ProcesionInfo();
}

class _ProcesionInfo extends State<ProcesionInfo> {
  late final Procesion procesion;
  static double latitud = 0.0, altitud = 0.0;
  static LatLng _coordenadas = LatLng(latitud, altitud);
  final Completer<GoogleMapController> _controller = Completer();
  Conector db = Conector();

  //Declaramos la posición inicial de la cámara en el mapa
  CameraPosition _kGooglePlex = CameraPosition(
    target: _coordenadas,
    zoom: 16,
  );

  //Decalramos un marcador para indicar el punto donde nos encontramos
  //y añadir la localización de la procesión
  final Set<Marker> _markers = {};
  late final Timer perdirLocalizacion;

  void _onMapCreated() {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('id-1'),
          position: _coordenadas,
          infoWindow: InfoWindow(
            title: "Localización",
            snippet: procesion.nombre.toString(),
          ),
        ),
      );
    });
  }

  @override
  initState() {
    super.initState();
    procesion = widget.procesion;
    //Intenta asignar los valores de altitud y latitud de la procesión a los
    //valores de la cámara, en caso de no poder hacerlo, dejará los valores en
    //cero, y diremos que no se pudo obtener localización.
    try {
      latitud = double.parse(procesion.latitud!);
      altitud = double.parse(procesion.altitud!);
      _coordenadas = LatLng(latitud, altitud);
      _kGooglePlex = CameraPosition(
        target: _coordenadas,
        zoom: 16,
      );
    } catch (e) {
      latitud = 0;
      altitud = 0;
    }
    perdirLocalizacion = Timer.periodic(const Duration(seconds: 1), (timer) {
      getPosition();

      setState(() {});
    });
    _onMapCreated();
  }

  @override
  void dispose() {
    super.dispose();
    perdirLocalizacion.cancel();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
        body: RefreshIndicator(
          onRefresh: () async {},
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Center(
                child: SizedBox(
                  width: 1000,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Column(
                              children: [
                                datos(),
                              ],
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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            callCofradia();
          },
          backgroundColor: Colors.amber.shade800,
          child: const Icon(Icons.call),
        ),
      );

  ///Devuelve un contendor con los datos de la procesión
  Column datos() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Text(
              validationText(procesion.nombre.toString()),
              style: const TextStyle(
                  fontSize: 25, color: Colors.white, fontFamily: "title_font"),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: procesion.urlImagen.toString(),
                    imageBuilder: (context, imageProvider) => Container(
                      width: MediaQuery.of(context).size.height / 3,
                      height: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.fill),
                      ),
                    ),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.church_rounded,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Wrap(
            runSpacing: 5,
            children: [
              labelText(
                  const Icon(
                    Icons.church_rounded,
                    color: Colors.amber,
                  ),
                  'Iglesia',
                  Colors.white,
                  Colors.white),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      validationText(procesion.iglesia.toString()),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              labelText(
                  const Icon(
                    Icons.description_rounded,
                    color: Colors.white,
                  ),
                  'Descripción',
                  Colors.white,
                  Colors.white),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      validationText(procesion.descripcion.toString()),
                      maxLines: 15,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
              labelText(
                  const Icon(
                    Icons.map_sharp,
                    color: Colors.orange,
                  ),
                  'Ruta',
                  Colors.white,
                  Colors.white),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    procesion.ruta.toString(),
                    maxLines: 20,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              labelText(
                  const Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                  'Localización',
                  Colors.white,
                  Colors.white),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: googleMaps()),
              ),
            ],
          ),
        ],
      );

  ///Abre el telefono de nuestro dispositivo indicando el numero de la cofradía
  void callCofradia() async {
    if (validationTelf(procesion.telefono.toString())) {
      if (await launchUrl(
          Uri.parse('tel://' + procesion.telefono.toString()))) {}
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.amber.shade700,
          content: Row(
            children: const [
              Icon(
                Icons.warning_amber_rounded,
                size: 40,
                color: Colors.white,
              ),
              Expanded(
                child: Text(
                  'No hay telefono disponible.',
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
              bottom: MediaQuery.of(context).size.height - 172,
              right: 20,
              left: 20),
        ),
      );
    }
  }

  ///Comprueba si existen datos de localización de la procesión; si existen,
  ///devolvera la posicion, en caso contrario(0,0), devolvera un mensaje de error

  Widget googleMaps() {
    if (procesion.latitud != '0' && procesion.altitud != '0') {
      return GoogleMap(
        markers: _markers,
        myLocationEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      );
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.location_off_outlined,
                size: 100,
                color: Colors.red,
              ),
              Text(
                'Error:',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'title_font',
                    fontSize: 24),
              ),
              Text(
                'No se pudo localizar esta cofradía',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14),
              )
            ],
          ),
        ),
      );
    }
  }

  getPosition() async {
    final GoogleMapController controller = await _controller.future;
    await db
        .getLocationProcesion(procesion.idCofradia.toString())
        .then((value) {
      procesion.latitud = value[1].toString();
      procesion.altitud = value[0].toString();
    });
    try {
      latitud = double.parse(procesion.latitud!);
      altitud = double.parse(procesion.altitud!);
      _markers.clear();
      _coordenadas = LatLng(latitud, altitud);
      _markers.add(
        Marker(
          markerId: const MarkerId('id-1'),
          position: _coordenadas,
          infoWindow: InfoWindow(
            title: "Localización",
            snippet: procesion.nombre.toString(),
          ),
        ),
      );
      _kGooglePlex = CameraPosition(
        target: _coordenadas,
        zoom: 16,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
    } catch (e) {
      null;
    }
    setState(() {});
  }
}
