import 'package:flutter/material.dart';
import 'package:formularios_app/screen/screens.dart';
import 'package:formularios_app/services/services.dart';
import 'package:formularios_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Leer el product service
    final productService = Provider.of<ProductsService>(context);

    if( productService.isLoading ) return LoadingScreen();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: ListView.builder(
        itemCount: productService.products.length,
        itemBuilder: (context, index) => GestureDetector(
            onTap: () => Navigator.pushNamed(context,'product'),
            child: ProductCard(
              product: productService.products[index],
            )
        ),

      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {

        },
      ),


    );
  }
}
