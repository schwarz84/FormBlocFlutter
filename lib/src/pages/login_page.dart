// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:formulariobloc/src/bloc/provider.dart';
import 'package:formulariobloc/src/providers/usuarios_provider.dart';
import 'package:formulariobloc/src/utils/utils.dart'as Utils;

class LoginPage extends StatelessWidget {
  
  final usuarioProvider = new UsuarioProvider();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context),
        ],
      )
    );
  }
  
  Widget _loginForm(BuildContext context) {
    
    final bloc = Provider.of(context);
    
    final size = MediaQuery.of(context).size;
    
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          
          SafeArea(
            child: Container(
              height: size.height * 0.27,
            )
          ),
          
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
            padding: EdgeInsets.symmetric(vertical: size.height * 0.1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7.0),
              boxShadow: <BoxShadow> [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: size.height * 0.01,
                  offset: Offset(0.0, size.height * 0.002),
                  spreadRadius: size.height * 0.005
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                Text('Ingreso', style: TextStyle(fontSize: size.height * 0.023)),
                SizedBox( height: size.height * 0.03),
                _crearEmail(context, bloc, size),
                SizedBox(height: size.height * 0.015),  
                _crearPass(context, bloc, size),
                SizedBox( height: size.height * 0.05),
                _crearBoton(context, bloc, size)
              ],
            ),
          ),
          FlatButton(
            child: Text("Registrarme"),
            onPressed: () => Navigator.pushReplacementNamed(context, 'registro'),
          ),
          SizedBox(height: size.height * 0.04)
        ],
      ),
    );    
  }
  
  Widget _crearEmail(BuildContext context, LoginBloc bloc, Size size) {
    
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.07 ),
          
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Color.fromRGBO(0, 56, 4, 1.0)),
              hintText: 'ejemplo@ejemplo.com',
              labelText: 'Correo',
              labelStyle: TextStyle(color: Color.fromRGBO(0, 56, 4, 1.0)),
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }
  
  Widget _crearPass(BuildContext context, LoginBloc bloc, Size size) {
    
    return StreamBuilder(
      stream: bloc.passStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Color.fromRGBO(0, 56, 4, 1.0),),
              labelText: 'Password',
              labelStyle: TextStyle(color: Color.fromRGBO(0, 56, 4, 1.0)),
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: (value) => bloc.changePass(value),
          ),
        ); 
      },
    );
  }
  
  Widget _crearBoton(BuildContext context, LoginBloc bloc, Size size) {
    
    // validarDatosStream
    // snapshot.hasData()
    // Ternario
    
    final size = MediaQuery.of(context).size;
      
    return StreamBuilder(
      stream: bloc.validarDatosStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        
        return RaisedButton(
          child: Container(
            child: Text('Ingresar'),
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.2, vertical: size.height * 0.025),
          ),
          color: Color.fromRGBO(0, 56, 14, 1.0),
          textColor: Colors.yellow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0)
          ),
          elevation: 0.0,
          onPressed: snapshot.hasData ? ()=>_login(context, bloc) : null
        );
      },
    );
    
      
    }
    _login(BuildContext context, LoginBloc bloc) async {
      
      Map info = await usuarioProvider.login(bloc.email, bloc.pass);
      
      if (info['ok']) {
        Navigator.pushReplacementNamed(context, 'home');
        
      } else {
        Utils.mostrarAlerta(context, info['mensaje']);
      }
      
    }
  
  
  Widget _crearFondo(BuildContext context) {
    
    final size = MediaQuery.of(context).size;
    
    final fondo = Container(
      height: size.height * 0.4,
      width: size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color.fromRGBO( 0, 56, 4, 1.0),
            Color.fromRGBO( 64, 69, 0, 1.0),
          ],          
        )
      ),
    );
    
    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.07),
        
      ),
    );
    
    final logo = Container(
      padding: EdgeInsets.only(top: size.height * 0.09),
      child: Column(
        children: <Widget>[
          Icon(Icons.person_pin_circle, color: Colors.yellow, size: size.height * 0.12),
          SizedBox(width: size.width, height: size.height * 0.01),
          Text('Carlos Schwarz', style: TextStyle(color: Colors.yellow, fontSize: size.height * 0.04))
        ],
      )
    );
    
    return Stack(
      children: <Widget> [
        
        fondo,
        
        Positioned( child: circulo, top: 10.0, left: 20.0),
        Positioned( child: circulo, bottom: -10.0, left: 170.0),
        Positioned( child: circulo, bottom: 37.0, left: -56.0),
        Positioned( child: circulo, top: 50.0, right: 70.0),
        Positioned( child: circulo, bottom: 20.0, right: -50.0),
        
        logo,
      ]
      
    );
    
    
  }
}