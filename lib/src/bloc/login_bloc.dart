import 'dart:async';

import 'package:formulariobloc/src/bloc/validators.dart';

import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {
  
  final _emailController = BehaviorSubject<String>();
  final _passController  = BehaviorSubject<String>();
  
  // Recuperar los datos del Stream
  Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
  Stream<String> get passStream  => _passController.stream.transform(validarPass);
  
  Stream<bool> get validarDatosStream => CombineLatestStream.combine2(emailStream, passStream, (e, p) => true);
  
  // Insertar valores al stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePass  => _passController.sink.add;
  
  // Hago un geteer para el stream obteniendo el ultimo valor ingresado
  
  String get email => _emailController.value;
  String get pass  => _passController.value;
  
  
  dispose() {
    _emailController?.close();
    _passController?.close();
  }
  
  
}