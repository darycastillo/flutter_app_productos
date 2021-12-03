import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_app_productos/provider/login_form_provider.dart';
import 'package:flutter_app_productos/services/services.dart';
import 'package:flutter_app_productos/ui/input_decorations.dart';
import 'package:flutter_app_productos/utils/field_validations.dart';
import 'package:flutter_app_productos/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 250),
            CardContainer(
              child: Column(
                children: [
                  Text(
                    "Crear cuenta",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(height: 20),
                  ChangeNotifierProvider(
                    create: (_) => LoginFormProvider(),
                    child: const _LoginForm(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'login'),
                child: const Text(
                  'Ya tienes una cuenta',
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        Colors.indigo.withOpacity(0.01)),
                    shape: MaterialStateProperty.all(const StadiumBorder()))),
            const SizedBox(height: 30),
          ],
        ),
      ),
    ));
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Form(
      key: loginForm.formkey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
                prefixIcon: Icons.alternate_email,
                hintText: 'jonh.doe@correo.com',
                labelText: 'Correo electrónico'),
            onChanged: (val) => loginForm.email = val,
            validator: (val) => FieldValidations.emailField(value: val ?? ''),
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
                hintText: '*******',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outlined),
            onChanged: (val) => loginForm.password = val,
            validator: (val) => FieldValidations.passwordField(value: val),
          ),
          const SizedBox(
            height: 30,
          ),
          MaterialButton(
            color: Colors.deepPurple,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(loginForm.isLoading ? 'Espere..' : 'Crear cuenta',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            onPressed: loginForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final authProvider =
                        Provider.of<AuthService>(context, listen: false);
                    if (!loginForm.isValidForm()) return;

                    loginForm.isLoading = true;

                    final errorMessage = await authProvider.crateuser(
                        loginForm.email, loginForm.password);

                    if (errorMessage == null) {
                      Navigator.pushReplacementNamed(context, 'home');
                    } else {
                      NotificationsService.showSnackbar(errorMessage);
                      loginForm.isLoading = false;
                    }
                  },
          )
        ],
      ),
    );
  }
}
