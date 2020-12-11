import 'dart:convert';

import 'dart:io';
import 'package:formulariobloc/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;

import 'package:formulariobloc/src/Models/producto_model.dart';

class ProductosProvider {
  final String _url = 'https://flutter-formbloc.firebaseio.com';
  
  final _prefs = new PreferenciasUsuario();

  Future<bool> crearProducto(ProductoModel producto) async {
    
    final url = '$_url/productos.json?auth=${_prefs.token}';

    final resp = await http.post(url, body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    
    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';

    final resp = await http.put(url, body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    
    final url = '$_url/productos.json?auth=${_prefs.token}';

    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    // Creo una variable producto donde va a ir la lista tmporarl
    final List<ProductoModel> productos = new List();

    if (decodedData == null) return [];
    
    if(decodedData['error'] != null) return [];
    
    print(decodedData);

    decodedData.forEach((id, producto) {
      // Uso el constructor para crear el listado con sus indices
      final productoTemporal = ProductoModel.fromJson(producto);

      // Como el id esta afuera se lo agrego de forma manual
      productoTemporal.id = id;

      productos.add(productoTemporal);
    });

    // print(productos);

    return productos;
  }

  Future<int> borrarProducto(String id) async {
    final url = '$_url/productos/$id.json?auth=${_prefs.token}';

    final resp = await http.delete(url);

    print(resp);

    return 1;
  }
  
  Future<String> subirImagen(File imagen) async {
    
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dsrjbpyoy/image/upload?upload_preset=yxzrrj0f');
    
    final mimeType = mime(imagen.path).split("/");
    
    final imageUploadRequest = http.MultipartRequest('POST', url);
    
    final file = await http.MultipartFile.fromPath(
      'file',
      imagen.path,
      contentType: MediaType(mimeType[0], mimeType[1] ) 
    );
    
    imageUploadRequest.files.add(file);
    
    final streamResoponse = await imageUploadRequest.send();
    
    final resp = await http.Response.fromStream(streamResoponse);
    
    if(resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo Salio mal..');
      print(resp.body);
      return null;
    }
    
    final respData = json.decode(resp.body);
    
    return respData['secure_url'];  
    
  }
}