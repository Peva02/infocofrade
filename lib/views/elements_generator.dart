import 'package:flutter/material.dart';

//Crea un divisor del color que se le indique que ocupara todo el ancho posible

divisor(lineColor) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    children: [
      Expanded(
        child: Container(
          margin: const EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
          height: 2.0,
          color: lineColor,
        ),
      ),
    ],
  );
}

//-------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------------------

//Crea un divisor del color que se le indique que ocupara todo el ancho posible

divisorExpanded(lineColor) {
  return Expanded(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, top: 30.0, bottom: 30.0),
          child: SizedBox(
            child: Center(
              child: Container(
                margin: const EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                height: 2.0,
                color: lineColor,
              ),
            ),
          ),
        )
      ],
    ),
  );
}

//-------------------------------------------------------------------------------------------------------------------------

//Es el encargado de mostrar el círculo de carga al usuario cuando realizamos una consulta en base de datos

screenCircularProgress() {
  return Center(
    child: CircularProgressIndicator(
      backgroundColor: Colors.amber.shade700,
      strokeWidth: 5,
    ),
  );
}

//-------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------------------

//Este método es el encargado de validar el número de teléfono, es decir que cumpla con la longitud y que sea numérico

validationTelf(String telefono) {
  RegExp _numeric = RegExp(r'[ -()+]?[0-9]+$');
  if (!_numeric.hasMatch(telefono) ||
      telefono.length < 9 ||
      telefono.length > 17) {
    return false;
  }
  return true;
}

validationDni(String dni) {
  var regExp = RegExp(r'^[\d]{8}[A-Za-z]{1}$');
  if (regExp.hasMatch(dni)) {
    return true;
  }
  return false;
}
//-------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------------------

///Este método se encarga de validar el texto de la base de datos, si este está vacío lo sustituye por un texto por defecto
validationText(String input) {
  if (input.trim().isEmpty || input == 'null') {
    input = 'N/A';
  }
  return input;
}

//-------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------------------

// Devolvera los divisores de cada seccion, mostrando
// el nombre que se le pases por parametro junto con un divisor del color que se le indique
labelText(icon, text, colorText, colorLine) => Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: icon,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 18, fontFamily: 'title_font', color: colorText),
        ),
        divisorExpanded(colorLine),
      ],
    );

//-------------------------------------------------------------------------------------------------------------------------