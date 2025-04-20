import 'package:flutter/material.dart';
import 'package:game_trackr/pages/home.dart';

class MainMenuWidget extends StatelessWidget {
  const MainMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.black
          ),
          child: const Text(
            'Menú',
            style: TextStyle(
              color: Colors.white, 
              fontSize: 24
            ),
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.home, 
            color: Colors.white
          ),
          title: const Text(
            "Home", 
            style: TextStyle(
              color: Colors.white
              )
            ),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.person,
            color: Colors.white,
          ),
          title: const Text(
            "Perfil",
            style: TextStyle(
              color: Colors.white
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.group,
            color: Colors.white,
          ),
          title: const Text(
            "Amigos",
            style: TextStyle(
              color: Colors.white
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.insert_chart_rounded,
            color: Colors.white,
          ),
          title: const Text(
            "Ranking",
            style: TextStyle(
              color: Colors.white
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.history,
            color: Colors.white,
          ),
          title: const Text(
            "Historial",
            style: TextStyle(
              color: Colors.white
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}