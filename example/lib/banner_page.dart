import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tencentad/flutter_tencentad.dart';

///
/// Description: 描述
/// Author: Gstory
/// Email: gstory0404@gmail.com
/// CreateDate: 2021/8/7 18:09
///

class BannerPage extends StatefulWidget {
  const BannerPage({Key? key, this.isBidding = false}) : super(key: key);

  final bool isBidding;

  @override
  _BannerPageState createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  FlutterTencentAdBiddingController _bidding = new FlutterTencentAdBiddingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Banner广告（${widget.isBidding ? "实时竞价" : "平台模板"}）"),
      ),
      body: Column(
        children: [
          if (!widget.isBidding)
            FlutterTencentad.bannerAdView(
              //android广告id
              androidId: "3280862472037698",
              //ios广告id
              iosId: "2240669472733809",
              //ohos广告id
              ohosId: "5278583254180441",
              //广告宽 单位dp
              //viewWidth: 640,
              //广告高  单位dp   宽高比应该为6.4:1
              //viewHeight: 100,
              viewWidth: 375,
              //广告高  单位dp   宽高比应该为6.4:1
              viewHeight: 120,
              //下载二次确认弹窗 默认false
              downloadConfirm: true,
              // 广告回调
              callBack: FlutterTencentadBannerCallBack(
                onShow: () {
                  print("Banner广告显示");
                },
                onFail: (code, message) {
                  print("Banner广告错误 $code $message");
                },
                onClose: () {
                  print("Banner广告关闭");
                },
                onExpose: () {
                  print("Banner广告曝光");
                },
                onClick: () {
                  print("Banner广告点击");
                },
              ),
            ),
          if (!widget.isBidding)
            FlutterTencentad.bannerAdView(
              //android广告id
              androidId: "3280862472037698",
              //ios广告id
              iosId: "2240669472733809",
              //ohos广告id
              ohosId: "6238183214770223",
              //广告宽 单位dp
              //viewWidth: 640,
              //广告高  单位dp   宽高比应该为6.4:1
              //viewHeight: 100,
              viewWidth: 375,
              //广告高  单位dp   宽高比应该为6.4:1
              viewHeight: 120,
              //下载二次确认弹窗 默认false
              downloadConfirm: true,
              // 广告回调
              callBack: FlutterTencentadBannerCallBack(
                onShow: () {
                  print("Banner广告显示");
                },
                onFail: (code, message) {
                  print("Banner广告错误 $code $message");
                },
                onClose: () {
                  print("Banner广告关闭");
                },
                onExpose: () {
                  print("Banner广告曝光");
                },
                onClick: () {
                  print("Banner广告点击");
                },
              ),
            ),
          //竞价banner
          if (widget.isBidding)
            FlutterTencentad.bannerAdView(
              //android广告id
              androidId: "3093291064428297",
              //ios广告id
              iosId: "3093291064428297",
              ohosId: "6238183214770223",
              viewWidth: 640,
              viewHeight: 100,
              isBidding: true,
              bidding: _bidding,
              // 广告回调
              callBack: FlutterTencentadBannerCallBack(onShow: () {
                print("Banner广告显示");
              }, onFail: (code, message) {
                print("Banner广告错误 $code $message");
                final random = Random();
                int winPrice = random.nextInt(5000) + 1000;
                FlutterTencentBiddingResult result = FlutterTencentBiddingResult().fail(
                  winPrice,
                  FlutterTencentAdBiddingLossReason.TIME_OUT,
                  FlutterTencentAdADNID.othoerADN,
                  posId: "6238183214770223",
                );
                FlutterTencentad.biddingAdLoadError(result: result);
              }, onClose: () {
                print("Banner广告关闭");
              }, onExpose: () {
                print("Banner广告曝光");
              }, onClick: () {
                print("Banner广告点击");
              }, onECPM: (ecpmLevel, ecpm) {
                print("Banner广告竞价  ecpmLevel=$ecpmLevel  ecpm=$ecpm");
                //规则 自己根据业务处理
                if (ecpm > 0) {
                  final random = Random();
                  final int max = ecpm > 1000 ? 100 : 10;
                  int number = ecpm - (random.nextInt(max) + 1);
                  int highestLossPrice = number > 1 ? number : 1;
                  print("竞胜出价 $ecpm  最大竞败方出价 $highestLossPrice");
                  //竞胜出价，类型为Integer
                  //最大竞败方出价，类型为Integer
                  _bidding.biddingResult(FlutterTencentBiddingResult().success(ecpm, highestLossPrice));
                } else {
                  final random = Random();
                  int winPrice = random.nextInt(5000) + 1000;
                  //竞胜方出价（单位：分），类型为Integer
                  //优量汇广告竞败原因 FlutterTencentAdBiddingLossReason
                  //竞胜方渠道ID FlutterTencentAdADNID
                  _bidding.biddingResult(FlutterTencentBiddingResult().fail(winPrice, FlutterTencentAdBiddingLossReason.LOW_PRICE, FlutterTencentAdADNID.othoerADN));
                }
              }),
            ),
          if (widget.isBidding)
            FlutterTencentad.bannerAdView(
              //android广告id
              androidId: "3093291064428297",
              //ios广告id
              iosId: "3093291064428297",
              ohosId: "5278583254180441",
              viewWidth: 640,
              viewHeight: 100,
              isBidding: true,
              bidding: _bidding,
              // 广告回调
              callBack: FlutterTencentadBannerCallBack(onShow: () {
                print("Banner广告显示");
              }, onFail: (code, message) {
                print("Banner广告错误 $code $message");
                final random = Random();
                int winPrice = random.nextInt(5000) + 1000;
                FlutterTencentBiddingResult result = FlutterTencentBiddingResult().fail(
                  winPrice,
                  FlutterTencentAdBiddingLossReason.TIME_OUT,
                  FlutterTencentAdADNID.othoerADN,
                  posId: "5278583254180441",
                );
                FlutterTencentad.biddingAdLoadError(result: result);
              }, onClose: () {
                print("Banner广告关闭");
              }, onExpose: () {
                print("Banner广告曝光");
              }, onClick: () {
                print("Banner广告点击");
              }, onECPM: (ecpmLevel, ecpm) {
                print("Banner广告竞价  ecpmLevel=$ecpmLevel  ecpm=$ecpm");
                //规则 自己根据业务处理
                if (ecpm > 0) {
                  final random = Random();
                  final int max = ecpm > 1000 ? 100 : 10;
                  int number = ecpm - (random.nextInt(max) + 1);
                  int highestLossPrice = number > 1 ? number : 1;
                  print("竞胜出价 $ecpm  最大竞败方出价 $highestLossPrice");
                  //竞胜出价，类型为Integer
                  //最大竞败方出价，类型为Integer
                  _bidding.biddingResult(FlutterTencentBiddingResult().success(ecpm, highestLossPrice));
                } else {
                  final random = Random();
                  int winPrice = random.nextInt(5000) + 1000;
                  //竞胜方出价（单位：分），类型为Integer
                  //优量汇广告竞败原因 FlutterTencentAdBiddingLossReason
                  //竞胜方渠道ID FlutterTencentAdADNID
                  _bidding.biddingResult(FlutterTencentBiddingResult().fail(winPrice, FlutterTencentAdBiddingLossReason.LOW_PRICE, FlutterTencentAdADNID.othoerADN));
                }
              }),
            ),
        ],
      ),
    );
  }
}
