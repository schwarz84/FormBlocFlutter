import 'package:flutter/material.dart';
import 'package:formulariobloc/src/Models/producto_model.dart';

import 'package:formulariobloc/src/bloc/provider.dart';
// import 'package:formulariobloc/src/providers/productos_provider.dart';
import 'package:formulariobloc/src/utils/utils.dart' as Utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final keyScaffold = GlobalKey<ScaffoldState>();  

  @override
  Widget build(BuildContext context) {

    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();

    return Scaffold(
      key: keyScaffold,
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: _crearListado(productosBloc),
      floatingActionButton: _irProductos(context),
    );
  }

  Widget _crearListado(ProductosBloc productosBloc) {
    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder: (BuildContext contenxt, AsyncSnapshot<List<ProductoModel>> snapshot) {
        
        if (snapshot.hasData) {
          final productos = snapshot.data;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) => _crearItem(context, productos[i], productosBloc),
          );
        } else {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor,
          ));
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductoModel producto, ProductosBloc productosBloc ) {
    
    
    
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Theme.of(context).primaryColor,
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (direccion) {
        productosBloc.borrarProducto(producto.id);
        // ------------------------------------------------------------------
        Utils.mostrarSnackbar('Se Elimino el producto', context, keyScaffold); 
      },
      child: Card(
        child: Column(
          children: <Widget> [
            (producto.fotoUrl == null) 
            ? Image(image: AssetImage('assets/no-image.png'),) 
            : FadeInImage(
              image: NetworkImage(producto.fotoUrl),
              placeholder: AssetImage('assets/jar-loading.gif'),
              height: 300.0, 
              fit: BoxFit.cover,
              width: double.infinity, 
            ),
            ListTile(
              title: Text('${producto.titulo} - ${producto.valor}'),
              subtitle: Text(producto.id),
              onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto).then((value) => setState((){})),
            ),
          ],
        ),
      )
      
      
      
      
      
    );
  }

  Widget _irProductos(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add_box),
      backgroundColor: Color.fromRGBO(0, 56, 14, 1.0),
      onPressed: () => Navigator.pushNamed(context, 'producto').then((value) => setState((){})),
    );
  }
}
