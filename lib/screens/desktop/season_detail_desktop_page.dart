import 'package:flutter/material.dart';
import 'package:xpvault/models/serie.dart';
import 'package:xpvault/models/season_detail.dart';
import 'package:xpvault/themes/app_color.dart';

class SeasonDetailDesktopPage extends StatelessWidget {
  final Season season;
  final Widget? returnPage;

  const SeasonDetailDesktopPage({
    super.key,
    required this.season,
    this.returnPage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(season.name, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            if (returnPage != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => returnPage!),
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Season: ${season.name}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            // Añade más detalles de la temporada aquí
          ],
        ),
      ),
    );
  }
}
