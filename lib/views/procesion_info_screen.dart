// ignore_for_file: import_of_legacy_library_into_null_safe,
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infocofrade/models/procesion.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'elements_generator.dart';

class ProcesionInfo extends StatefulWidget {
  const ProcesionInfo(this.procesion, {Key? key}) : super(key: key);
  final Procesion procesion;

  @override
  State<ProcesionInfo> createState() => _ProcesionInfo();
}

//Creamos el controlador para obtener el texto del centro buscado

class _ProcesionInfo extends State<ProcesionInfo> {
  late final Procesion procesion;

  //Declaramos las variables de altitud y latitud que dependeran según la posición del centro
  static double latitud = 0.0, altitud = 0.0;
  static LatLng _coordenadas = LatLng(latitud, altitud);

  //Declaramos la posición inicial de la cámara
  CameraPosition _kGooglePlex = CameraPosition(
    target: _coordenadas,
    zoom: 16,
  );

  //Decalramos un marcador para indicar el punto donde nos encontramos
  //y añadir el nombre y dirección del centro
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('id-1'),
          position: _coordenadas,
          infoWindow: InfoWindow(
            title: "Iglesia",
            snippet: procesion.iglesia.toString(),
          ),
        ),
      );
    });
  }

  @override
  initState() {
    super.initState();
    procesion = widget.procesion;
    if (procesion.latitud != null && procesion.altitud != null) {
      setState(() {
        latitud = double.parse(procesion.latitud!);
        altitud = double.parse(procesion.altitud!);
        _coordenadas = LatLng(latitud, altitud);
        _kGooglePlex = CameraPosition(
          target: _coordenadas,
          zoom: 16,
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.amber,
          content: Row(
            children: const [
              Icon(
                Icons.warning_amber_rounded,
                size: 40,
                color: Colors.white,
              ),
              Expanded(
                child: Text(
                  'No hay localización disponible.',
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
      setState(() {
        latitud = 0;
        altitud = 0;
        _coordenadas = LatLng(latitud, altitud);
        _kGooglePlex = CameraPosition(
          target: _coordenadas,
          zoom: 16,
        );
      });
    }
  }

  //-------------------------------------------------------------------------------------------------------------------------

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
        //Centraremos todo el contenido de la pantalla
        body: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Center(
            child: SizedBox(
              width: 1000,
              child: Column(
                children: [
                  //ListView que ocupara el resto de la pantalla con los datos del centro
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        setState(() {});
                      },
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
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            callprocesion();
          },
          backgroundColor: Colors.amber.shade800,
          child: const Icon(Icons.call),
        ),
      );

  //-------------------------------------------------------------------------------------------------------------------------

  ///Devuelve un contendor con los datos principales del centro
  Column datos() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
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
                          )),
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
                    child: SelectableText(
                      validationText(procesion.descripcion.toString()),
                      maxLines: 2,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
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
                    textAlign: TextAlign.justify,
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
                  child: GoogleMap(
                    markers: _markers,
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _onMapCreated(controller);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  //-------------------------------------------------------------------------------------------------------------------------
  ///Este método es el encargado de lanzar las url que le pasemos, devolviendo un error si no es válida
  void _launchURL(String url) async {
    try {
      if (!await launchUrl(Uri.parse(url))) {}
    } catch (e) {
      //print("error");
    }
  }

  ///Abre el telefono de nuestro dispositivo indicando el numero del centro
  void callprocesion() {
    if (validationTelf(procesion.telefono.toString()) != 'N/A') {
      _launchURL(
        'tel://' + procesion.telefono.toString(),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.amber,
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
              bottom: MediaQuery.of(context).size.height - 100,
              right: 20,
              left: 20),
        ),
      );
    }
  }
}
