import 'dart:async';

class Validators {
  
  
  
  final validarEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      
      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      
      RegExp regExp = new RegExp(pattern);
      
      if (regExp.hasMatch(email) ) {
        sink.add(email);
      } else {
        sink.addError('El Correo no es Valido');
      }
      
    }
  );
  
  final validarPass = StreamTransformer<String, String>.fromHandlers(
    handleData: (pass, sink) {
      
      Pattern passValido = r'^(?=\w*\d)(?=\w*[A-Z])(?=\w*[a-z])\S{8,16}$';
      
      RegExp regExp = new RegExp(passValido);
      
      if (regExp.hasMatch(pass)) {
        sink.add(pass);
      } else {
        sink.addError('La clave debe tener al menos 8 caracteres, alfanumerica y Mayusculas');
      }
    }
  );
    
  
  
  
  
}