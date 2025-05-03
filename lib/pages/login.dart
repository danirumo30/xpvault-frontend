import 'package:flutter/material.dart';
import 'package:game_trackr/layouts/base_layout.dart';
import 'package:game_trackr/pages/signup.dart';
import 'package:game_trackr/services/auth_login.dart';
import 'package:game_trackr/services/validation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool passwordInvisible = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final boxWidth = screenWidth > 720 ? 700.0 : screenWidth * 0.9;

    Future<void> login() async {
      await AuthLogin().login(emailController.text, passwordController.text);
    }

    return BaseLayout(
      title: "XPVAULT",
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: SizedBox(
            width: boxWidth,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Iniciar sesión",
                    style: TextStyle(
                      color: Color.fromARGB(255, 102, 174, 254),
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 40),

                  TextFormField(
                    controller: emailController,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 22.0),
                    decoration: InputDecoration(
                      hintText: "email@dominio.com",
                      hintStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator:
                        (email) => ValidationService.emailValidation(email),
                  ),

                  SizedBox(height: 40),

                  TextFormField(
                    controller: passwordController,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 22.0),
                    decoration: InputDecoration(
                      hintText: "contraseña",
                      hintStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordInvisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            // Cambiar el estado
                            passwordInvisible = !passwordInvisible;
                          });
                        },
                      ),
                    ),
                    obscureText: passwordInvisible,
                    maxLength: 25,
                    validator:
                        (password) =>
                            ValidationService.passwordValidation(password),
                  ),

                  SizedBox(height: 20),
                  Text(
                    "¿No tiene cuenta?",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "No se preocupe, para registrarse haga",
                    style: TextStyle(color: Colors.white),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        // Mostrar ventana para restaurar contraseña
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                      },
                      child: Text(
                        "click aquí",
                        style: TextStyle(
                          color: Color.fromARGB(255, 102, 174, 254),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () => ValidationService.submitForm(formKey, context, "") ? login() : null,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Color.fromARGB(255, 102, 174, 254),
                      ),
                      minimumSize: WidgetStateProperty.all(
                        Size(double.infinity, 60),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      elevation: WidgetStateProperty.all(5),
                      shadowColor: WidgetStateProperty.all(Colors.blue[200]),
                    ),
                    child: Text(
                      "Iniciar sesión",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
