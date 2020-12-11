import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:formulariobloc/src/bloc/provider.dart';
import 'package:formulariobloc/src/Models/producto_model.dart';
import 'package:formulariobloc/src/utils/utils.dart' as Utils;

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final keyForm = GlobalKey<FormState>();
  final keyScaffold = GlobalKey<ScaffoldState>();
  
  ProductosBloc productosBloc;
 
  ProductoModel producto = new ProductoModel();
  
  bool _guardando = false;
  
  File foto;

  @override
  Widget build(BuildContext context) {
    
    final ProductoModel prodArg = ModalRoute.of(context).settings.arguments;

    if (prodArg != null) {
    
      producto = prodArg;
    }

    return Scaffold(
      key: keyScaffold,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _buscarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _sacarFoto,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: keyForm,
          child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearProducto(), 
                _crearPrecio(), 
                _crearDisponible(), 
                _cargarProducto(context)]),
        ),
      ),
    );
  }

  Widget _crearProducto() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Nombre',
      ),
      validator: (value) => (value.length < 3 ? 'Nombre demasiado pequeño para un porducto' : null),
      initialValue: producto.titulo,
      onSaved: (value) => producto.titulo = value,
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Precio'),
      validator: (value) => (Utils.esNumero(value) ? null : 'El valor ingresado no es un número'),
      initialValue: producto.valor.toString(),
      onSaved: (value) => producto.valor = double.parse(value),
    );
  }

  Widget _cargarProducto(BuildContext context) {
    return RaisedButton.icon(
      icon: Icon(Icons.save),
      label: Text('Guardar'),
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      title: Text('Disponible'),
      value: producto.disponible,
      activeColor: Theme.of(context).primaryColor,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  void _submit() async {
    if (!keyForm.currentState.validate()) return;

    // Siempre despues de la validacion
    keyForm.currentState.save();

    setState(() {
      _guardando = true;
    });
    
    if (foto != null) {
      producto.fotoUrl = await productosBloc.subirFoto(foto);
    }
    
    if (producto.id == null) {
      productosBloc.agregarProducto(producto);
      Utils.mostrarSnackbar('El Producto se Guardo Exitosamente', context, keyScaffold);
    } else {
      productosBloc.editarProducto(producto);
      Utils.mostrarSnackbar('El Porducto se Edito Exitosamente', context, keyScaffold); 
    }
    
    Timer(Duration(milliseconds: 2000), () {
      setState(() {
        Navigator.pop(context);
      });
    });
  }
  
  
  Widget _mostrarFoto() {
    
    if(producto.fotoUrl != null) {
 
      return FadeInImage(
        
        image: NetworkImage(producto.fotoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {

      return Image(
        
        image: (foto == null ? AssetImage('assets/no-image.png') : FileImage(File(foto.path))),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }
  
  _buscarFoto() {
    
    _procesarFoto(ImageSource.gallery);
  }
  
  _sacarFoto() {
    
    _procesarFoto(ImageSource.camera);
  }
  
  _procesarFoto(ImageSource origen) async {
    
    final _picker = ImagePicker();
    final pickedFoto = await _picker.getImage(
      source: origen,
    );
    
    foto = File(pickedFoto.path);
    
    if(foto != null) {
      producto.fotoUrl = null;
    }
    
    setState(() {});
  }
}
