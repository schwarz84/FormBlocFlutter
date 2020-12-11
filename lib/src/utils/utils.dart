

import 'package:flutter/material.dart';

bool esNumero(String valor) {
  
  if ( valor.isEmpty) return false;
  
  final numero = num.tryParse(valor);
  
  return (numero == null) ? false : true;
  
}

void mostrarSnackbar(String mensaje, BuildContext context, GlobalKey<ScaffoldState> keyScaffold) {
    
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
      backgroundColor: Theme.of(context).primaryColor,
    );
    
    keyScaffold.currentState.showSnackBar(snackbar);
    
}

void mostrarAlerta(BuildContext context, String message) {
  
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Informacion Incorrecta'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    }
  );
}

String validarIgualdad(String mensaje1, String mensaje2) {
  if (mensaje1 == mensaje2) {
    return 'Perfecto!!';
  } else {
    return 'La confirmacion debe seri igual a la clave';
  }
}

// HACER: una alerta de que esta cargando 
// void imagenCrgando() {
  
//   Timer(Duration(milliseconds: 2000), (){
//     FadeTransition(
//       opacity: 1.
//     );
//   });
  
// }