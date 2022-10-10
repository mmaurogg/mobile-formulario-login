import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formularios_app/provider/provider.dart';
import 'package:formularios_app/services/services.dart';
import 'package:formularios_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../ui/input_decorations.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final productService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: ( _ ) => ProductFormProvider(productService.selectedProduct),
      child: _ProductScreenBody(productService: productService),

    ) ;
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {

    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag ,
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage( url: productService.selectedProduct.picture ),

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
                      onPressed: () async {
                        //TODO: menu para subir o tomar foto
                        final ImagePicker _picker = ImagePicker();
                        // Pick an image
                        //final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                        // Capture a photo
                        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 100);

                        if (pickedFile == null) {
                          print('No hay seleccion');
                          return;
                        }

                        productService.updateSelectedProductImage( pickedFile.path);

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
        child:  productService.isSaving
          ? CircularProgressIndicator(color: Colors.white,)
          : Icon( Icons.save_outlined),
        onPressed: productService.isSaving
        ? null
        : () async {

            if ( !productForm.isValidForm() ) return ;

            final String? imageUrl = await productService.uploadImage();

            if( imageUrl != null ){
              productForm.product.picture = imageUrl;
            }

            await productService.saveOrCreateProduct(productForm.product);
            //    .then( (_) => Navigator.pop(context));

            //Navigator.pop(context);

            //TODO: mensaje que se guardó correctamente

          },
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10 ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20 ),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 10,),

              TextFormField(
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                validator: (value) {
                  if(value == null || value.length < 1)
                    return 'El nombre es obligatorio';
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Nombre del producto',
                    labelText: 'Nombre:'),
              ),

              SizedBox(height: 30,),

              TextFormField(
                initialValue: '${product.price}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: (value) {
                  if( double.tryParse(value) == null){
                    product.price = 0;
                  } else {
                    product.price = double.parse(value);
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '\$xxx.xx',
                    labelText: 'Precio:'),
              ),

              SizedBox(height: 30,),

              SwitchListTile.adaptive(
                value: product.available,
                title: Text('Disponible'),
                activeColor: Colors.indigo,
                onChanged: productForm.updateAvailability,
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
