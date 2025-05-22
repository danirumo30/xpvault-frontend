import 'package:flutter/material.dart';
import 'package:xpvault/controllers/game_controller.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/models/game.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_dropdownbutton.dart';
import 'package:xpvault/widgets/my_netimagecontainer.dart';
import 'package:xpvault/widgets/my_textformfield.dart';

class SteamDesktopPage extends StatefulWidget {
  const SteamDesktopPage({super.key});

  @override
  State<SteamDesktopPage> createState() => _SteamDesktopPageState();
}

class _SteamDesktopPageState extends State<SteamDesktopPage> {
  static const String defaultImage =
      "https://w.wallhaven.cc/full/4l/wallhaven-4ly9gp.jpg";

  final GameController _gameController = GameController();
  String dropdownvalue = "";
  List<Game> games = [];
  bool _isLoading = true;
  int _currentPage = 2;
  final int _pageSize = 21;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
    setState(() {
      _isLoading = true;
    });
    final loadedGames = await _gameController.fetchGames(
      page: _currentPage,
      size: _pageSize,
    );
    setState(() {
      games = loadedGames;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DesktopLayout(
      title: "XPVAULT",
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: MyTextformfield(
                    hintText: "Search",
                    obscureText: false,
                    suffixIcon: Icon(Icons.search, color: AppColors.textMuted),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: MyDropdownbutton(
                    hint:
                        dropdownvalue.isEmpty ? "Select genre" : dropdownvalue,
                    items: const [
                      DropdownMenuItem(
                        value: "Shooter",
                        child: Text("Shooter"),
                      ),
                      DropdownMenuItem(value: "RPG", child: Text("RPG")),
                      DropdownMenuItem(
                        value: "Adventure",
                        child: Text("Adventure"),
                      ),
                    ],
                    onChanged: (value) {
                      if (value is String) {
                        setState(() {
                          dropdownvalue = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.tertiary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Games",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child:
                                  _isLoading
                                      ? Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.accent,
                                        ),
                                      )
                                      : GridView.builder(
                                        itemCount: games.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 10,
                                              childAspectRatio: 3 / 2,
                                            ),
                                        itemBuilder: (context, index) {
                                          final game = games[index];
                                          final imageUrl =
                                              (game.screenshotUrl
                                                          ?.trim()
                                                          .isNotEmpty ??
                                                      false)
                                                  ? game.screenshotUrl!
                                                  : defaultImage;

                                          return MyNetImageContainer(
                                            title: game.title,
                                            body: "",
                                            image: imageUrl,
                                          );
                                        },
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.tertiary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "My games",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(children: []),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed:
                      _currentPage > 0 && !_isLoading
                          ? () {
                            setState(() {
                              _currentPage--;
                            });
                            _loadGames();
                          }
                          : null,
                  child: const Text("Anterior"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed:
                      !_isLoading
                          ? () {
                            setState(() {
                              _currentPage++;
                            });
                            _loadGames();
                          }
                          : null,
                  child: const Text("Siguiente"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
