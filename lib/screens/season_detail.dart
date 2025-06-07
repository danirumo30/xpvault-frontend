import 'package:flutter/material.dart';
import 'package:xpvault/layouts/responsive_layout.dart';
import 'package:xpvault/screens/desktop/season_detail_desktop_page.dart';
import 'package:xpvault/screens/mobile/home_mobile.dart';

import 'package:xpvault/models/season_detail.dart';

class SeasonDetailPage extends StatefulWidget {
  final SeasonDetail seasonDetail;
  final Widget? returnPage;

  const SeasonDetailPage({
    super.key,
    required this.seasonDetail,
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
        mobileBody: HomeMobilePage(),
        desktopBody: SeasonDetailDesktopPage(
          seasonDetail: widget.seasonDetail,
          returnPage: widget.returnPage,
        ),
      ),
    );
  }
}
