import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:xpvault/controllers/user_controller.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/models/user.dart';
import 'package:xpvault/screens/login.dart';
import 'package:xpvault/services/token_manager.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/services/validation.dart';
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
  User? _user;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _repeatNewPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final UserController _userController = UserController();

  bool passwordInvisible = true;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _usernameController.text = _user?.username ?? '';
    _emailController.text = _user?.email ?? '';

    // Cargar la imagen si existe
    if (_user?.profilePhoto != null && _user!.profilePhoto!.isNotEmpty) {
      try {
        _imageBytes = base64Decode(_user!.profilePhoto!);
      } catch (e) {
        print("Error decoding profile image: $e");
      }
    }
  }

  Future<void> _logout() async {
    await TokenManager.deleteToken();
    await UserManager.deleteUser();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  Future<void> _pickImage() async {
    final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) async {
      final file = uploadInput.files?.first;
      if (file != null) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);

        reader.onLoadEnd.listen((e) async {
          final bytes = reader.result as Uint8List;
          setState(() {
            _imageBytes = bytes;
          });

          final base64Image = base64Encode(bytes);
          final updatedUser = _user!.copyWith(profilePhoto: base64Image);
          print(updatedUser.toJson());
          final token = await TokenManager.getToken();
          await UserManager.saveUser(updatedUser);
          if (token != null) {
            await _userController.saveUser(updatedUser, token);
          }

          setState(() {
            _user = updatedUser;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Profile image updated successfully"),
              backgroundColor: AppColors.success,
            ),
          );
          await _logout();
        });
      }
    });
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
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 75,
                          backgroundImage:
                              _imageBytes != null
                                  ? MemoryImage(_imageBytes!)
                                  : null,
                          child:
                              _imageBytes == null
                                  ? const Icon(Icons.person, size: 75)
                                  : null,
                        ),
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.edit, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _user?.username ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _user?.email ?? '',
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
                          final validationMessage =
                              ValidationService.passwordValidation(value);
                          if (validationMessage != null) {
                            return validationMessage;
                          }
                          if (value == null || value.isEmpty) {
                            return "You must complete the field";
                          }
                          if (value != _repeatNewPasswordController.text) {
                            return "Passwords must match";
                          }
                          return null;
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
                          final validationMessage =
                              ValidationService.passwordValidation(value);
                          if (validationMessage != null) {
                            return validationMessage;
                          }
                          if (value == null || value.isEmpty) {
                            return "You must complete the field";
                          }
                          if (value != _newPasswordController.text) {
                            return "Passwords must match";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      MyButton(
                        text: "Update Password",
                        fontSize: 18,
                        onTap: () async {
                          if (_newPasswordController.text.isEmpty ||
                              _repeatNewPasswordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please complete both password fields.",
                                ),
                                backgroundColor: AppColors.error,
                              ),
                            );
                            return;
                          }

                          if (formKey.currentState?.validate() ?? false) {
                            final updatedUser = _user!.copyWith(
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
                            
                            setState(() {
                              _user = updatedUser;
                            });

                            print(_user?.toJson());

                            _newPasswordController.clear();
                            _repeatNewPasswordController.clear();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Password updated successfully"),
                                backgroundColor: AppColors.success,
                              ),
                            );
                            await _logout();
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

                      if (_user?.steamUser?.steamId != null)
                        MyButton(
                          text: "Steam linked - Click to unlink",
                          fontSize: 18,
                          onTap: () async {
                            final updatedUser = _user!.copyWith(
                              setSteamUserToNull: true,
                            );
                            print(updatedUser.toJson());
                            final token = await TokenManager.getToken();
                            await UserManager.saveUser(updatedUser);
                            if (token != null) {
                              await _userController.saveUser(
                                updatedUser,
                                token,
                              );
                            }

                            setState(() {
                              _user = updatedUser;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Steam account unlinked"),
                                backgroundColor: AppColors.success,
                              ),
                            );
                            await _logout();
                          },
                        )
                      else
                        MyButton(
                          text: "Go to Steam",
                          fontSize: 25,
                          onTap: () {
                            web.window.location.href =
                                'http://localhost:5000/steam-auth/login';
                          },
                        ),
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
