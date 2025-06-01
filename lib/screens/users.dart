import 'package:flutter/material.dart';
import 'package:xpvault/layouts/responsive_layout.dart';
import 'package:xpvault/screens/desktop/users_desktop.dart';

class UsersPage extends StatefulWidget {
  final String initialSearchTerm;

  const UsersPage({super.key, required this.initialSearchTerm});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: Scaffold(),
        desktopBody: UserSearchDesktopPage(initialSearchTerm: widget.initialSearchTerm),
      ),
    );
  }
}
