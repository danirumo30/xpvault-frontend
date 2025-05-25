import 'package:flutter/material.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_build_content_box.dart';
import 'package:xpvault/widgets/my_build_section_title.dart';
import 'package:xpvault/models/user.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/widgets/my_textformfield.dart';

class ProfileDesktopPage extends StatefulWidget {
  const ProfileDesktopPage({super.key});

  @override
  State<ProfileDesktopPage> createState() => _ProfileDesktopPageState();
}

class _ProfileDesktopPageState extends State<ProfileDesktopPage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final loadedUser = await UserManager.getUser();
    setState(() {
      _user = loadedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DesktopLayout(
      title: "XPVAULT",
      body: _user == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock,color: AppColors.accent,size: 45,),
                  SizedBox(height: 16),
                  Text(
                    "You need to log in to access the profile",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "XPVAULT",
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: AppColors.surface,
                          radius: 24,
                          child: Text(
                            "👤",
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: MyTextformfield(hintText: "Search friends 🔍", obscureText: false)
                    ),

                    const SizedBox(height: 32),

                    Expanded(
                      child: ListView(
                        children: const [
                          MyBuildSectionTitle(title: "🎮 My Games"),
                          MyBuildContentBox(),

                          SizedBox(height: 24),

                          MyBuildSectionTitle(title: "🎬 My Movies"),
                          MyBuildContentBox(),

                          SizedBox(height: 24),

                          MyBuildSectionTitle(title: "📺 My Series"),
                          MyBuildContentBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
