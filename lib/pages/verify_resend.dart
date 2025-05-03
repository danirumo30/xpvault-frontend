import 'package:flutter/material.dart';
import 'package:game_trackr/layouts/base_layout.dart';
import 'package:game_trackr/services/auth_resend.dart';
import 'package:game_trackr/services/auth_verify.dart';
import 'package:game_trackr/services/validation.dart';

class VerifyResendPage extends StatefulWidget {
  final String emailRegistration;
  const VerifyResendPage({super.key, required this.emailRegistration});

  @override
  State<VerifyResendPage> createState() => _VerifyResendPageState();
}

class _VerifyResendPageState extends State<VerifyResendPage> {
  final TextEditingController verifyCodeController = TextEditingController();

  Future<void> verifyCode() async {
    await AuthVerify().verifyCode(widget.emailRegistration, verifyCodeController.text);
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Verificar correo",
                  style: TextStyle(
                    color: Color.fromARGB(255, 102, 174, 254),
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Text(
                  "Se ha enviado un correo con el código de verificación a ${widget.emailRegistration}",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 40),
                TextFormField(
                  controller: verifyCodeController,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 22.0),
                  decoration: InputDecoration(
                    hintText: "Introduce el código de 6 digitos",
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
                  validator: (code) => ValidationService.verifyCodeLength(code),
                ),
                SizedBox(height: 20),
                Text(
                  "¿No recibió el correo o el código expiró?",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "No se preocupe, pruebe a recibir uno nuevo haciendo",
                  style: TextStyle(color: Colors.white),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      await AuthResend().resend(widget.emailRegistration);
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
                  onPressed: () => verifyCode(),
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
                    "Confirmar",
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
    );
  }
}