import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:formularios_app/models/models.dart';


class ProductsService extends ChangeNotifier {

  final String _baseUrl =  'shop-store-15e28-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;

  final storage = new FlutterSecureStorage();

  bool isLoading = true;
  bool isSaving = false;

  File? newPictureFile;

  ProductsService(){
    loadProducts();
  }

  Future loadProducts() async {

    isLoading = true;
    notifyListeners();

    // mandar las llaves con {} los headers o querys se mace con el arg map
    final url = Uri.https(_baseUrl, 'products.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    final resp = await http.get( url );

    final Map<String, dynamic> productsMap = json.decode( resp.body);

    //Necesito barrer las respuesta para convertir de map a list
    productsMap.forEach((key, json) {
      final tempProduct = Product.fromMap(json);
      tempProduct.id = key;
      products.add( tempProduct );
    });


    isLoading = false;
    notifyListeners();

    return products;
    
    
  }

  Future saveOrCreateProduct( Product product ) async {
    isSaving = true;
    notifyListeners();

    if ( product.id == null){
      await createProduct( product );
    } else {
      await updateProduct(product);
    }


    isSaving = false;
    notifyListeners();

  }


  Future<String> updateProduct( Product product ) async {
    final url = Uri.https(_baseUrl, 'products/${ product.id }.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    final resp = await http.put( url, body: product.toJson() );
    final decodedData = resp.body;

    // conocer indice
    final index = products.indexWhere((element) => element.id == product.id );
    products[index] = product;

    return product.id!;

  }

  Future<String> createProduct( Product product ) async {
    final url = Uri.https(_baseUrl, 'products.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    final resp = await http.post( url, body: product.toJson() );
    final decodedData = jsonDecode( resp.body );

    product.id = decodedData['name'];

    products.add(product);

    return product.id!;

  }

  // se usa para mostrar la imagen seleccionada sin guardarla
  void updateSelectedProductImage( String path){

    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if(newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dglciigcq/image/upload?upload_preset=txwaxpuw');
    // creamos la petición
    final imageUploadRequest = http.MultipartRequest('PUT', url);
    // adjuntamos el file
    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path );

    imageUploadRequest.files.add(file);
    //realizar la peticion
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if( resp.statusCode != 200 && resp.statusCode != 201){
      print('Algo salió mal');
      print( resp.body );
      return null;
    }

    newPictureFile = null;

    final decodeData = json.decode(resp.body);
    print(resp.body);
    return decodeData['secure_url'];

  }


}