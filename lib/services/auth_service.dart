// Documentación web Fire Base: https://firebase.google.com/docs/reference/rest/auth#section-create-email-password

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;


class AuthService extends ChangeNotifier {

  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyAaorKLscdL-xz-erpVWkEzBufb9HZ0E4I';

  final storage = new FlutterSecureStorage();

  //La funcion devuelve un null a menos que haya un error (devuelve el error)
  Future<String?> createUser( String email, String password ) async {

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode( resp.body );


    if ( decodedResp.containsKey('idToken')) {
      //Guardar token en un Secure Storage
      await storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }

    //TODO: despues de validado el token mandarlo al backend para confirmar si es valido

  }


  Future<String?> login( String email, String password ) async {

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode( resp.body );

    if ( decodedResp.containsKey('idToken')) {
      await storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }

  }


  Future logOut() async {
    await storage.delete(key: 'token');
    return;
  }

}