import 'package:flutter/material.dart';
import 'package:xpvault/controllers/serie_controller.dart';
import 'package:xpvault/controllers/user_controller.dart';
import 'package:xpvault/layouts/mobile_layout.dart';
import 'package:xpvault/models/serie.dart';
import 'package:xpvault/screens/season_detail.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_build_content_box.dart';

class SerieDetailMobilePage extends StatefulWidget {
  final int serieId;
  final Widget? returnPage;

  const SerieDetailMobilePage({
    super.key,
    required this.serieId,
    this.returnPage,
  });

  @override
  State<SerieDetailMobilePage> createState() => _SerieDetailMobilePageState();
}

class _SerieDetailMobilePageState extends State<SerieDetailMobilePage> {
  final SerieController _serieController = SerieController();
  final UserController _userController = UserController();

  Serie? _serie;
  bool _hasSerie = false;

  @override
  void initState() {
    super.initState();
    _loadSerie();
  }

  Future<void> _loadSerie() async {
    final serie = await _serieController.fetchSerieById(widget.serieId.toString());
    setState(() {
      _serie = serie;
    });
    _checkUserHasSerie();
  }

  Future<void> _checkUserHasSerie() async {
    final currentUser = await UserManager.getUser();
    if (currentUser != null && _serie != null) {
      final has = await _userController.isTvSerieAdded(currentUser.username, _serie!.tmbdId);
      setState(() {
        _hasSerie = has;
      });
    }
  }

  void _toggleSerie() async {
    final currentUser = await UserManager.getUser();
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login to manage series"), backgroundColor: AppColors.warning),
      );
      return;
    }

    bool success;
    if (_hasSerie) {
      success = await _userController.deleteTvSerieFromUser(currentUser.username, _serie!.tmbdId);
    } else {
      success = await _userController.addTvSerieToUser(currentUser.username, _serie!.tmbdId);
    }

    if (success) {
      setState(() {
        _hasSerie = !_hasSerie;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_hasSerie ? "Serie added" : "Serie removed"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Operation failed"), backgroundColor: AppColors.warning),
      );
    }
  }

  void _navigateToSeasonDetail(Season s) {
    if (_serie == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SeasonDetailPage(
          serieId: _serie!.tmbdId,
          seasondId: s.tmdbId,
          returnPage: widget,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_serie == null) {
      return const MobileLayout(
        title: "XPVAULT",
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final serie = _serie!;

    return MobileLayout(
      title: "XPVAULT",
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // BACK BUTTON
          if (widget.returnPage != null)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.accent),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => widget.returnPage!),
                );
              },
            ),

          // POSTER & TITLE
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    serie.posterUrl,
                    height: 240,
                    width: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 100),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  serie.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: serie.genres
                      .map((g) => Chip(
                            label: Text(g),
                            backgroundColor: AppColors.secondary,
                            labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // METADATA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: AppColors.accent),
                  const SizedBox(width: 6),
                  Text(serie.releaseDate, style: const TextStyle(color: AppColors.textMuted)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 6),
                  Text(serie.rating.toStringAsFixed(1), style: const TextStyle(color: AppColors.textMuted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // DESCRIPTION
          Text(
            serie.description.isNotEmpty ? serie.description : "No description available",
            style: const TextStyle(fontSize: 16, height: 1.4, color: AppColors.textMuted),
          ),
          const SizedBox(height: 24),

          // ADD/REMOVE BUTTON
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _hasSerie ? Colors.red : AppColors.accent,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _toggleSerie,
            icon: Icon(_hasSerie ? Icons.remove : Icons.add),
            label: Text(_hasSerie ? 'Remove from List' : 'Add to List',style: TextStyle(color: AppColors.textPrimary,)),
          ),
          const SizedBox(height: 24),

          // SEASONS SUMMARY
          Text(
            'Seasons (${serie.totalSeasons}) • Episodes: ${serie.totalEpisodes}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Total Duration: ${serie.totalTime ~/ 60}h ${serie.totalTime % 60}m',
            style: const TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),

          // SEASONS LIST
          ...serie.seasons.map((s) => Card(
                child: ListTile(
                  title: Text(s.name, style: const TextStyle(color: AppColors.background)),
                  leading: const Icon(Icons.tv, color: AppColors.accent),
                  onTap: () => _navigateToSeasonDetail(s),
                ),
              )),

          const SizedBox(height: 24),

          // DIRECTORS
          if (serie.directors.isNotEmpty) ...[
            const SizedBox(height: 12),
            MyBuildContentBox(
              title: "Directors",
              items: serie.directors,
              showBodyLabel: false,
            ),
            const SizedBox(height: 24),
          ],

          // CASTING
          if (serie.casting.isNotEmpty) ...[
            const SizedBox(height: 12),
            MyBuildContentBox(
              title: "Casting",
              items: serie.casting,
              showBodyLabel: false,
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}