import 'package:flutter/material.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/screens/login.dart';
import 'package:xpvault/screens/verify_resend.dart';
import 'package:xpvault/controllers/auth_controller.dart';
import 'package:xpvault/services/validation.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_button.dart';
import 'package:xpvault/widgets/my_textformfield.dart';
import 'package:xpvault/widgets/redirect_message.dart';

class SignupDesktopPage extends StatefulWidget {
  const SignupDesktopPage({super.key});

  @override
  State<SignupDesktopPage> createState() => _SignupDesktopPageState();
}

class _SignupDesktopPageState extends State<SignupDesktopPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool passwordInvisible = true;

  Future<int> signup() async {
    return await AuthController().signup(
      emailController.text,
      passwordController.text,
    );
  }

  Future<void> _handleSignup() async {
    if (formKey.currentState?.validate() ?? false) {
      final status = await signup();
      if (!mounted) return;

      if (status == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyResendPage(
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
                    "Let's create an account for you",
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
                    onFieldSubmitted: (_) {
                      setState(() {});
                      _handleSignup();
                    },
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
                    onFieldSubmitted: (_) {
                      setState(() {});
                      _handleSignup();
                    },
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    text: "Sign up",
                    fontSize: 20,
                    onTap: () async {
                      setState(() {});
                      await _handleSignup();
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
