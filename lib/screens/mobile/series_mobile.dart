import 'package:flutter/material.dart';
import 'package:xpvault/layouts/mobile_layout.dart';
import 'package:xpvault/screens/serie_detail.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_dropdownbutton.dart';
import 'package:xpvault/widgets/my_textformfield.dart';
import 'package:xpvault/models/serie.dart';
import 'package:xpvault/controllers/serie_controller.dart';
import 'package:xpvault/widgets/serie_grid.dart';
import 'package:xpvault/widgets/serie_grid_mobile.dart';

class SerieMobilePage extends StatefulWidget {
  final Widget? returnPage;
  final String? username;

  const SerieMobilePage({super.key, this.returnPage, this.username});

  @override
  State<SerieMobilePage> createState() => _SerieMobilePageState();
}

class _SerieMobilePageState extends State<SerieMobilePage> {
  String? _profileUsername;
  List<Serie> series = [];
  bool _isLoading = true;
  final TextEditingController searchController = TextEditingController();
  int _currentPage = 1;
  String dropdownValue = "";
  List<Serie> mySeries = [];
  bool _isLoadingMySeries = false;

  final SerieController serieController = SerieController();

  @override
  void initState() {
    super.initState();
    _initUserContext();
    _topRated();
  }

  Future<void> _initUserContext() async {
    String? username = widget.username;

    if (username == null) {
      final currentUser = await UserManager.getUser();
      username = currentUser?.username;
    }

    setState(() {
      _profileUsername = widget.username ?? username;
    });

    if (_profileUsername != null) {
      await _loadMyOwnedSeries(_profileUsername!);
    }
  }

  Future<void> _loadMyOwnedSeries(String username) async {
    setState(() => _isLoadingMySeries = true);
    final loadedSeries = await serieController.fetchUserSeries(username);
    setState(() {
      mySeries = loadedSeries;
      _isLoadingMySeries = false;
    });
  }

  void _showSerieDetails(Serie serie) async {
    final fullSerie = await serieController.fetchSerieById(
      serie.tmbdId.toString(),
    );
    if (fullSerie != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => SerieDetailPage(
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
    final loadedSeries =
    title.trim().isNotEmpty
        ? await serieController.searchSerieByTitle(
      title.trim(),
      page: _currentPage,
    )
        : await serieController.fetchPopularSeries(page: _currentPage);
    setState(() {
      series = loadedSeries;
      dropdownValue = "";
      _isLoading = false;
    });
  }

  Future<void> _topRated() async {
    setState(() => _isLoading = true);
    final loadedSeries = await serieController.fetchTopRatedSeries(
      page: _currentPage,
    );
    setState(() {
      series = loadedSeries;
      dropdownValue = "";
      _isLoading = false;
    });
  }

  Future<void> _searchByGenre(String genre) async {
    setState(() => _isLoading = true);
    final loadedSeries = await serieController.fetchSeriesByGenre(
      genre,
      page: _currentPage,
    );
    setState(() {
      series = loadedSeries;
      dropdownValue = genre;
      searchController.clear();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MobileLayout(
      title: "XPVAULT",
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            MyTextformfield(
              textEditingController: searchController,
              hintText: "Search Series",
              obscureText: false,
              suffixIcon: Icon(Icons.search, color: AppColors.textMuted),
              onFieldSubmitted: (value) {
                setState(() => _currentPage = 1);
                _searchByTitle(value);
              },
            ),
            const SizedBox(height: 12),
            MyDropdownbutton(
              hint: dropdownValue.isEmpty ? "Select genre" : dropdownValue,
              items: const [
                DropdownMenuItem(
                  value: "Action & Adventure",
                  child: Text("Action & Adventure"),
                ),
                DropdownMenuItem(value: "Animation", child: Text("Animation")),
                DropdownMenuItem(value: "Comedy", child: Text("Comedy")),
                DropdownMenuItem(value: "Crime", child: Text("Crime")),
                DropdownMenuItem(
                  value: "Documentary",
                  child: Text("Documentary"),
                ),
                DropdownMenuItem(value: "Drama", child: Text("Drama")),
                DropdownMenuItem(value: "Family", child: Text("Family")),
                DropdownMenuItem(value: "Kids", child: Text("Kids")),
                DropdownMenuItem(value: "Mystery", child: Text("Mystery")),
                DropdownMenuItem(value: "News", child: Text("News")),
                DropdownMenuItem(value: "Reality", child: Text("Reality")),
                DropdownMenuItem(
                  value: "Sci-Fi & Fantasy",
                  child: Text("Sci-Fi & Fantasy"),
                ),
                DropdownMenuItem(value: "Soap", child: Text("Soap")),
                DropdownMenuItem(value: "Talk", child: Text("Talk")),
                DropdownMenuItem(
                  value: "War & Politics",
                  child: Text("War & Politics"),
                ),
                DropdownMenuItem(value: "Western", child: Text("Western")),
              ],
              onChanged: (value) {
                if (value is String) {
                  setState(() => _currentPage = 1);
                  _searchByGenre(value);
                }
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Series",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            SerieGridMobile(
              series: series,
              isLoading: _isLoading,
              onSerieTap: _showSerieDetails,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed:
                  _currentPage > 1
                      ? () {
                    setState(() => _currentPage--);
                    dropdownValue.isNotEmpty
                        ? _searchByGenre(dropdownValue)
                        : _searchByTitle(searchController.text);
                  }
                      : null,
                  child: const Text("Previous"),
                ),
                Text(
                  "Page $_currentPage",
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _currentPage++);
                    dropdownValue.isNotEmpty
                        ? _searchByGenre(dropdownValue)
                        : _searchByTitle(searchController.text);
                  },
                  child: const Text("Next"),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              _profileUsername == null
                  ? "My Series"
                  : "${_profileUsername!}'s Series",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            _isLoadingMySeries
                ? const Center(child: CircularProgressIndicator())
                : mySeries.isEmpty
                ? const Center(child: Text("No series found"))
                : SerieGridMobile(
              series: mySeries,
              isLoading: false,
              onSerieTap: _showSerieDetails,
            ),
          ],
        ),
      ),
    );
  }
}
