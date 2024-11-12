// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview_mac;
import 'package:webview_windows/webview_windows.dart';

// Project imports:
import '../../models/bbs/bbs_base_model.dart';
import '../../tools/log_tool.dart';
import '../../ui/sp_infobar.dart';
import 'miyoushe_client.dart';

class MiyousheWebview {
  late webview_mac.WebViewController? webMac;
  late WebviewController? webWin;

  MiyousheWebview() {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      webWin = WebviewController();
      webMac = null;
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      webWin = null;
      webMac = webview_mac.WebViewController();
    } else {
      webWin = null;
      webMac = null;
    }
  }

  Future<void> initController(MiyousheController controller) async {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      await initControllerWin(controller);
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      await initControllerMac(controller);
    }
  }

  /// 初始化控制器-Windows
  Future<void> initControllerWin(MiyousheController controller) async {
    await webWin!.initialize();
    webWin!.addListener(controller.handleMessage as VoidCallback);
    await loadJSBridgeWin();
    await webWin!.setUserAgent(controller.userAgent);
    await loadUrl(controller.url);
    await loadJSBridgeWin();
    SPLogTool.debug('[Miyoushe] Initialize webview: ${controller.url}');
    await webWin!.setBackgroundColor(Colors.transparent);
    await webWin!.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
  }

  /// 初始化控制器-Mac
  Future<void> initControllerMac(MiyousheController controller) async {
    await webMac!.setJavaScriptMode(webview_mac.JavaScriptMode.unrestricted);
    await webMac!.setUserAgent(controller.userAgent);
    await webMac!.addJavaScriptChannel(
      'MiHoYoJSInterface',
      onMessageReceived: (res) => {
        SPLogTool.debug('[Miyoushe] Received message: ${res.message}'),
        controller.handleMessage(res.message),
      },
    );
    await webMac!.loadRequest(Uri.parse("about:blank"));
    // await loadJSBridgeMac();
    await webMac!.loadRequest(Uri.parse(controller.url));
    // await loadJSBridgeMac();
    SPLogTool.debug('[Miyoushe] Initialize webview: ${controller.url}');
  }

  /// 添加监听
  Future<void> addListener(void Function(dynamic event) callback) async {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      webWin!.webMessage.listen((event) => callback(event));
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      await webMac!.addJavaScriptChannel(
        'MiHoYoJSInterface',
        onMessageReceived: (message) => {
          SPLogTool.debug('[Miyoushe] Received message: $message'),
          callback(message),
        },
      );
    }
  }

  /// loadJSBridge
  Future<void> loadJSBridge() async {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      await loadJSBridgeWin();
    }
  }

  /// loadJSBridge
  Future<void> loadJSBridgeWin() async {
    var bridgeJS = '''javascript:(function() {
      if(window.MiHoYoJSInterface) return;
      window.MiHoYoJSInterface = {
        postMessage: function(arg) => window.chrome.webview.postMessage(arg),
        closePage: function() { this.postMessage('{"method":"closePage"}') },
      };
    })();''';
    await webWin!.executeScript(bridgeJS);
  }

  /// 执行JS代码
  Future<void> executeScript(String script) async {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      await webWin!.executeScript(script);
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      if (script.startsWith("javascript:")) {
        script = script.substring(11);
      }
      try {
        await webMac!.runJavaScript(script);
      } on Exception catch (e) {
        SPLogTool.warn('[Miyoushe] Fail to execute script: $e}');
      }
    }
  }

  Future<void> callback(String cb, BBSResp resp) async {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      await webWin!.executeScript('javascript:mhyWebBridge("$cb", $resp)');
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      try {
        await webMac!.runJavaScript('mhyWebBridge("$cb", $resp)');
      } on Exception catch (e) {
        SPLogTool.warn('[Miyoushe] Fail to execute script: $e}');
      }
    }
  }

  /// loadUrl
  Future<void> loadUrl(String url) async {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      await webWin!.loadUrl(url);
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      await webMac!.loadRequest(Uri.parse(url));
    }
  }

  /// reload
  Future<void> reload() async {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      await webWin!.reload();
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      await webMac!.reload();
    }
  }

  /// openDevTools
  Future<void> openDevTools(BuildContext context) async {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      await webWin!.openDevTools();
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      if (context.mounted) {
        await SpInfobar.warn(context, 'Unsupported operation');
      }
    }
  }

  /// dispose
  void dispose() {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      webWin!.dispose();
    }
  }
}
