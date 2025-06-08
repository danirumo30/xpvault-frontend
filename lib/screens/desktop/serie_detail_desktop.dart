import 'package:flutter/material.dart';
import 'package:xpvault/controllers/serie_controller.dart';
import 'package:xpvault/controllers/user_controller.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/models/serie.dart';
import 'package:xpvault/screens/season_detail.dart';
import 'package:xpvault/screens/series.dart';
import 'package:xpvault/services/user_manager.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/controllers/season_controller.dart';
import 'package:xpvault/widgets/my_build_content_box.dart';

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
      final has = await _userController.isTvSerieAdded(
        currentUser.username,
        _serie!.tmbdId,
      );
      setState(() {
        _hasSerie = has;
      });
    }
  }

  Future<void> _loadSerie() async {
    final serie = await _serieController.fetchSerieById(
      widget.serieId.toString(),
    );
    setState(() {
      _serie = serie;
    });
  }

  void _showSeasonDetail(BuildContext context, Season s) {
    if (_serie == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => SeasonDetailPage(
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
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: AppColors.textPrimary,
                ),
                onPressed: () {
                  if (widget.returnPage != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => widget.returnPage!,
                      ),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeriesPage(),
                      ),
                    );
                  }
                },
              ),
              // --- HEADER ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Poster
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      serie.posterUrl,
                      height: 320,
                      width: 220,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) =>
                              const Icon(Icons.broken_image, size: 120),
                    ),
                  ),
                  const SizedBox(width: 32),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          serie.title,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Genres chips
                        if (serie.genres.isNotEmpty)
                          Wrap(
                            spacing: 10,
                            runSpacing: 6,
                            children:
                                serie.genres
                                    .map(
                                      (g) => Chip(
                                        label: Text(g),
                                        backgroundColor: AppColors.secondary,
                                        labelStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 6,
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),

                        const SizedBox(height: 18),

                        // Release date & rating
                        Row(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: AppColors.accent,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  serie.releaseDate,
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 24),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  serie.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Description
                        Text(
                          (serie.description.isNotEmpty)
                              ? serie.description
                              : 'No description available',
                          style: const TextStyle(
                            fontSize: 17,
                            height: 1.4,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 24),

                  // Add / Remove serie button
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
                          success = await _userController.deleteTvSerieFromUser(
                            currentUser.username,
                            _serie!.tmbdId,
                          );
                        } else {
                          success = await _userController.addTvSerieToUser(
                            currentUser.username,
                            _serie!.tmbdId,
                          );
                        }

                        if (success) {
                          setState(() {
                            _hasSerie = !_hasSerie;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _hasSerie
                                    ? "Serie added successfully!"
                                    : "Serie deleted successfully!",
                              ),
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
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _hasSerie
                                    ? Colors.lightGreenAccent
                                    : Colors.grey,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
              const Divider(height: 2, thickness: 1),

              // --- Seasons & Summary ---
              const SizedBox(height: 24),

              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: AppColors.surface,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Seasons (${serie.totalSeasons})',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Episodes: ${serie.totalEpisodes}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: 40),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${serie.totalTime ~/ 60}h ${serie.totalTime % 60}m',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // --- Seasons list ---
              if (serie.seasons.isNotEmpty) ...[
                Text(
                  'Seasons',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children:
                      serie.seasons.map((s) {
                        bool isHovering = false;

                        return StatefulBuilder(
                          builder: (context, setLocalState) {
                            return MouseRegion(
                              onEnter:
                                  (_) => setLocalState(() => isHovering = true),
                              onExit:
                                  (_) =>
                                      setLocalState(() => isHovering = false),
                              cursor: SystemMouseCursors.click,
                              child: AnimatedScale(
                                scale: isHovering ? 1.05 : 1.0,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                child: InkWell(
                                  onTap: () => _showSeasonDetail(context, s),
                                  borderRadius: BorderRadius.circular(14),
                                  child: Container(
                                    width: 200,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.tv,
                                          color: AppColors.accent,
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Text(
                                            s.name,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                ),
              ],

              const SizedBox(height: 40),

              // --- Directors ---
              if (serie.directors.isNotEmpty) ...[
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  color: AppColors.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: MyBuildContentBox(
                      items: serie.directors,
                      showBodyLabel: false,
                      title: "Directors",
                    ),
                  ),
                ),
                const SizedBox(height: 36),
              ],

              // --- Main Cast ---
              if (serie.casting.isNotEmpty) ...[
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  color: AppColors.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: MyBuildContentBox(
                      items: serie.casting,
                      showBodyLabel: false,
                      title: "Casting",
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
