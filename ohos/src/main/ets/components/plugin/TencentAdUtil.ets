import { GDTAdSDK, GDTBiddingConstants, GDTClientBidding } from "@gdt/gdt-union-sdk";
import { emitter } from "@kit.BasicServicesKit";
import { MethodCall, MethodResult } from "@ohos/flutter_ohos";
import FlutterTencentadConfig from "./FlutterTencentadConfig";

export default class TencentAdUtil {
  /**
   * 实时竞价
   * 请求广告成功时
   */
  static onMethodCall(call: MethodCall, result: MethodResult, event: emitter.InnerEvent): void {
    switch (call.method) {
      case FlutterTencentadConfig.biddingSucceeded: // 竞价成功上报
        const expectCostPrice: number = call.args.get("expectCostPrice");
        const highestLossPrice: number = call.args.get("highestLossPrice");
        let eventSucceeded: emitter.EventData = {
          data: {
            method: FlutterTencentadConfig.biddingSucceeded,
            expectCostPrice: expectCostPrice,
            highestLossPrice: highestLossPrice
          }
        };
        // 发送事件
        emitter.emit(event, eventSucceeded);
        break;
      case FlutterTencentadConfig.biddingFail: // 竞价失败上报
        const winPrice: number = call.args.get("winPrice");
        const lossReason: number = call.args.get("lossReason");
        const adnId: number = call.args.get("adnId");
        let eventFail: emitter.EventData = {
          data: {
            method: FlutterTencentadConfig.biddingFail,
            winPrice: winPrice,
            lossReason: lossReason,
            adnId: adnId,
          }
        };
        // 发送事件
        emitter.emit(event, eventFail);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  /**
   * 实时竞价
   * 接收事件
   */
  static biddingCallback(eventData: emitter.EventData, ad: GDTClientBidding | undefined, showAD: () => void): void {
    console.info(`eventData: ${JSON.stringify(eventData)}`);
    let method: string = eventData.data!.method;
    if (method == "biddingSucceeded") { // 竞价成功上报
      ad?.sendWinNotification(new Map([
        [GDTBiddingConstants.EXPECT_COST_PRICE, '' + eventData.data!.expectCostPrice],
        [GDTBiddingConstants.HIGHEST_LOSS_PRICE, '' + eventData.data!.highestLossPrice],
      ]));
      // 显示广告
      showAD();
      console.info("实时竞价，广告展示");
    } else if (method == "biddingFail") { // 竞价失败上报
      ad?.sendLossNotification(new Map([
        [GDTBiddingConstants.WIN_PRICE, '' + eventData.data!.winPrice],
        [GDTBiddingConstants.LOSS_REASON, '' + eventData.data!.lossReason],
        [GDTBiddingConstants.ADN_ID, '' + eventData.data!.adnId],
      ]));
      console.info("实时竞价，竞价失败");
    }
  }

  /**
   * 实时竞价
   * 广告请求失败时上报
   */
  static biddingAdLoadError(call: MethodCall, result: MethodResult): void {
    const posId: string = call.args.get("posId");
    const winPrice: number = call.args.get("winPrice");
    const lossReason: number = call.args.get("lossReason");
    const adnId: number = call.args.get("adnId");

    console.info(`posId: ${posId}`);
    console.info(`winPrice: ${winPrice}`);
    console.info(`lossReason: ${lossReason}`);
    console.info(`adnId: ${adnId}`);

    GDTAdSDK.sendLossNotification(new Map([
      [GDTBiddingConstants.POS_ID, posId],
      [GDTBiddingConstants.WIN_PRICE, '' + winPrice],
      [GDTBiddingConstants.LOSS_REASON, '' + lossReason],
      [GDTBiddingConstants.ADN_ID, '' + adnId],
      [GDTBiddingConstants.WATERFALL_REQ_ID, '' + new Date().getTime()],
    ]));
    console.info("实时竞价 - 广告请求失败时上报");
    result.success(true);
  }
}