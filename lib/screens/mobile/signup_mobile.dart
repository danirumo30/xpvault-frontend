import 'package:flutter/material.dart';
import 'package:xpvault/layouts/mobile_layout.dart';
import 'package:xpvault/screens/login.dart';
import 'package:xpvault/screens/verify_resend.dart';
import 'package:xpvault/services/auth_operation.dart';
import 'package:xpvault/services/validation.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_button.dart';
import 'package:xpvault/widgets/my_textformfield.dart';
import 'package:xpvault/widgets/redirect_message.dart';

class SignupMobilePage extends StatefulWidget {
  const SignupMobilePage({super.key});

  @override
  State<SignupMobilePage> createState() => _SignupMobilePageState();
}

class _SignupMobilePageState extends State<SignupMobilePage> {
    final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool passwordInvisible = true;

  Future<int> signup() async {
    return await AuthOperation().signup(
      emailController.text,
      passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MobileLayout(
      title: "XPVAULT",
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: 600,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Let's create an account for you",
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 35,
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
                    text: "Sign up",
                    fontSize: 20,
                    onTap: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        if (await signup() == 200) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => VerifyResendPage(
                                    email: emailController.text,
                                  ),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Successful sign up!"),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Account could not be registered"),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  RedirectMessage(
                    mainText: "Already have an account? ",
                    linkText: "Login now",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
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