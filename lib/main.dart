import 'package:flutter/material.dart';

import 'package:formulariobloc/src/bloc/provider.dart';

import 'package:formulariobloc/src/pages/home_page.dart';
import 'package:formulariobloc/src/pages/login_page.dart';
import 'package:formulariobloc/src/pages/registro_page.dart';
import 'package:formulariobloc/src/pages/producto_pages.dart';
import 'package:formulariobloc/src/preferencias_usuario/preferencias_usuario.dart';
 
void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final prefs = new PreferenciasUsuario();
    print(prefs.token);
    
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Formulario',
        initialRoute: 'login',
        routes: {
          'home'     : (BuildContext context) => HomePage(),
          'login'    : (BuildContext context) => LoginPage(),
          'registro' : (BuildContext context) => RegistroPage(),
          'producto' : (BuildContext context) => ProductoPage(),
        },
        theme: ThemeData(
          primaryColor: Color.fromRGBO(0, 56, 4, 1.0),
          hintColor: Color.fromRGBO(100, 99, 0, 0.5),
          focusColor: Color.fromRGBO(0, 56, 4, 1.0),
          unselectedWidgetColor: Color.fromRGBO(0, 56, 4, 1.0),
        ),
      )
    );
    
    
    
  }
}

