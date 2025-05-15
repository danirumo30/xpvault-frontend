import 'package:flutter/material.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/screens/home.dart';
import 'package:xpvault/screens/signup.dart';
import 'package:xpvault/screens/verify_resend.dart';
import 'package:xpvault/services/auth_operation.dart';
import 'package:xpvault/services/validation.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_button.dart';
import 'package:xpvault/widgets/my_textformfield.dart';
import 'package:xpvault/widgets/redirect_message.dart';

class LoginDesktopPage extends StatefulWidget {
  const LoginDesktopPage({super.key});

  @override
  State<LoginDesktopPage> createState() => _LoginDesktopPageState();
}

class _LoginDesktopPageState extends State<LoginDesktopPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool passwordInvisible = true;

  Future<void> login() async {
    await AuthOperation().login(emailController.text, passwordController.text);
  }

  Future<void> resenCode() async {
    await AuthOperation().resend(emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return DesktopLayout(
      title: "XPVAULT",
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: 700,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome back!",
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyTextformfield(
                    hintText: "Email",
                    obscureText: false,
                    textEditingController: emailController,
                    validator: ValidationService.emailValidation,
                  ),
                  const SizedBox(height: 15),
                  MyTextformfield(
                    hintText: "Password",
                    obscureText: passwordInvisible,
                    textEditingController: passwordController,
                    validator: ValidationService.passwordValidation,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          passwordInvisible = !passwordInvisible;
                        });
                      },
                      icon: Icon(
                        passwordInvisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    text: "Login",
                    fontSize: 20,
                    onTap: () {
                      if (formKey.currentState?.validate() ?? false) {
                        login();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                        //TODO: El Login devuelve un bool, si es true muestra el snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Successful login!"),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  RedirectMessage(
                    mainText: "Did you skip the verification code? ",
                    linkText: "Resend verification code",
                    onTap: () {
                      if (emailController.text.isNotEmpty) {
                        resenCode();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => VerifyResendPage(
                                  email: emailController.text,
                                ),
                          ),
                        );
                      }
                    },
                  ),
                  Text("-", style: TextStyle(color: AppColors.textPrimary)),
                  RedirectMessage(
                    mainText: "Don't have an account? ",
                    linkText: "Sign up now",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
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
