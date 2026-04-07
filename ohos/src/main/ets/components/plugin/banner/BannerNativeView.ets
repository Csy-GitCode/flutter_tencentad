import { Params } from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView';
import { window, NodeController } from '@kit.ArkUI';
import {
  GDTAdSDK,
  GDTAdLoadConfig,
  GDTAdLoadListener,
  GDTBannerAd,
  GDTRenderListener,
  GDTInteractionListener,
  GDTVideoStateListener,
  GDTAdSize,
  GDTError,
} from '@gdt/gdt-union-sdk';
import BannerView from "./BannerView";
import { emitter } from '@kit.BasicServicesKit';
import FlutterTencentadConfig from '../FlutterTencentadConfig';
import TencentAdUtil from '../TencentAdUtil';

@Component
export struct BannerNativeView {
  @Prop params: Params;
  bannerView: BannerView = this.params.platformView as BannerView;
  @State bannerAd?: GDTBannerAd = undefined;
  @State bannerAdComponent?: NodeController = undefined;
  @State isShowAd: boolean = false;
  @State adWidth: number = 0;
  @State adHeight: number = 0;
  posId: string = '';
  viewWidth: number = 0;
  viewHeight: number = 0;
  isBidding: boolean = false;
  windowStage?: window.WindowStage;
  // 订阅事件
  event: emitter.InnerEvent = {
    eventId: FlutterTencentadConfig.BannerEventId
  };
  // 接收事件
  callback: Callback<emitter.EventData> = (eventData: emitter.EventData) => {
    TencentAdUtil.biddingCallback(eventData, this.bannerAd, (): void => this.renderAD());
  }

  build() {
    Row() {
      if (this.bannerAdComponent && this.isShowAd) {
        NodeContainer(this.bannerAdComponent)
          .width(this.adWidth > 0 ? this.adWidth : this.viewWidth)
          .height(this.adHeight > 0 ? this.adHeight : this.viewHeight)
          .alignSelf(ItemAlign.Center)
          .align(Alignment.Center);
      }
    }
    .width(this.viewWidth)
    .height(this.viewHeight)
  }

  aboutToAppear(): void {
    emitter.on(this.event, this.callback);
    this.posId = this.bannerView.getPosId();
    this.viewWidth = this.bannerView.getViewWidth();
    this.viewHeight = this.bannerView.getViewHeight();
    this.isBidding = this.bannerView.getIsBidding();
    this.windowStage = this.bannerView.getWindowStage();

    this.loadAd();
  }

  private loadAd() {
    const config: GDTAdLoadConfig = {
      posId: this.posId,
      adSize: new GDTAdSize(this.viewWidth, this.viewHeight)
    };

    const renderListener: GDTRenderListener = {
      onRenderSuccess: (): void => {
        console.info("BannerNativeView Banner广告渲染成功");
        this.bannerAdComponent = this.bannerAd?.getAdComponent();
        this.isShowAd = true;

        const width = this.bannerAd?.getAcceptWidth() ?? this.viewWidth;
        const height = this.bannerAd?.getAcceptHeight() ?? this.viewHeight;
        this.adWidth = width;
        this.adHeight = height;

        this.bannerView.sendMsg("onShow", { "width": width, "height": height });
      },
      onRenderFail: (): void => {
        console.error("BannerNativeView Banner广告渲染失败");
        this.bannerView.sendMsg("onFail", { "code": -1, "message": "Banner广告渲染失败" });
        this.isShowAd = false;
      }
    };

    const interactionListener: GDTInteractionListener = {
      onAdExposure: (): void => {
        console.info("BannerNativeView Banner广告曝光");
        this.bannerView.sendMsg("onExpose", "Banner广告曝光");
      },
      onAdClick: (): void => {
        console.info("BannerNativeView Banner广告点击");
        this.bannerView.sendMsg("onClick", "Banner广告点击");
      },
      onAdClose: (): void => {
        console.info("BannerNativeView Banner广告关闭");
        this.bannerView.sendMsg("onClose", "Banner广告关闭");
        this.isShowAd = false;
        this.bannerAd?.destroy();
        this.bannerAd = undefined;
        this.bannerAdComponent = undefined;
      },
      onError: (err: GDTError): void => {
        console.error(`BannerNativeView Banner广告错误: ${err.code}, ${err.message}`);
        this.bannerView.sendMsg("onFail", { "code": err.code, "message": err.message });
      }
    };

    const videoStateListener: GDTVideoStateListener = {
      onVideoReady: (): void => {
      },
      onVideoStart: (): void => {
      },
      onVideoPause: (): void => {
      },
      onVideoResume: (): void => {
      },
      onVideoComplete: (): void => {
      },
      onVideoError: (err: GDTError): void => {
      }
    };

    const adLoadListener: GDTAdLoadListener<GDTBannerAd> = {
      onAdLoad: (ad: GDTBannerAd): void => {
        console.info("BannerNativeView Banner广告加载成功");
        this.bannerAd = ad;

        if (this.isBidding) {
          const ecpm: number = ad.getEcpm?.() ?? 0;
          const ecpmLevel: string = "";
          this.bannerView.sendMsg("onECPM", { "ecpmLevel": ecpmLevel, "ecpm": ecpm });
        }

        // 设置监听器
        ad.setRenderListener(renderListener);
        ad.setInteractionListener(interactionListener);
        ad.setVideoStateListener(videoStateListener);
        ad.setRefresh(30); // 30秒轮播

        // 没有竞价，直接展示
        if (!this.isBidding) {
          this.renderAD();
          console.info("Banner广告 没有竞价，广告展示");
        }
      },
      onError: (err: GDTError): void => {
        console.error(`BannerNativeView Banner广告加载失败: ${err.code}, ${err.message}`);
        this.bannerView.sendMsg("onFail", { "code": err.code, "message": err.message });
      }
    };

    GDTAdSDK.getAdLoader().loadBannerAd(config, adLoadListener);
  }

  /**
   * 渲染广告
   */
  private renderAD() {
    // 延时执行逻辑，要不然只会渲染最后一条广告
    setTimeout(() => {
      console.info("Banner广告 延时执行逻辑 eCpm: " + this.bannerAd?.getEcpm());
      if (this.bannerAd?.isValid()) {
        this.bannerAd?.render(this.windowStage, this.getUIContext());
      }
    }, 500);
  }

  aboutToDisappear(): void {
    emitter.off(FlutterTencentadConfig.BannerEventId);
    if (this.bannerAd) {
      this.bannerAd.destroy();
      this.bannerAd = undefined;
      this.bannerAdComponent = undefined;
    }
  }
}

@Builder
export function BannerBuilder(params: Params) {
  BannerNativeView({
    params: params,
  })
}
