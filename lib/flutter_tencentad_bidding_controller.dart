part of 'flutter_tencentad.dart';

/// @Author: gstory
/// @CreateDate: 2022/9/2 14:39
/// @Email gstory0404@gmail.com
/// @Description: 优量汇竞价

class FlutterTencentAdBiddingController {
  late MethodChannel? _methodChannel;

  init(MethodChannel? method) {
    _methodChannel = method;
  }

  //回传竞价结果
  Future<void> biddingResult(FlutterTencentBiddingResult result) async {
    //竞价成功
    if (result.isSuccess) {
      await _methodChannel?.invokeMethod('biddingSucceeded', {
        'expectCostPrice': result.expectCostPrice,
        'highestLossPrice': result.highestLossPrice,
      });
    } else {
      //竞价失败
      await _methodChannel?.invokeMethod('biddingFail', {
        'winPrice': result.winPrice,
        'lossReason': result.lossReason,
        'adnId': result.adnId,
      });
    }
  }
}

class FlutterTencentBiddingResult {
  int? expectCostPrice;
  int? highestLossPrice;
  int? winPrice;
  int? lossReason;
  String? adnId;
  String? posId;

  bool isSuccess = true;

  FlutterTencentBiddingResult();

  ///竞价成功
  ///
  ///[expectCostPrice] 竞胜出价，类型为Integer
  ///
  ///[highestLossPrice] 最大竞败方出价，类型为Integer
  FlutterTencentBiddingResult success(int expectCostPrice, int highestLossPrice) {
    this.isSuccess = true;
    this.expectCostPrice = expectCostPrice;
    this.highestLossPrice = highestLossPrice;
    return this;
  }

  ///竞价失败
  ///
  /// [winPrice] 本次竞胜方出价（单位：分），类型为Integer。选填
  ///
  /// [lossReason] 优量汇广告竞败原因，类型为Integer。必填 [FlutterTencentAdBiddingLossReason]
  ///
  /// [adnId] 本次竞胜方渠道ID，类型为Integer。必填。 [FlutterTencentAdADNID]
  ///
  /// [posId] 广告位ID， 鸿蒙必填。
  FlutterTencentBiddingResult fail(int winPrice, int lossReason, String adnId, {String? posId}) {
    this.isSuccess = false;
    this.winPrice = winPrice;
    this.lossReason = lossReason;
    this.adnId = adnId;
    this.posId = posId;
    return this;
  }

  FlutterTencentBiddingResult.fromJson(Map<String, dynamic> json) {
    expectCostPrice = json['expectCostPrice'];
    highestLossPrice = json['highestLossPrice'];
    winPrice = json['winPrice'];
    lossReason = json['lossReason'];
    adnId = json['adnId'];
    posId = json['posId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['expectCostPrice'] = this.expectCostPrice;
    data['highestLossPrice'] = this.highestLossPrice;
    data['winPrice'] = this.winPrice;
    data['lossReason'] = this.lossReason;
    data['adnId'] = this.adnId;
    data['posId'] = this.posId;
    return data;
  }
}
