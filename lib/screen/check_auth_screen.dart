import 'package:flutter/material.dart';
import 'package:formularios_app/screen/screens.dart';
import 'package:formularios_app/services/services.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.readToken(),
          builder: (context, AsyncSnapshot<String> snapshot) {

            Future.microtask(() async  {

              await authService.readToken().then((resp) {

                if (resp.isNotEmpty && resp != null) {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => HomeScreen(),
                        transitionDuration: Duration(seconds: 0),
                      ));
                } else {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => LoginScreen(),
                        transitionDuration: Duration(seconds: 0),
                      ));
                }
              }
              );


            });


            return Container();
            
          },
        )
      )
    );

  }

}
