import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:formularios_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {

  final String _baseUrl =  'shop-store-15e28-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;

  bool isLoading = true;
  bool isSaving = false;

  ProductsService(){
    loadProducts();
  }

  Future loadProducts() async {

    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json');
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

  Future saveOrCreateProdut( Product product ) async {
    isSaving = true;
    notifyListeners();

    if ( product.id == null){
      // TODO: crear
    } else {
      await updateProduct(product);
    }


    isSaving = false;
    notifyListeners();

  }


  Future<String> updateProduct( Product product ) async {
    final url = Uri.https(_baseUrl, 'products/${ product.id }.json');
    final resp = await http.put( url, body: product.toJson() );
    final decodedData = resp.body;

    // conocer indice
    final index = products.indexWhere((element) => element.id == product.id );
    products[index] = product;

    return product.id!;

  }



}