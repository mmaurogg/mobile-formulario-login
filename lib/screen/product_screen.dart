import 'package:flutter/material.dart';
import 'package:formularios_app/widgets/widgets.dart';

import '../ui/input_decorations.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            Stack(
              children: [
                ProductImage(),
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new_outlined, size: 40, color: Colors.white,),
                    )
                ),

                Positioned(
                    top: 60,
                    right: 20,
                    child: IconButton(
                      onPressed: () {
                        //TODO: camara o galeria
                      },
                      icon: Icon(Icons.camera_alt_outlined, size: 40, color: Colors.white,),
                    )
                )
              ],
            ),

            _ProductForm(),

            SizedBox(height: 100,)

          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.save_outlined),
        onPressed: () {

        },
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10 ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20 ),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          child: Column(
            children: [
              SizedBox(height: 10,),

              TextFormField(
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Nombre del producto',
                    labelText: 'Nombre:'),
              ),

              SizedBox(height: 30,),

              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '\$150',
                    labelText: 'Precio:'),
              ),

              SizedBox(height: 30,),

              SwitchListTile.adaptive(
                value: true,
                title: Text('Disponible'),
                activeColor: Colors.indigo,
                onChanged: (value) {

                },
              ),


              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0,5),
        blurRadius: 5
      )
    ]
  );
}
