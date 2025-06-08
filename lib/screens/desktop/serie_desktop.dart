import 'package:flutter/material.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/screens/serie_detail.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_dropdownbutton.dart';
import 'package:xpvault/widgets/my_textformfield.dart';
import 'package:xpvault/models/serie.dart';
import 'package:xpvault/controllers/serie_controller.dart';
import 'package:xpvault/widgets/serie_grid.dart';

class SerieDesktopPage extends StatefulWidget {
  final Widget? returnPage;
  final String? username;

  const SerieDesktopPage({super.key, this.returnPage, this.username});

  @override
  State<SerieDesktopPage> createState() => _SerieDesktopPageState();
}

class _SerieDesktopPageState extends State<SerieDesktopPage> {
  String? _profileUsername;
  String? _loggedInUsername;
  bool _isUserLoggedIn = false;
  List<Serie> series = [];
  bool _isLoading = true;
  final TextEditingController searchController = TextEditingController();
  int _currentPage = 1;
  String dropdownValue = "";
  List<Serie> mySeries = [];
  bool _isLoadingMySeries = false;

  final SerieController serieController = SerieController();

  void _showSerieDetails(Serie serie) async {
    final fullSerie = await serieController.fetchSerieById(serie.tmbdId.toString());
    if (fullSerie != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SerieDetailPage(
            serieId: fullSerie.tmbdId,
            returnPage: widget.returnPage,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load serie details")),
      );
    }
  }

  Future<void> _searchByTitle(String title) async {
    setState(() => _isLoading = true);
    List<Serie> loadedSeries;

    if (title.trim().isNotEmpty) {
      loadedSeries = await serieController.searchSerieByTitle(title.trim(), page: _currentPage);
    } else {
      loadedSeries = await serieController.fetchPopularSeries(page: _currentPage);
    }

    setState(() {
      series = loadedSeries;
      dropdownValue = "";
      _isLoading = false;
    });
  }

  Future<void> _topRated() async {
    setState(() => _isLoading = true);
    List<Serie> loadedSeries;

    loadedSeries = await serieController.fetchTopRatedSeries(page: _currentPage);

    setState(() {
      series = loadedSeries;
      dropdownValue = "";
      _isLoading = false;
    });
  }

  Future<void> _searchByGenre(String genre) async {
    print(genre);
    setState(() => _isLoading = true);
    List<Serie> loadedSeries = await serieController.fetchSeriesByGenre(genre, page: _currentPage);
    print(loadedSeries.length);

    setState(() {
      series = loadedSeries;
      dropdownValue = genre;
      searchController.clear();
      _isLoading = false;
    });
  }

  Future<void> _initUserContext() async {
    String? username = widget.username;

    if (username == null) {
      final currentUser = await UserManager.getUser();
      username = currentUser?.username;
    }

    setState(() {
      _isUserLoggedIn = username != null;
      _loggedInUsername = username;
      _profileUsername = username;
    });

    if (_profileUsername != null) {
      await _loadMyOwnedSeries(_profileUsername!);
    }
  }

  Future<void> _loadMyOwnedSeries(String username) async {
    setState(() {
      _isLoadingMySeries = true;
    });

    final loadedSeries = await serieController.fetchUserSeries(username);

    setState(() {
      mySeries = loadedSeries;
      _isLoadingMySeries = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initUserContext();
    _topRated();
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
                    textEditingController: searchController,
                    hintText: "Search Series",
                    obscureText: false,
                    suffixIcon: Icon(Icons.search, color: AppColors.textMuted),
                    onFieldSubmitted: (value) {
                      setState(() {
                        _currentPage = 1;
                      });
                      _searchByTitle(value);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: MyDropdownbutton(
                    hint: dropdownValue.isEmpty ? "Select genre" : dropdownValue,
                    items: const [
                      DropdownMenuItem(value: "Action & Adventure", child: Text("Action & Adventure")),
                      DropdownMenuItem(value: "Animation", child: Text("Animation")),
                      DropdownMenuItem(value: "Comedy", child: Text("Comedy")),
                      DropdownMenuItem(value: "Crime", child: Text("Crime")),
                      DropdownMenuItem(value: "Documentary", child: Text("Documentary")),
                      DropdownMenuItem(value: "Drama", child: Text("Drama")),
                      DropdownMenuItem(value: "Family", child: Text("Family")),
                      DropdownMenuItem(value: "Kids", child: Text("Kids")),
                      DropdownMenuItem(value: "Mystery", child: Text("Mystery")),
                      DropdownMenuItem(value: "News", child: Text("News")),
                      DropdownMenuItem(value: "Reality", child: Text("Reality")),
                      DropdownMenuItem(value: "Sci-Fi & Fantasy", child: Text("Sci-Fi & Fantasy")),
                      DropdownMenuItem(value: "Soap", child: Text("Soap")),
                      DropdownMenuItem(value: "Talk", child: Text("Talk")),
                      DropdownMenuItem(value: "War & Politics", child: Text("War & Politics")),
                      DropdownMenuItem(value: "Western", child: Text("Western")),
                    ],
                    onChanged: (value) {
                      if (value is String) {
                        setState(() {
                          _currentPage = 1;
                        });
                        _searchByGenre(value);
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
                              "Series",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: SerieGrid(
                                series: series,
                                isLoading: _isLoading,
                                onSerieTap: _showSerieDetails,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: _currentPage > 1
                                      ? () {
                                          setState(() {
                                            _currentPage--;
                                          });
                                          if (dropdownValue.isNotEmpty) {
                                            _searchByGenre(dropdownValue);
                                          } else {
                                            _searchByTitle(searchController.text);
                                          }
                                        }
                                      : null,
                                  child: const Text("Previous"),
                                ),
                                Text(
                                  'Page $_currentPage',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _currentPage++;
                                    });
                                    if (dropdownValue.isNotEmpty) {
                                      _searchByGenre(dropdownValue);
                                    } else {
                                      _searchByTitle(searchController.text);
                                    }
                                  },
                                  child: const Text("Next"),
                                ),
                              ],
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
                              "My Series",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: _isLoadingMySeries
                                  ? const Center(child: CircularProgressIndicator())
                                  : mySeries.isEmpty
                                  ? const Center(child: Text("No series found"))
                                  : SerieGrid(
                                series: mySeries,
                                isLoading: false,
                                onSerieTap: _showSerieDetails,
                                title: false,
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
          ],
        ),
      ),
    );
  }
}
