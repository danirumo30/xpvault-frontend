import 'package:flutter/material.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/screens/home.dart';
import 'package:xpvault/screens/signup.dart';
import 'package:xpvault/screens/verify_resend.dart';
import 'package:xpvault/controllers/auth_controller.dart';
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

  Future<int> _login() async {
    return await AuthController().login(
      emailController.text,
      passwordController.text,
    );
  }

  Future<int> _resenCode() async {
    return await AuthController().resend(emailController.text);
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
                    onTap: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        if (await _login() == 200) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Successful login!"),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Could not log in, try resending the verification code, create an account or try again later.",
                              ),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  RedirectMessage(
                    mainText: "Did you skip the verification code? ",
                    linkText: "Resend verification code",
                    onTap: () async {
                      if (emailController.text.isNotEmpty) {
                        if (await _resenCode() == 200) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => VerifyResendPage(
                                    email: emailController.text,
                                  ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Code could not be sent"),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Enter your email address to resend the verification code"),
                              backgroundColor: AppColors.error,
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
