import 'package:flutter/material.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/screens/home.dart';
import 'package:xpvault/services/auth_operation.dart';
import 'package:xpvault/services/validation.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_button.dart';
import 'package:xpvault/widgets/my_textformfield.dart';
import 'package:xpvault/widgets/redirect_message.dart';

class VerifyResendDesktopPage extends StatefulWidget {
  final String email;

  const VerifyResendDesktopPage({super.key, required this.email});

  @override
  State<VerifyResendDesktopPage> createState() => _VerifyResendDesktopPageState();
}

class _VerifyResendDesktopPageState extends State<VerifyResendDesktopPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();

  Future<void> verifyCode() async {
    await AuthOperation().verifyCode(widget.email,codeController.text);
  }

  Future<void> resendCode() async {
    await AuthOperation().resend(widget.email);
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
                    "Let's verify your account",
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Text(
                    "An email with the verification code has been sent to ${widget.email}",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  MyTextformfield(
                    hintText: "6-digit verification code",
                    obscureText: false,
                    textEditingController: codeController,
                    validator: ValidationService.verificationCodeValidation,
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    text: "Confirm",
                    fontSize: 20,
                    onTap: () {
                      if (formKey.currentState?.validate() ?? false) {
                        verifyCode();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
                        //TODO: Verificar el código tiene que devolver un bool para que este mensaje se muestre
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Successful verify!"),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  RedirectMessage(
                    mainText: "Didn't receive the email? ",
                    linkText: "Resend verification code",
                    onTap: () {
                      resendCode();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Code forwarded"),
                            backgroundColor: AppColors.success,
                          ),
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