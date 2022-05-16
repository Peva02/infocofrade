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
    telefono = 'N/A';
  }
  return telefono;
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

//-------------------------------------------------------------------------------------------------------------------------

//Método encargado de añadir los elementos la DropDown

/*addDropDown(List<String> items, error, itemSeleccionado, placeholderText) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
    child: DropdownButtonFormField2(
      dropdownMaxHeight: 150.0,
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white),
      isExpanded: true,
      hint: Text(
        placeholderText,
        style: const TextStyle(
            fontSize: 14, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
      ),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      buttonHeight: 60,
      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return error;
        }
        return null;
      },
      onChanged: (value) {
        itemSeleccionado = value.toString();
      },
    ),
  );
}*/

//-------------------------------------------------------------------------------------------------------------------------