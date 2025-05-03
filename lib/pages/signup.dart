import 'package:flutter/material.dart';
import 'package:game_trackr/layouts/base_layout.dart';
import 'package:game_trackr/services/validation.dart';

import '../services/auth_signup.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool passwordInvisible = true;

  Future<void> signup() async {
    await AuthSignup().signup(emailController.text, passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final boxWidth = screenWidth > 720 ? 700.0 : screenWidth * 0.9;

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
                    "Registrarse",
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

                  SizedBox(height: 40),

                  ElevatedButton(
                    onPressed: () => ValidationService.submitForm(formKey,context,emailController.text) ? signup() : null,
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
                      "Registrarse",
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
