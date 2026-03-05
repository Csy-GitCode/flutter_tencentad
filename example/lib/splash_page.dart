import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tencentad/flutter_tencentad.dart';

///
/// Description: 描述
/// Author: Gstory
/// Email: gstory0404@gmail.com
/// CreateDate: 2021/8/7 18:09
///

class SplashPage extends StatefulWidget {
  bool isBidding;
  String androidId;
  String iosId;
  String ohosId;

  SplashPage({
    Key? key,
    required this.isBidding,
    required this.androidId,
    required this.iosId,
    required this.ohosId,
  }) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final FlutterTencentAdBiddingController _bidding = new FlutterTencentAdBiddingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FlutterTencentad.splashAdView(
          //android广告id
          androidId: widget.androidId,
          //ios广告id
          iosId: widget.iosId,
          //ohos广告id
          ohosId: widget.ohosId,
          ////设置开屏广告从请求到展示所花的最大时长（并不是指广告曝光时长），取值范围为[1500, 5000]ms
          fetchDelay: 3000,
          //下载二次确认弹窗 默认false
          downloadConfirm: true,
          //是否开启竞价 默认不开启
          isBidding: widget.isBidding,
          //竞价结果回传
          bidding: _bidding,
          //广告回调
          callBack: FlutterTencentadSplashCallBack(onShow: () {
            print("开屏广告显示");
          }, onADTick: (time) {
            print("开屏广告倒计时剩余时间 $time");
          }, onClick: () {
            print("开屏广告点击");
          }, onClose: () {
            print("开屏广告关闭");
            Navigator.pop(context);
          }, onExpose: () {
            print("开屏广告曝光");
          }, onFail: (code, message) {
            print("开屏广告失败  $code $message");
            _bidding.biddingResult(FlutterTencentBiddingResult().fail(1000, FlutterTencentAdBiddingLossReason.TIME_OUT, FlutterTencentAdADNID.othoerADN));
            Navigator.pop(context);
          }, onECPM: (ecpmLevel, ecpm) {
            print("开屏广告竞价  ecpmLevel=$ecpmLevel  ecpm=$ecpm");
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
              //竞胜方出价（单位：分），类型为Integer
              //优量汇广告竞败原因 FlutterTencentAdBiddingLossReason
              //竞胜方渠道ID FlutterTencentAdADNID
              _bidding.biddingResult(FlutterTencentBiddingResult().fail(1000, FlutterTencentAdBiddingLossReason.LOW_PRICE, FlutterTencentAdADNID.othoerADN));
            }
          }),
        ),
      ),
    );
  }
}
