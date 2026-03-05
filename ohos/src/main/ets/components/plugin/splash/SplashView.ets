import { Any, BinaryMessenger, MethodCall, MethodCallHandler, MethodChannel, MethodResult, PlatformView } from "@ohos/flutter_ohos";
import { common, UIAbility } from "@kit.AbilityKit";
import { HashMap } from "@kit.ArkTS";
import { window } from "@kit.ArkUI";
import { Params } from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView';
import FlutterTencentadConfig from "../FlutterTencentadConfig";
import { SplashBuilder } from "./SplashNativeView";
import { emitter } from "@kit.BasicServicesKit";

export default class SplashView extends PlatformView implements MethodCallHandler {
  private posId: string = "";
  private viewWidth: number = 0;
  private viewHeight: number = 0;
  private fetchDelay: number = 5000;
  private isBidding: boolean = false;
  private channel: MethodChannel;
  private uiAbility: UIAbility;
  private windowStage?: window.WindowStage;
  // 订阅事件
  event: emitter.InnerEvent = {
    eventId: FlutterTencentadConfig.eventId,
    priority: emitter.EventPriority.IMMEDIATE
  };

  constructor(
    context: common.Context,
    viewId: number,
    params: HashMap<string, Any>,
    messenger: BinaryMessenger,
    uIAbility: UIAbility
  ) {
    super();
    this.posId = params.get("ohosId") as string;
    this.viewWidth = params.get("viewWidth") as number ?? 0;
    this.viewHeight = params.get("viewHeight") as number ?? 0;
    this.fetchDelay = params.get("fetchDelay") as number ?? 5000;
    this.isBidding = params.get("isBidding") as boolean ?? false;
    this.channel = new MethodChannel(messenger, FlutterTencentadConfig.view.splashAdView + "_" + viewId);
    this.channel.setMethodCallHandler(this);
    this.uiAbility = uIAbility;
    this.windowStage = uIAbility.context.windowStage;
  }

  getView(): WrappedBuilder<[Params]> {
    return new WrappedBuilder(SplashBuilder);
  }

  getPosId(): string {
    return this.posId;
  }

  getViewWidth(): number {
    return this.viewWidth;
  }

  getViewHeight(): number {
    return this.viewHeight;
  }

  getFetchDelay(): number {
    return this.fetchDelay;
  }

  getIsBidding(): boolean {
    return this.isBidding;
  }

  getChannel(): MethodChannel {
    return this.channel;
  }

  getWindowStage(): window.WindowStage | null {
    return this.windowStage ?? null;
  }

  getUIAbility(): UIAbility {
    return this.uiAbility;
  }

  sendMsg(key: string, msg: Any) {
    this.channel.invokeMethod(key, msg);
  }

  /**
   * 实时竞价
   * 请求广告成功时
   */
  onMethodCall(call: MethodCall, result: MethodResult): void {
    switch (call.method) {
      case "biddingSucceeded": // 竞价成功上报
        const expectCostPrice: number = call.args.get("expectCostPrice");
        const highestLossPrice: number = call.args.get("highestLossPrice");
        let eventSucceeded: emitter.EventData = {
          data: {
            method: 'biddingSucceeded',
            expectCostPrice: expectCostPrice,
            highestLossPrice: highestLossPrice
          }
        };
        // 发送事件
        emitter.emit(this.event, eventSucceeded);
        break;
      case "biddingFail": // 竞价失败上报
        const winPrice: number = call.args.get("winPrice");
        const lossReason: number = call.args.get("lossReason");
        const adnId: number = call.args.get("adnId");
        let eventFail: emitter.EventData = {
          data: {
            method: 'biddingFail',
            winPrice: winPrice,
            lossReason: lossReason,
            adnId: adnId,
          }
        };
        // 发送事件
        emitter.emit(this.event, eventFail);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  dispose(): void {
  }
}
