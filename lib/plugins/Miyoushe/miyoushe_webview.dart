// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview_mac;
import 'package:webview_windows/webview_windows.dart';

// Project imports:
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
    await controller.loadJSBridge(isFirst: true);
    await webWin!.setUserAgent(controller.userAgent);
    await loadUrl(controller.url);
    await controller.loadJSBridge();
    SPLogTool.debug('[Miyoushe] Initialize webview: ${controller.url}');
    await webWin!.setBackgroundColor(Colors.transparent);
    await webWin!.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
  }

  /// 初始化控制器-Mac
  Future<void> initControllerMac(MiyousheController controller) async {
    await webMac!.setJavaScriptMode(webview_mac.JavaScriptMode.unrestricted);
    await webMac!.setBackgroundColor(Colors.transparent);
    await webMac!.setUserAgent(controller.userAgent);
    await controller.loadJSBridge(isFirst: true);
    await loadUrl(controller.url);
    await controller.loadJSBridge();
    SPLogTool.debug('[Miyoushe] Initialize webview: ${controller.url}');
  }

  /// 添加监听
  void addListener(void Function(dynamic event) callback) {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      webWin!.webMessage.listen((event) => callback(event));
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      webMac!.addJavaScriptChannel(
        'jsBridge',
        onMessageReceived: (message) => callback(message.message),
      );
    }
  }

  /// 执行JS代码
  Future<void> executeScript(String script) async {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      await webWin!.executeScript(script);
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      await webMac!.runJavaScript(script);
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
