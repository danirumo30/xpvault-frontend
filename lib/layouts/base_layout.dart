import 'package:flutter/material.dart';
import 'package:game_trackr/pages/login.dart';
import 'package:game_trackr/widgets/main_menu.dart';

class BaseLayout extends StatelessWidget {
  final String title;
  final Widget body;

  const BaseLayout({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        actions: [
          TextButton(
            onPressed:() => Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => LoginPage())
            ), 
            child: Row(
              children: [
                Icon(
                  Icons.login,
                  color: Colors.white,
                ),
                SizedBox(width: 5,),
                Text(
                  "Iniciar sesión",
                  style: TextStyle(
                    color: Colors.white
                  ),
                )
              ],
            )
          )
        ],
      ),
      drawer: const Drawer(
        backgroundColor: Color.fromARGB(255, 22, 25, 32),
        child: MainMenuWidget(),
      ),
      backgroundColor: const Color.fromARGB(255, 22, 25, 32),
      body: body,
    );
  }
}
