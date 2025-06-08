import 'package:flutter/material.dart';
import 'package:xpvault/layouts/responsive_layout.dart';
import 'package:xpvault/screens/desktop/serie_detail_desktop.dart';
import 'package:xpvault/screens/mobile/serie_detail_mobile.dart';

class SerieDetailPage extends StatefulWidget {
  final int serieId;
  final Widget? returnPage;

  const SerieDetailPage({
    super.key,
    required this.serieId,
    this.returnPage,
  });

  @override
  State<SerieDetailPage> createState() => _SerieDetailPageState();
}

class _SerieDetailPageState extends State<SerieDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: SerieDetailMobilePage(serieId: widget.serieId,
          returnPage: widget.returnPage,),
        desktopBody: SerieDetailDesktopPage(
          serieId: widget.serieId,
          returnPage: widget.returnPage,
        ),
      ),
    );
  }
}
