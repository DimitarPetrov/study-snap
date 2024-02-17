import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BottomBar extends StatelessWidget {
  final BannerAd bannerAd;

  BottomBar({Key? key, required this.bannerAd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      child: BottomAppBar(
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 320,
              height: 50,
              child: AdWidget(ad: bannerAd),
            )
          ],
        ),
        shape: CircularNotchedRectangle(),
      ),
    );
  }

}