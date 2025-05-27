import 'package:flutter/material.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/models/movie.dart';

class CastWithNavigation extends StatefulWidget {
  final List<Casting> casting;

  const CastWithNavigation({required this.casting, super.key});

  @override
  _CastWithNavigationState createState() => _CastWithNavigationState();
}

class _CastWithNavigationState extends State<CastWithNavigation> {
  final ScrollController _scrollController = ScrollController();

  void _scrollLeft() {
    final newPos = (_scrollController.offset - 200).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      newPos,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    final newPos = (_scrollController.offset + 200).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      newPos,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.casting.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.tertiary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.accent),
            onPressed: _scrollLeft,
            splashRadius: 24,
            tooltip: "Scroll left",
          ),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              controller: _scrollController,
              child: ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.casting.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final actor = widget.casting[index];
                  final image = actor.photoUrl;
                  final validPhoto = image != null &&
                      image.isNotEmpty &&
                      !image.endsWith("null");

                  return SizedBox(
                    width: 100,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: validPhoto
                              ? Image.network(
                                  image,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.person, size: 80, color: AppColors.textMuted),
                                )
                              : Icon(Icons.person, size: 80, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          actor.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (actor.character.isNotEmpty)
                          Text(
                            actor.character,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: AppColors.accent),
            onPressed: _scrollRight,
            splashRadius: 24,
            tooltip: "Scroll right",
          ),
        ],
      ),
    );
  }
}
