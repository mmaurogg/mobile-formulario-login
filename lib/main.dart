import 'package:flutter/material.dart';
import 'package:formularios_app/screen/screens.dart';
import 'package:formularios_app/services/products_service.dart';
import 'package:formularios_app/services/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp( AppState());
}

class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [

          ChangeNotifierProvider(
            // para que lo lea de product services se inicializara en home screen
            create: (_) => ProductsService(),
            // falso: dispara cuando el prodict service es creado
            // verdadero: cuando se necesite que se llame (está por defecto)
            lazy: true,
          ),
          ChangeNotifierProvider(
            create: (_) => AuthService() )
        ],
      child: MyApp(),
    );
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productos App',
      initialRoute: 'login',
      routes: {
        'login': (_) => LoginScreen(),
        'home': (_) => HomeScreen(),
        'product': (_) => ProductScreen(),
        'register': (_) => RegisterScreen(),
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.indigo,
        ),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          elevation: 0,
        ),
      ),
    );
  }
}

