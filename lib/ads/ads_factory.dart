import 'package:firebase_admob/firebase_admob.dart';

class BannerAdsFactory {

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: <String>["emulator-5554"],
    keywords: <String>['study', 'snap', 'camera', 'photo', 'studying', 'university', 'school', 'education'
    'notes', 'materials'],
    nonPersonalizedAds: true,
  );


  static BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: "ca-app-pub-8543805483173927/4912638181",
      // adUnitId: "ca-app-pub-3940256099942544/6300978111", // Test
      size: AdSize.banner,
      targetingInfo: targetingInfo,
    );
  }

}