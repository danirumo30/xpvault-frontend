import 'package:flutter/material.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_dropdownbutton.dart';
import 'package:xpvault/widgets/my_textformfield.dart';
import 'package:xpvault/models/serie.dart';
import 'package:xpvault/controllers/serie_controller.dart';
import 'package:xpvault/widgets/serie_grid.dart';
import 'package:xpvault/screens/desktop/serie_detail_desktop.dart';

class SerieDesktopPage extends StatefulWidget {
  final Widget? returnPage;

  const SerieDesktopPage({super.key, this.returnPage});

  @override
  State<SerieDesktopPage> createState() => _SerieDesktopPageState();
}

class _SerieDesktopPageState extends State<SerieDesktopPage> {
  List<Serie> series = [];
  bool _isLoading = true;
  final TextEditingController searchController = TextEditingController();
  int _currentPage = 1;
  String dropdownValue = "";

  final SerieController serieController = SerieController();

  void _showSerieDetails(Serie serie) async {
    final fullSerie = await serieController.fetchSerieById(serie.tmbdId.toString());
    if (fullSerie != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SerieDetailDesktopPage(
            serie: fullSerie,
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

  Future<void> _loadSeries() async {
    setState(() => _isLoading = true);

    List<Serie> loadedSeries;
    if (searchController.text.trim().isNotEmpty) {
      loadedSeries = await serieController.searchSerieByTitle(
        searchController.text.trim(),
        page: _currentPage,
      );
    } else {
      loadedSeries = await serieController.fetchPopularSeries();
    }

    if (dropdownValue.isNotEmpty) {
      loadedSeries = loadedSeries
          .where((s) => s.genres.contains(dropdownValue))
          .toList();
    }

    setState(() {
      series = loadedSeries;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSeries();
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
                      _loadSeries();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: MyDropdownbutton(
                    hint: dropdownValue.isEmpty ? "Select genre" : dropdownValue,
                    items: const [
                      DropdownMenuItem(value: "Drama", child: Text("Drama")),
                      DropdownMenuItem(value: "Comedy", child: Text("Comedy")),
                      DropdownMenuItem(value: "Sci-Fi", child: Text("Sci-Fi")),
                    ],
                    onChanged: (value) {
                      if (value is String) {
                        setState(() {
                          dropdownValue = value;
                          _currentPage = 1;
                        });
                        _loadSeries();
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
                              "Last seen",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Expanded(
                              child: Center(
                                child: Text("No serie selected"),
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
