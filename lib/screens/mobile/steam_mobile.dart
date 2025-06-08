import 'package:flutter/material.dart';
import 'package:xpvault/controllers/game_controller.dart';
import 'package:xpvault/layouts/mobile_layout.dart';
import 'package:xpvault/models/game.dart';
import 'package:xpvault/screens/game_detail.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_dropdownbutton.dart';
import 'package:xpvault/widgets/my_netimagecontainer.dart';
import 'package:xpvault/widgets/my_textformfield.dart';

class SteamMobilePage extends StatefulWidget {
  final Widget? returnPage;
  final String? profileSteamId;

  const SteamMobilePage({super.key, this.returnPage, this.profileSteamId});

  @override
  State<SteamMobilePage> createState() => _SteamMobilePageState();
}

class _SteamMobilePageState extends State<SteamMobilePage> {
  static const String defaultImage =
      "https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png";

  final GameController _gameController = GameController();
  final TextEditingController searchController = TextEditingController();

  static const int _pageSize = 10;

  String? _steamUsername;
  String? _profileSteamId;
  String? _loggedInSteamId;
  String dropdownvalue = "";
  String lastSearchValue = "";
  List<Game> games = [];
  List<Game> myGames = [];
  bool _isLoading = true;
  bool _isLoadingMyGames = true;
  bool _isSteamUser = false;

  int _currentPage = 0;

  final List<String> steamGenres = [
    "All", 'Action', 'Adventure', 'RPG', 'Simulation',
    'Strategy', 'Sports', 'Racing', 'Indie', 'Casual'
  ];

  @override
  void initState() {
    super.initState();
    _loadGames();
    _initUserContext();
  }

  Future<void> _initUserContext() async {
    final currentUser = await UserManager.getUser();
    setState(() {
      _loggedInSteamId = currentUser?.steamUser?.steamId;
      _steamUsername = currentUser?.steamUser?.nickname;
      _profileSteamId = widget.profileSteamId ?? _loggedInSteamId;

      _isSteamUser = _profileSteamId != null;
      _isLoadingMyGames = _isSteamUser; // Solo true si hay usuario Steam
    });

    if (_profileSteamId != null) {
      await _loadMyGames(_profileSteamId!);
    } else {
      setState(() {
        _isLoadingMyGames = false; // No usuario => no loading
      });
    }
  }

  Future<void> _loadGames() async {
    setState(() => _isLoading = true);
    List<Game> loadedGames;

    if (searchController.text.trim().isNotEmpty) {
      _currentPage = 0;
      dropdownvalue = "All";
      loadedGames = await _gameController.searchGameByTitle(
        page: _currentPage,
        size: _pageSize,
        gameTitle: searchController.text,
      );
    } else if (dropdownvalue.isNotEmpty) {
      loadedGames = await _gameController.getGamesByGenre(
        genre: dropdownvalue,
        page: _currentPage,
        size: _pageSize,
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

  Future<void> _loadMyGames(String steamId) async {
    setState(() {
      _isLoadingMyGames = true;
    });

    final loadedGames = await _gameController.getUserGames(steamId);

    setState(() {
      myGames = loadedGames;
      _isLoadingMyGames = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MobileLayout(
      title: "XPVAULT",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search and Genre
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: MyTextformfield(
                    hintText: "Search",
                    obscureText: false,
                    textEditingController: searchController,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search, color: AppColors.textMuted),
                      onPressed: () {
                        _currentPage = 0;
                        _loadGames();
                      },
                    ),
                    onFieldSubmitted: (_) {
                      setState(() {
                        dropdownvalue = "";
                        _currentPage = 0;
                      });
                      _loadGames();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: MyDropdownbutton(
                    hint: dropdownvalue.isEmpty ? "Genre" : dropdownvalue,
                    items: steamGenres.map((genre) {
                      return DropdownMenuItem<String>(
                        value: genre,
                        child: Text(genre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value is String) {
                        setState(() {
                          searchController.clear();
                          dropdownvalue = value == "All" ? "" : value;
                          _currentPage = 0;
                        });
                        _loadGames();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text("Games",
                style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    )),
            const SizedBox(height: 8),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : games.isEmpty
                    ? const Center(child: Text("No games found."))
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: games.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1.3,
                        ),
                        itemBuilder: (context, index) {
                          final game = games[index];
                          final imageUrl = (game.screenshotUrl?.trim().isNotEmpty ?? false)
                              ? game.screenshotUrl!
                              : defaultImage;

                          return MyNetImageContainer(
                            title: game.title,
                            body: '',
                            image: imageUrl,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GameDetailPage(
                                  steamId: game.steamId,
                                  returnPage: widget.returnPage,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            const SizedBox(height: 20),
            Text(
              (_steamUsername != null ? "$_steamUsername's Games" : "My Games"),
              style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 8),
            _isLoadingMyGames
                ? const Center(child: CircularProgressIndicator())
                : !_isSteamUser
                    ? const Text(
                        "Please log in with your Steam account to see your games.",
                        style: TextStyle(color: AppColors.textPrimary),)
                    : myGames.isEmpty
                        ? const Text("You have no games.",
                        style: TextStyle(color: AppColors.textPrimary))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: myGames.length,
                            itemBuilder: (context, index) {
                              final game = myGames[index];
                              final imageUrl = (game.screenshotUrl?.trim().isNotEmpty ?? false)
                                  ? game.screenshotUrl!
                                  : defaultImage;

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: MyNetImageContainer(
                                  title: game.title,
                                  body: '',
                                  image: imageUrl,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GameDetailPage(
                                        steamId: game.steamId,
                                        returnPage: widget.returnPage,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
            const SizedBox(height: 20),
            // Pagination
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _currentPage > 0 && !_isLoading
                      ? () {
                          setState(() => _currentPage--);
                          _loadGames();
                        }
                      : null,
                  child: const Text("Previous"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: !_isLoading && games.length == _pageSize
                      ? () {
                          setState(() => _currentPage++);
                          _loadGames();
                        }
                      : null,
                  child: const Text("Next"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
