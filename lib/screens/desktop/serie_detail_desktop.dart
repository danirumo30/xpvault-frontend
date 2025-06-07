import 'package:flutter/material.dart';
import 'package:xpvault/controllers/serie_controller.dart';
import 'package:xpvault/controllers/user_controller.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/models/serie.dart';
import 'package:xpvault/screens/season_detail.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/controllers/season_controller.dart';

class SerieDetailDesktopPage extends StatefulWidget {
  final int serieId;
  final Widget? returnPage;

  const SerieDetailDesktopPage({
    super.key,
    required this.serieId,
    this.returnPage,
  });

  @override
  State<SerieDetailDesktopPage> createState() => _SerieDetailDesktopPageState();
}

class _SerieDetailDesktopPageState extends State<SerieDetailDesktopPage> {
  final SeasonController seasonController = SeasonController();
  final SerieController _serieController = SerieController();
  final _userController = UserController();

  Serie? _serie;
  bool _hoveringSerieTick = false;
  bool _hasSerie = false;

  @override
  void initState() {
    super.initState();
    _loadSerie();
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

  Future<void> _loadSerie() async {
    final serie = await _serieController.fetchSerieById(widget.serieId.toString());
    setState(() {
      _serie = serie;
    });
  }

  void _showSeasonDetail(BuildContext context, Season s) {
    if (_serie == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeasonDetailPage(
          serieId: _serie!.tmbdId,
          seasondId: s.tmdbId,
          returnPage: widget.returnPage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final serie = _serie;

    if (serie == null) {
      return DesktopLayout(
        title: "XPVAULT",
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return DesktopLayout(
      title: "XPVAULT",
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      serie.posterUrl,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 100),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          serie.title,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 8),
                        if (serie.genres.isNotEmpty)
                          Wrap(
                            spacing: 8.0,
                            children: serie.genres
                                .map((g) => Chip(
                              label: Text(g),
                              backgroundColor: AppColors.secondary,
                              labelStyle: const TextStyle(color: Colors.white),
                            ))
                                .toList(),
                          ),
                        const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        color: AppColors.accent, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      serie.releaseDate,
                                      style: const TextStyle(color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      serie.rating.toStringAsFixed(1),
                                      style: const TextStyle(color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        Text(
                          (serie.description.isNotEmpty)
                              ? serie.description
                              : 'No description available',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textMuted,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => _hoveringSerieTick = true),
                    onExit: (_) => setState(() => _hoveringSerieTick = false),
                    child: GestureDetector(
                      onTap: () async {
                        final currentUser = await UserManager.getUser();
                        if (currentUser == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Login to add series."),
                              backgroundColor: AppColors.warning,
                            ),
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
                              content: Text(_hasSerie ? "Serie added successfully!" : "Serie deleted successfully!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Something went wrong"),
                              backgroundColor: AppColors.warning,
                            ),
                          );
                        }
                      },
                      child: AnimatedScale(
                        scale: _hoveringSerieTick ? 1.3 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _hasSerie ? Colors.lightGreenAccent : Colors.grey,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // izquierda
                children: [
                  Text(
                    'Seasons (${serie.totalSeasons}) - Episodes: ${serie.totalEpisodes}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 8),
                  if (serie.seasons.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // izquierda
                        children: serie.seasons
                            .map(
                              (s) => InkWell(
                            onTap: () => _showSeasonDetail(context, s),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                '• ${s.name}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textMuted,
                                  decoration: TextDecoration.underline,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        )
                            .toList(),
                      ),
                    ),
                  Text(
                    'Total viewing time: ${serie.totalTime ~/ 60}h ${serie.totalTime % 60}m',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textMuted,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 24),
                  if (serie.directors.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // izquierda
                        children: [
                          const Text(
                            'Directors:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 16,
                            children: serie.directors
                                .map(
                                  (d) => Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipOval(
                                    child: d.photoUrl.isNotEmpty
                                        ? Image.network(
                                      d.photoUrl,
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.person,
                                          size: 64),
                                    )
                                        : Container(
                                      width: 64,
                                      height: 64,
                                      color: AppColors.secondary,
                                      child: Center(
                                        child: Text(
                                          d.name.isNotEmpty
                                              ? d.name[0]
                                              : '?',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    d.name,
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  if (serie.casting.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // izquierda
                        children: [
                          const Text(
                            'Main Cast:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: serie.casting
                                .map(
                                  (a) => Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: a.photoUrl.isNotEmpty
                                        ? Image.network(
                                      a.photoUrl,
                                      width: 64,
                                      height: 96,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.person,
                                          size: 64),
                                    )
                                        : Container(
                                      width: 64,
                                      height: 96,
                                      color: AppColors.secondary,
                                      child: Center(
                                        child: Text(
                                          a.name.isNotEmpty
                                              ? a.name[0]
                                              : '?',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  SizedBox(
                                    width: 64,
                                    child: Text(
                                      a.name,
                                      style: const TextStyle(
                                        color: AppColors.textMuted,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 64,
                                    child: Text(
                                      a.character,
                                      style: const TextStyle(
                                        color: AppColors.textMuted,
                                        fontSize: 10,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            )
                                .toList(),
                          ),
                        ],
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
