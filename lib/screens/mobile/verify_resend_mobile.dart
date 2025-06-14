import 'package:flutter/material.dart';
import 'package:xpvault/layouts/mobile_layout.dart';
import 'package:xpvault/screens/login.dart';
import 'package:xpvault/controllers/auth_controller.dart';
import 'package:xpvault/services/validation.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_button.dart';
import 'package:xpvault/widgets/my_textformfield.dart';
import 'package:xpvault/widgets/redirect_message.dart';

class VerifyResendMobilePage extends StatefulWidget {
  final String email;

  const VerifyResendMobilePage({super.key, required this.email});

  @override
  State<VerifyResendMobilePage> createState() =>
      _VerifyResendMobilePage();
}

class _VerifyResendMobilePage extends State<VerifyResendMobilePage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();

  Future<int> verifyCode() async {
    return await AuthController().verifyCode(widget.email, codeController.text);
  }

  Future<int> resendCode() async {
    return await AuthController().resend(widget.email);
  }

  Future<void> _handleVerify() async {
    if (formKey.currentState?.validate() ?? false) {
      final status = await verifyCode();
      if (!mounted) return;

      if (status == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Successful verify!"),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Verify code invalid"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MobileLayout(
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
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "An email with the verification code has been sent to ${widget.email}",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  MyTextformfield(
                    hintText: "6-digit verification code",
                    obscureText: false,
                    textEditingController: codeController,
                    validator: ValidationService.verificationCodeValidation,
                    onFieldSubmitted: (_) async {
                      await _handleVerify();
                    },
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    text: "Confirm",
                    fontSize: 20,
                    onTap: _handleVerify,
                  ),
                  const SizedBox(height: 20),
                  RedirectMessage(
                    mainText: "Didn't receive the email? ",
                    linkText: "Resend verification code",
                    onTap: () async {
                      if (await resendCode() == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Code forwarded"),
                            backgroundColor: AppColors.success,
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
