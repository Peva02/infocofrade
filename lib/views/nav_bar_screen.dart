// ignore_for_file: import_of_legacy_library_into_null_saf
import 'package:flutter/material.dart';
import 'package:infocofrade/conection/conector.dart';
import 'package:infocofrade/main.dart';
import 'package:infocofrade/views/itinerario_screen.dart';
import 'package:infocofrade/views/profile_screen.dart';
import 'package:infocofrade/views/qr_code_screen.dart';
import '../models/hermano_model.dart';
import '../models/qr_model.dart';

class Navegation extends StatefulWidget {
  const Navegation(this.hermano, {Key? key}) : super(key: key);
  final Hermano hermano;

  @override
  State<Navegation> createState() => _Navegation();
}

class _Navegation extends State<Navegation> {
  late Hermano hermano;
  Qr qrCode = Qr();

  Conector conector = Conector();
  @override
  void initState() {
    super.initState();
    hermano = widget.hermano;
  }

  int _selectedDrawItem = 2;

  ///Dependiendo de la opción seleccionada, carga la pantalla seleccionada en el body de esta pantalla
  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return Profile(hermano);
      case 1:
        return QR(hermano.idHermano.toString());
      case 2:
        return const Itinerario();
    }
  }

  ///Cambia la opcion seleccionada y cierra el menu de navegación
  _onSelectedItem(int pos) {
    setState(() {
      if (_selectedDrawItem != pos) {
        _selectedDrawItem = pos;
      }
    });
    Navigator.of(context).pop();
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
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(
                Icons.menu_open,
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),

      endDrawer: SizedBox(
        width: 225,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  hermano.nombre.toString() +
                      " " +
                      hermano.apellidos.toString(),
                  style: const TextStyle(fontFamily: 'Roboto'),
                ),
                accountEmail: null,
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                      child: Image.asset(
                    "assets/images/icono.png",
                    height: 90,
                  )),
                ),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://fundeu.do/wp-content/uploads/2018/03/Semana-Santa-1.jpg'),
                      opacity: 0.8,
                      colorFilter:
                          //hue, multiply
                          ColorFilter.mode(
                              Colors.blueAccent, BlendMode.darken)),
                ),
              ),

              ///Al hacer click sobre cada elemento de la lista llama al metodo _onSelectedItem
              ///y cambia la vista de la pantalla
              ListTile(
                  iconColor: Colors.green.shade700,
                  leading: const Icon(Icons.account_circle),
                  title: const Text('Perfil'),
                  onTap: () => showProfileOption(context)),
              ListTile(
                iconColor: Colors.black,
                leading: const Icon(Icons.qr_code_rounded),
                title: const Text('QR'),
                onTap: () => _onSelectedItem(1),
              ),
              ListTile(
                iconColor: Colors.blue,
                leading: const Icon(Icons.calendar_month),
                title: const Text('Itinerario'),
                onTap: () => _onSelectedItem(2),
              ),

              ListTile(
                  title: const Text('Salir'),
                  iconColor: Colors.red,
                  leading: const Icon(Icons.logout),
                  onTap: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const MyHomePage()),
                      (route) => false)),
            ],
          ),
        ),
      ),

      //El body muestra la pantalla que devuelve el metodo _getNavegationItemWidget
      body: _getDrawerItemWidget(_selectedDrawItem),
    );
  }

  ///Comprueba que el usuario no sera anónimo, en cuyo caso no podra abrir la pantalla de "Perfil"
  showProfileOption(context) {
    if (canLog == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.amber,
          content: Row(
            children: const [
              Icon(
                Icons.sentiment_dissatisfied,
                size: 40,
                color: Colors.white,
              ),
              Expanded(
                child: Text(
                  'Inicie sesión para accerder a su perfil',
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
      _onSelectedItem(0);
    }
  }
}
