import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdsFactory {

  static const AdRequest targetingInfo = AdRequest(
    keywords: <String>['study', 'snap', 'camera', 'photo', 'studying', 'university', 'school', 'education'
    'notes', 'materials'],
    nonPersonalizedAds: true,
  );


  static BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: "ca-app-pub-8543805483173927/4912638181",
      // adUnitId: "ca-app-pub-3940256099942544/6300978111", // Test
      size: AdSize.banner,
      request: targetingInfo,
      listener: listener
    );
  }

  static BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );

}