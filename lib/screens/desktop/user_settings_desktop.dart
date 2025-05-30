import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xpvault/controllers/user_controller.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/models/user.dart';
import 'package:xpvault/screens/login.dart';
import 'package:xpvault/services/token_manager.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_button.dart';
import 'package:xpvault/widgets/my_textformfield.dart';
import 'package:web/web.dart' as web;

class UserSettingsDesktopPage extends StatefulWidget {
  final User? user;
  const UserSettingsDesktopPage({super.key, required this.user});

  @override
  State<UserSettingsDesktopPage> createState() =>
      _UserSettingsDesktopPageState();
}

class _UserSettingsDesktopPageState extends State<UserSettingsDesktopPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _repeatNewPasswordController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();
  final UserController _userController = UserController();

  bool _isSteamLoggedIn = false;
  bool passwordInvisible = true;

  Future<void> _logout() async {
    await TokenManager.deleteToken();
    await UserManager.deleteUser();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DesktopLayout(
      title: "XPVAULT",
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 75,
                    //backgroundImage:,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.user!.username,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.user!.email,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 40),
                  MyButton(text: "Log out", fontSize: 15, onTap: _logout),
                ],
              ),
            ),

            const SizedBox(width: 80),

            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Change password",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      MyTextformfield(
                        hintText: "New password",
                        obscureText: passwordInvisible,
                        textEditingController: _newPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "You must complete the field";
                          } else if (value !=
                              _repeatNewPasswordController.text) {
                            return "Passwords must match";
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      MyTextformfield(
                        hintText: "Repeat password",
                        obscureText: passwordInvisible,
                        textEditingController: _repeatNewPasswordController,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "You must complete the field";
                          } else if (value != _newPasswordController.text) {
                            return "Passwords must match";
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      MyButton(
                        text: "Update password",
                        fontSize: 25,
                        onTap: () async {
                          if (formKey.currentState?.validate() ?? false) {
                            final updatedUser = widget.user!.copyWith(
                              password: _newPasswordController.text,
                            );

                            final token = await TokenManager.getToken();

                            await UserManager.saveUser(updatedUser);

                            if (token != null) {
                              await _userController.saveUser(
                                updatedUser,
                                token,
                              );
                            }

                            // Opcional: mostrar un mensaje de éxito al usuario
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Password updated successfully"),
                              ),
                            );
                          }
                        },
                      ),

                      const Divider(height: 60),

                      const Text(
                        "Log in with Steam",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_isSteamLoggedIn)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Steam session successfully started.",
                            style: TextStyle(fontSize: 16, color: Colors.green),
                          ),
                        )
                      else ...[
                        MyButton(
                          text: "Go to Steam",
                          fontSize: 25,
                          onTap: () {
                            web.window.location.href =
                                'http://localhost:5000/steam-auth/login';
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
