import 'package:flutter/material.dart';
import 'package:xpvault/layouts/responsive_layout.dart';
import 'package:xpvault/screens/desktop/verify_resend_desktop.dart';

class VerifyResendPage extends StatefulWidget {
  final String email;
  
  const VerifyResendPage({super.key, required this.email});

  @override
  State<VerifyResendPage> createState() => _VerifyResendPageState();
}

class _VerifyResendPageState extends State<VerifyResendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: Scaffold(),
        desktopBody: VerifyResendDesktopPage(email: widget.email,),
      ),
    );
  }
}
