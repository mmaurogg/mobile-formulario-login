import 'package:flutter/material.dart';

class NotificationsService {

  // me servira para mantener la referencia con el MaterialApp en el main
  static GlobalKey<ScaffoldMessengerState> messengerKey = new GlobalKey<ScaffoldMessengerState>();

  static showSnackbar( String message ){
    final snackBar = new SnackBar(
      content: Text( message, style: TextStyle(color: Colors.white, fontSize: 20)),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
    );

    messengerKey.currentState!.showSnackBar(snackBar);
  }

}