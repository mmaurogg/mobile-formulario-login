
import 'package:flutter/material.dart';
import 'package:formularios_app/provider/login_form_provider.dart';
import 'package:formularios_app/services/services.dart';
import 'package:formularios_app/widgets/widgets.dart';
import 'package:formularios_app/ui/input_decorations.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 250,),

              CardContainer(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text('Login', style: Theme.of(context).textTheme.headline4,),

                    SizedBox(height: 30),

                    //Crea una instancia del login form provider que puede redibujar widges en este scope
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                    ),

                  ],
                ),
              ),

              SizedBox(height: 50),

              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, 'register'),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all( Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all( StadiumBorder())
                ),
                child: Text('Crear una nueva cuenta', style: TextStyle( fontSize: 18, color: Colors.black87),),
              ),

              SizedBox( height:  50,),

            ],
          ),
        )
      )
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        // indicar a que key apunta
        key: loginForm.formKey,

        // disparador de la validacion
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'JhonDoe@algo.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_rounded
              ),
              // agregar los valores del formulario a las variables
              onChanged: (value) => loginForm.email = value,

              // el Key del formulario nos dirá si este es valido o no (null es que paso)
              validator: (value){

                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = new RegExp(pattern);

                //null significa que el formulario paso bien
                return regExp.hasMatch(value ?? '')
                ? null
                : 'Este valor no luce como un correo';
              },
            ),
            SizedBox(height: 30),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '******',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline
              ),
              onChanged: (value) => loginForm.password = value,
              validator: (value){
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe ser de mínimo 6 caracteres';
              },
            ),
            SizedBox(height: 30),
            
            MaterialButton(
              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading
                      ? 'Espere'
                      : 'Ingresar',
                  style: TextStyle( color: Colors.white)
                ),
              ),
              onPressed: loginForm.isLoading ? null: () async {

                // Quitar el teclado
                FocusScope.of(context).unfocus();
                // dentro de un metodo no se piede escuchar
                final authService = Provider.of<AuthService>(context, listen:false);

                if(!loginForm.isValidform()) return ;

                loginForm.isLoading = true;

                // fingir un delay
                //await Future.delayed(Duration(seconds: 2));

                //aca se usa un backen para verificar la informacion
                final String? errorMessage = await authService.login(loginForm.email, loginForm.password);

                if ( errorMessage == null) {
                  Navigator.pushReplacementNamed(context, 'home');
                } else {
                  NotificationsService.showSnackbar(errorMessage);
                  loginForm.isLoading = false;
                }

            },)
          ],
        ),
      ),
    );
  }
}
