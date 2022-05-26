import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infocofrade/db/db.dart';
import 'package:infocofrade/dbExterna/conector.dart';
import 'package:infocofrade/models/procesion_model.dart';
import 'package:infocofrade/views/elements_generator.dart';
import 'package:infocofrade/views/procesion_info_screen.dart';

class Itinerario extends StatefulWidget {
  const Itinerario({Key? key}) : super(key: key);

  @override
  State<Itinerario> createState() => _Itinerario();
}

class _Itinerario extends State<Itinerario> {
  final Conector conector = Conector();
  List<Procesion> listaProcesiones = [];
  List<Procesion> sqliteProcesiones = [];

  @override
  void initState() {
    super.initState();

    ///Carga el listado de procesiones de la base de datos
    conector.getProcesiones().then(
      (value) {
        listaProcesiones.addAll(value);

        //Recorre al lista de procesiones obtenidas, y ejecuta un insert
        //en la base de datos local por cada procesion obtenida
        for (var i = 0; i < listaProcesiones.length; i++) {
          DB.insert(listaProcesiones[i]);
        }
      },
    );
    //Una vez cargadas las procesiones, las obtenemos de la base de datos local,
    //y las añadimos a otra lista, de modo que si el usuario en cualquier
    //momento pierde la conexión, podrea seguir accediendo a los datos de las
    //mismas, menos a la imagen y la localizacón(lógicamente, debido a que
    //no cuenta con conexión)
    DB.listProcesioens().then(
      (value) {
        sqliteProcesiones.clear();
        sqliteProcesiones.addAll(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            listaProcesiones.clear();
          });
          await conector.getProcesiones().then((value) {
            setState(() {
              listaProcesiones.addAll(value);
            });
          });
        },
        child: FutureBuilder(
          future: conector.getProcesiones(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: SizedBox(
                  width: 1000,
                  child: ListView.builder(
                    primary: false,
                    itemCount: listaProcesiones.length,
                    itemBuilder: (context, index) {
                      return cargarProcesion(listaProcesiones[index]);
                    },
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: SizedBox(
                  width: 1000,
                  child: ListView.builder(
                    primary: false,
                    itemCount: sqliteProcesiones.length,
                    itemBuilder: (context, index) {
                      return cargarProcesion(sqliteProcesiones[index]);
                    },
                  ),
                ),
              );
            } else {
              return screenCircularProgress();
            }
          },
        ),
      ),
    );
  }

  ///Pasándole una lista de procesiones, la recorre y las muestra
  Padding cargarProcesion(Procesion procesion) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProcesionInfo(procesion)));
              },
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            procesion.nombre!,
                            style: const TextStyle(
                                fontFamily: 'title_font', fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: divisor(Colors.amber.shade800),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              CachedNetworkImage(
                                imageUrl: procesion.urlImagen!,
                                imageBuilder: (context, imageProvider) =>
                                    ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    procesion.urlImagen!,
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.church_rounded,
                                  color: Colors.amber,
                                  size: 100,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.event,
                                      ),
                                      const Text(
                                        "Fecha: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child:
                                              Text(procesion.fecha.toString()),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: divisor(Colors.purple.shade900),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                      ),
                                      const Text(
                                        "Ruta: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            procesion.ruta.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            softWrap: false,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
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
}
