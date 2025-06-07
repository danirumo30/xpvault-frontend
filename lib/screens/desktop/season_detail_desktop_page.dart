import 'package:flutter/material.dart';
import 'package:xpvault/controllers/season_controller.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/models/season_detail.dart';
import 'package:xpvault/themes/app_color.dart';

class SeasonDetailDesktopPage extends StatefulWidget {
  final int serieId;
  final int seasonId;
  final Widget? returnPage;

  const SeasonDetailDesktopPage({
    super.key,
    required this.serieId,
    required this.seasonId,
    this.returnPage,
  });

  @override
  State<SeasonDetailDesktopPage> createState() => _SeasonDetailDesktopPageState();
}

class _SeasonDetailDesktopPageState extends State<SeasonDetailDesktopPage> {
  final SeasonController _seasonController = SeasonController();

  SeasonDetail? _seasonDetail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSeasonDetail();
  }

  Future<void> _loadSeasonDetail() async {
    final season = await _seasonController.fetchSeasonById(
      widget.serieId.toString(),
      widget.seasonId,
    );
    setState(() {
      _seasonDetail = season;
      _isLoading = false;
    });
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(width: 4, height: 24, color: AppColors.accent),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          if (widget.returnPage != null)
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new, size: 16),
              label: const Text('Back'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.accent,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return DesktopLayout(
        title: "XPVAULT",
        body: Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    if (_seasonDetail == null) {
      return DesktopLayout(
        title: "XPVAULT",
        body: Center(
          child: Text(
            "Season not found",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 20),
          ),
        ),
      );
    }

    final season = _seasonDetail!;

    return DesktopLayout(
      title: "XPVAULT",
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 900,
              minHeight: MediaQuery.of(context).size.height - 64, // altura viewport menos paddings verticales
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,  // centrar verticalmente
              crossAxisAlignment: CrossAxisAlignment.center, // centrar horizontalmente el contenido del Column
              children: [
                // Para que el texto y widgets dentro no queden centrados (en general están a la izquierda)
                // es preferible envolver el contenido en un Align o usar crossAxisAlignment.start
                // Aquí sólo el container padre está centrado, el contenido queda alineado a la izquierda.
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Description'),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          (season.description?.isNotEmpty ?? false)
                              ? season.description!
                              : 'No description available',
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.4,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildSectionTitle('Episodes (${season.episodesCount})'),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: season.episodes.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final episode = season.episodes[index];
                          final durationMinutes = episode.totalTime.toString();

                          return InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {},
                            hoverColor: AppColors.accent.withOpacity(0.1),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColors.accent.withOpacity(0.15),
                                    child: Text(
                                      episode.episodeNumber.toString(),
                                      style: const TextStyle(
                                        color: AppColors.accent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 18),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          episode.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          (episode.description?.isNotEmpty ?? false)
                                              ? episode.description!
                                              : 'No description available',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Row(
                                    children: [
                                      const Icon(Icons.timer, size: 20, color: AppColors.accent),
                                      const SizedBox(width: 6),
                                      Text(
                                        '$durationMinutes min',
                                        style: const TextStyle(
                                          color: AppColors.accent,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 48),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Total time of the season: ${season.totalTime} min',
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
