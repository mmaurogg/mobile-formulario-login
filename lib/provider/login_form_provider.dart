import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {

  // conectar el form con el provider a travez de la key
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading (bool value){
    _isLoading = value;
    notifyListeners();
  }


  bool isValidform(){
    print(formKey.currentState?.validate());
    print('$email - $password');
    return formKey.currentState?.validate() ?? false;
  }

}