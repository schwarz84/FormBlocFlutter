
import 'dart:convert';

import 'package:formulariobloc/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {
  
  final String _firebaseToken = 'AIzaSyBs7K87W8zET88n_NpB5FhD_75bruynR6A';
  
  final _prefs = new PreferenciasUsuario();
  
  Future<Map<String, dynamic>> login(String email, String pass) async {
    
    final authData = {
      'email' : email,
      'password'  : pass,
      'returnSecureToken' : true      
    };
    
    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
      body: json.encode(authData),
    );
    
    Map<String, dynamic> decodeResp = json.decode(resp.body);
    
    print(decodeResp);
    
    if (decodeResp.containsKey('idToken')) {
      // ignore: todo
      // TODO: Hacer que guarde los cambios
      
      _prefs.token = decodeResp['idToken'];
      return {'ok' : true};
    } else {
      
      return {'ok': false, 'mensaje' : decodeResp['error']['message']};
    }
  }
  
  Future<Map<String, dynamic>> nuevoUsuario(String email, String pass) async {
    
    final authData = {
      'email' : email,
      'password'  : pass,
      'returnSecureToken' : true      
    };
    
    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
      body: json.encode(authData),
    );
    
    Map<String, dynamic> decodeResp = json.decode(resp.body);
    
    print(decodeResp);
    
    if (decodeResp.containsKey('idToken')) {
      // ignore: todo
      // TODO: Hacer que guarde los cambios
      
      _prefs.token = decodeResp['idToken'];
      return {'ok' : true};
    } else {
      
      return {'ok': false, 'mensaje' : decodeResp['error']['message']};
    }
  }
}