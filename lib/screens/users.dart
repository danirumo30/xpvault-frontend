import 'package:flutter/material.dart';
import 'package:xpvault/layouts/responsive_layout.dart';
import 'package:xpvault/screens/mobile/user_search_mobile.dart';

import 'desktop/user_searsh_desktop.dart';

class UsersPage extends StatefulWidget {
  final String initialSearchTerm;
  final String? viewFriendsOf;

  const UsersPage({
    super.key,
    required this.initialSearchTerm,
    this.viewFriendsOf,
  });

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: UserSearchMobilePage( initialSearchTerm: widget.initialSearchTerm,
          viewFriendsOf: widget.viewFriendsOf,),
        desktopBody: UserSearchDesktopPage(
          initialSearchTerm: widget.initialSearchTerm,
          viewFriendsOf: widget.viewFriendsOf,
        ),
      ),
    );
  }
}
