import 'package:flutter/material.dart';
import 'package:xpvault/layouts/responsive_layout.dart';
import 'package:xpvault/models/user.dart';
import 'package:xpvault/screens/desktop/user_settings_desktop.dart';
import 'package:xpvault/screens/mobile/signup_mobile.dart';

class UserSettingsPage extends StatefulWidget {
  final User? user;
  const UserSettingsPage({super.key, required this.user});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPage();
}

class _UserSettingsPage extends State<UserSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: SignupMobilePage(),
        desktopBody: UserSettingsDesktopPage(user: widget.user,),
      ),
    );
  }
}