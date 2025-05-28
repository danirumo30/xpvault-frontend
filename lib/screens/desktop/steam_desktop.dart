import 'package:flutter/material.dart';
import 'package:xpvault/controllers/game_controller.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/models/game.dart';
import 'package:xpvault/screens/desktop/game_detail_desktop.dart';
import 'package:xpvault/services/user_manager.dart';
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
      "https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png";

  final GameController _gameController = GameController();
  final TextEditingController searchController = TextEditingController();
  final int _pageSize = 12;

  String dropdownvalue = "";
  List<Game> games = [];
  List<Game> myGames = [];
  bool _isLoading = true;
  bool _isLoadingMyGames = true;
  bool _isSteamUser = false;
  int _currentPage = 0;

  final List<String> steamGenres = [
    'Action',
    'Adventure',
    'Role-Playing (RPG)',
    'Simulation',
    'Strategy',
    'Sports',
    'Racing',
    'Indie',
    'Casual',
    'Horror',
    'Survival',
    'Massively Multiplayer (MMO)',
    'Open World',
    'Puzzle',
    'Shooter (FPS/TPS)',
    'Co-op',
    'Platformer',
    'Virtual Reality (VR)',
    'Story-rich / Narrative',
    'Sandbox',
    'Tower Defense',
    'Roguelike / Roguelite',
    'Hack and Slash',
    'Battle Royale',
    'Metroidvania',
    'Clicker / Incremental',
    'Tactical / Turn-Based',
  ];

  @override
  void initState() {
    super.initState();
    _loadGames();
    _loadMyGames();
  }

  Future<void> _loadGames() async {
    final isSearching = searchController.text.trim().isNotEmpty;
    List<Game> loadedGames;

    setState(() => _isLoading = true);

    if (isSearching) {
      loadedGames = await _gameController.searchGameByTitle(
        page: _currentPage,
        size: _pageSize,
        gameTitle: searchController.text,
      );
    } else {
      loadedGames = await _gameController.fetchGames(
        page: _currentPage,
        size: _pageSize,
      );
    }

    setState(() {
      games = loadedGames;
      _isLoading = false;
    });
  }

  Future<void> _loadMyGames() async {
    final currentUser = await UserManager.getUser();

    if (currentUser?.steamId != null) {
      _isSteamUser = true;
    }

    setState(() => _isLoadingMyGames = true);

    if (_isSteamUser) {
      myGames = await _gameController.getUserGames(currentUser!.steamId);
    }

    setState(() => _isLoadingMyGames = false);
  }

  void _onPreviousPressed() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _loadGames();
    }
  }

  Future<void> _onNextPressed() async {
    setState(() {
      _isLoading = true;
      _currentPage++;
    });

    final isSearching = searchController.text.trim().isNotEmpty;
    List<Game> nextPageGames;

    if (isSearching) {
      nextPageGames = await _gameController.searchGameByTitle(
        page: _currentPage,
        size: _pageSize,
        gameTitle: searchController.text,
      );
    } else {
      nextPageGames = await _gameController.fetchGames(
        page: _currentPage,
        size: _pageSize,
      );
    }

    setState(() {
      games = nextPageGames;
      _isLoading = false;
    });
  }

  void _onSearch() {
    setState(() {
      _currentPage = 0;
    });
    _loadGames();
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: MyTextformfield(
                    hintText: "Search",
                    obscureText: false,
                    textEditingController: searchController,
                    onFieldSubmitted: (_) => _onSearch(),
                    suffixIcon: IconButton(
                      onPressed: _onSearch,
                      icon: Icon(Icons.search, color: AppColors.textMuted),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: MyDropdownbutton(
                    hint: dropdownvalue.isEmpty ? "Select genre" : dropdownvalue,
                    items: steamGenres.map<DropdownMenuItem<String>>((String genre) {
                      return DropdownMenuItem<String>(
                        value: genre,
                        child: Text(genre),
                      );
                    }).toList(),
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
                              child: _isLoading
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
                                  childAspectRatio: 2,
                                ),
                                itemBuilder: (context, index) {
                                  final game = games[index];
                                  final imageUrl = (game.screenshotUrl?.trim().isNotEmpty ??
                                      false)
                                      ? game.screenshotUrl!
                                      : defaultImage;

                                  return MyNetImageContainer(
                                    title: game.title,
                                    body: "",
                                    image: imageUrl,
                                    onTap: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            GameDetailDesktopPage(steamId: game.steamId),
                                      ),
                                    ),
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
                              child: !_isSteamUser
                                  ? Center(
                                child: Text(
                                  "Please log in with your Steam account to view your games.",
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                                  : _isLoadingMyGames
                                  ? Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.accent,
                                ),
                              )
                                  : GridView.builder(
                                itemCount: myGames.length,
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 5,
                                ),
                                itemBuilder: (context, index) {
                                  final game = myGames[index];
                                  final imageUrl =
                                  (game.screenshotUrl?.trim().isNotEmpty ?? false)
                                      ? game.screenshotUrl!
                                      : defaultImage;

                                  return MyNetImageContainer(
                                    title: game.title,
                                    body: "",
                                    image: imageUrl,
                                    onTap: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            GameDetailDesktopPage(steamId: game.steamId),
                                      ),
                                    ),
                                  );
                                },
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
                  onPressed: _currentPage > 0 && !_isLoading ? _onPreviousPressed : null,
                  child: const Text("Anterior"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: !_isLoading && games.length == _pageSize ? _onNextPressed : null,
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
