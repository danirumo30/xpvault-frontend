import 'package:flutter/material.dart';
import 'package:xpvault/layouts/responsive_layout.dart';
import 'package:xpvault/screens/desktop/season_detail_desktop_page.dart';
import 'package:xpvault/screens/mobile/season_detail_mobile.dart';


class SeasonDetailPage extends StatefulWidget {
  final int serieId;
  final int seasondId;
  final Widget? returnPage;

  const SeasonDetailPage({
    super.key,
    required this.serieId,
    required this.seasondId,
    this.returnPage,
  });

  @override
  State<SeasonDetailPage> createState() => _SeasonDetailPageState();
}

class _SeasonDetailPageState extends State<SeasonDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: SeasonDetailMobilePage(serieId: widget.serieId,
          seasonId: widget.seasondId,
          returnPage: widget.returnPage,),
        desktopBody: SeasonDetailDesktopPage(
          serieId: widget.serieId,
          seasonId: widget.seasondId,
          returnPage: widget.returnPage,
        ),
      ),
    );
  }
}
