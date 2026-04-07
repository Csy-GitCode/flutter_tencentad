interface ViewConfig {
  splashAdView: string;
  bannerAdView: string;
  nativeExpressAdView: string;
}

export default class FlutterTencentadConfig {
  public static readonly adevent = "com.gstory.flutter_tencentad/adevent";
  public static readonly view: ViewConfig = {
    splashAdView: "com.gstory.flutter_tencentad/SplashAdView",
    bannerAdView: "com.gstory.flutter_tencentad/BannerAdView",
    nativeExpressAdView: "com.gstory.flutter_tencentad/NativeExpressAdView"
  };
  public static SplashEventId: number = 202603052207;
  public static BannerEventId: number = 202604062210;
  public static NativeEventId: number = 202604062211;
  public static RewardEventId: number = 202604062212;
  public static InterstitialEventId: number = 202604062213;
  public static biddingSucceeded: string = "biddingSucceeded";
  public static biddingFail: string = "biddingFail";
}
