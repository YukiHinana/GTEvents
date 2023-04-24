// // TODO: Import ad_helper.dart
// import 'package:admob_inline_ads_in_flutter/ad_helper.dart';
// import 'package:flutter/cupertino.dart';
//

// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART
// ADS IMPLEMENTED IN HOMESCREEN.DART AND MAIN.DART

// // TODO: Import google_mobile_ads.dart
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// class BannerInlinePage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     throw UnimplementedError();
//   }
//
// }
// @override
// void initState() {
//   super.initState();
//
//   // TODO: Load a banner ad
//   BannerAd(
//     adUnitId: AdHelper.bannerAdUnitId,
//     size: AdSize.banner,
//     request: AdRequest(),
//     listener: BannerAdListener(
//       onAdLoaded: (ad) {
//         setState(() {
//           _ad = ad as BannerAd;
//         });
//       },
//       onAdFailedToLoad: (ad, error) {
//         // Releases an ad resource when it fails to load
//         ad.dispose();
//         print('Ad load failed (code=${error.code} message=${error.message})');
//       },
//     ),
//   ).load();
// }
// class _BannerInlinePageState extends State<BannerInlinePage> {
//
//   // TODO: Add _kAdIndex
//   static final _kAdIndex = 4;
//
//   // TODO: Add a banner ad instance
//   BannerAd? _ad;
//
//   // TODO: Add _getDestinationItemIndex()
//   int _getDestinationItemIndex(int rawIndex) {
//     if (rawIndex >= _kAdIndex && _ad != null) {
//       return rawIndex - 1;
//     }
//     return rawIndex;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
//
//
// }