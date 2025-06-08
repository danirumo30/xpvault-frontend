import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:xpvault/controllers/user_controller.dart';
import 'package:xpvault/layouts/mobile_layout.dart';
import 'package:xpvault/models/user.dart';
import 'package:xpvault/screens/login.dart';
import 'package:xpvault/services/token_manager.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/services/validation.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_button.dart';
import 'package:xpvault/widgets/my_textformfield.dart';
import 'package:web/web.dart' as web;

class UserSettingsMobilePage extends StatefulWidget {
  final User? user;
  const UserSettingsMobilePage({super.key, required this.user});

  @override
  State<UserSettingsMobilePage> createState() => _UserSettingsMobilePageState();
}

class _UserSettingsMobilePageState extends State<UserSettingsMobilePage> {
  User? _user;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _repeatNewPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final UserController _userController = UserController();

  bool passwordInvisible = true;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _user = widget.user;

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
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MobileLayout(
      title: "XPVAULT",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _imageBytes != null ? MemoryImage(_imageBytes!) : null,
                      child: _imageBytes == null ? const Icon(Icons.person, size: 60) : null,
                    ),
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.edit, color: Colors.black, size: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _user?.username ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _user?.email ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Change Password",
                style: TextStyle(
                  fontSize: 22,
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
                  final msg = ValidationService.passwordValidation(value);
                  if (msg != null) return msg;
                  if (value != _repeatNewPasswordController.text) return "Passwords must match";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              MyTextformfield(
                hintText: "Repeat password",
                obscureText: passwordInvisible,
                textEditingController: _repeatNewPasswordController,
                suffixIcon: IconButton(
                  onPressed: () => setState(() => passwordInvisible = !passwordInvisible),
                  icon: Icon(passwordInvisible ? Icons.visibility_off : Icons.visibility),
                ),
                validator: (value) {
                  final msg = ValidationService.passwordValidation(value);
                  if (msg != null) return msg;
                  if (value != _newPasswordController.text) return "Passwords must match";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              MyButton(
                text: "Update Password",
                fontSize: 16,
                onTap: () async {
                  if (_newPasswordController.text.isEmpty ||
                      _repeatNewPasswordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please complete both password fields."),
                        backgroundColor: AppColors.error,
                      ),
                    );
                    return;
                  }
                  if (formKey.currentState?.validate() ?? false) {
                    final updatedUser = _user!.copyWith(password: _newPasswordController.text);
                    final token = await TokenManager.getToken();
                    await UserManager.saveUser(updatedUser);
                    if (token != null) {
                      await _userController.saveUser(updatedUser, token);
                    }
                    _newPasswordController.clear();
                    _repeatNewPasswordController.clear();
                    setState(() => _user = updatedUser);
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
              const Divider(height: 40),
              const Text(
                "Steam Integration",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              if (_user?.steamUser?.steamId != null)
                MyButton(
                  text: "Steam linked - Tap to unlink",
                  fontSize: 16,
                  onTap: () async {
                    final updatedUser = _user!.copyWith(setSteamUserToNull: true);
                    final token = await TokenManager.getToken();
                    await UserManager.saveUser(updatedUser);
                    if (token != null) {
                      await _userController.saveUser(updatedUser, token);
                    }
                    setState(() => _user = updatedUser);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Steam account unlinked"),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                )
              else
                MyButton(
                  text: "Connect with Steam",
                  fontSize: 18,
                  onTap: () {
                    web.window.location.href = 'https://xpvaultbackend.es/steam-auth/login';
                  },
                ),
              const SizedBox(height: 24),
              MyButton(text: "Log out", fontSize: 15, onTap: _logout),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
