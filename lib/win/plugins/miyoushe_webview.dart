// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Icons;

// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_windows/webview_windows.dart';

// Project imports:
import '../../models/bbs/bbs_base_model.dart';
import '../../models/bbs/bbs_constant_enum.dart';
import '../../models/bbs/bridge/bbs_bridge_model.dart';
import '../../plugins/Miyoushe/bridge_handler.dart';
import '../../plugins/Miyoushe/miyoushe_webview.dart';
import '../../shared/tools/log_tool.dart';

class MysControllerWin extends ChangeNotifier implements MiyousheController {
  @override
  late BuildContext context;

  @override
  late double height;

  @override
  late WidgetRef? ref;

  @override
  List<String> routeStack = [];

  @override
  late String title;

  @override
  late String url;

  @override
  late String userAgent;

  @override
  late double width;

  late MysWebviewWin webview;

  @override
  Future<void> initialize(
    String url, {
    String? title,
    double? width,
    double? height,
    String? userAgent,
  }) async {
    this.url = url;
    this.width = width ?? 400;
    this.height = height ?? 600;
    this.title = title ?? '米游社';
    this.userAgent = userAgent ?? bbsUaMobile;
    webview = MysWebviewWin._();
    routeStack = [url];
    try {
      await webview.initController(this);
    } catch (e) {
      SPLogTool.error('[Miyoushe] Fail to initialize controller: $e');
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    webview.dispose();
    notifyListeners();
  }

  @override
  Future<void> callback(String cb, dynamic data) async {
    BBSResp resp = BBSResp.success(data: data);
    SPLogTool.debug('[Miyoushe] Callback: $cb, $resp');
    await executeScript('javascript:mhyWebBridge($cb, $resp)');
  }

  @override
  Future<void> handleMessage(dynamic message) async {
    if (message is! String) return;
    try {
      message = jsonDecode(message);
    } on FormatException catch (e) {
      SPLogTool.warn('[Miyoushe] Fail to decode message: $e');
      return;
    }
    var bridgeData = BbsBridgeModel.fromJson(
      message,
      (json) => json as Map<String, dynamic>,
    );
    await handleBridgeMessage(bridgeData, this);
  }

  @override
  Future<void> loadJSBridge() async {
    var bridgeJS = '''javascript:(function() {
      if(window.MiHoYoJSInterface) return;
      window.MiHoYoJSInterface = {
        postMessage: function(arg) => window.chrome.webview.postMessage(arg),
        closePage: function() { this.postMessage('{"method":"closePage"}') },
      };
    })();''';
    await executeScript(bridgeJS);
  }

  @override
  Future<void> executeScript(String script) async {
    await webview.webview.executeScript(script);
  }

  @override
  Future<void> loadUrl(String url) async {
    await webview.webview.loadUrl(url);
  }

  @override
  Future<void> reload() async {
    await webview.reload();
  }

  @override
  Future<void> show(BuildContext context) async {
    this.context = context;
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (_) => ContentDialog(
          title: Row(
            children: [
              Text(title),
              const Spacer(),
              IconButton(
                icon: const Icon(FluentIcons.refresh),
                onPressed: reload,
              ),
              if (kDebugMode)
                IconButton(
                  icon: const Icon(Icons.developer_mode),
                  onPressed: () async => await webview.openDevTools(),
                ),
              IconButton(
                icon: const Icon(FluentIcons.chrome_close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          content: MysClientWin(this),
        ),
      );
    }
  }

  @override
  Future<void> callbackNull(String cb) async => await callback(cb, null);

  @override
  Future<void> close() async => Navigator.pop(context);
}

class MysWebviewWin implements MiyousheWebview {
  MysWebviewWin._();

  late WebviewController webview = WebviewController();

  @override
  Future<void> addListener(void Function(dynamic event) callback) async {
    webview.webMessage.listen(callback);
  }

  @override
  Future<void> initController(MiyousheController controller) async {
    await webview.initialize();
    webview.webMessage.listen(controller.handleMessage);
    await controller.loadJSBridge();
    await webview.setUserAgent(controller.userAgent);
    await webview.loadUrl(controller.url);
    await controller.loadJSBridge();
    await webview.setBackgroundColor(Colors.transparent);
    await webview.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
    SPLogTool.debug('[Miyoushe] Initialize webview: ${controller.url}');
  }

  @override
  Future<void> reload() async {
    await webview.reload();
  }

  @override
  Future<void> openDevTools() async {
    await webview.openDevTools();
  }

  @override
  Future<void> dispose() async {
    await webview.dispose();
  }
}

class MysClientWin extends ConsumerStatefulWidget {
  final MysControllerWin controller;

  const MysClientWin(this.controller, {super.key});

  static Future<MysControllerWin> create(
    BuildContext context,
    String url, {
    double? width,
    double? height,
    String? title,
    String? userAgent,
  }) async {
    var controller = MysControllerWin();
    await controller.initialize(
      url,
      width: width,
      height: height,
      title: title,
      userAgent: userAgent,
    );
    return controller;
  }

  static Future<MysControllerWin> createRecords(
    BuildContext context, {
    double? width,
    double? height,
  }) async {
    return create(
      context,
      'https://webstatic.mihoyo.com/app/community-game-records/index.html?bbs_presentation_style=fullscreen',
      width: width,
      height: height,
    );
  }

  static Future<MysControllerWin> createSign(
    BuildContext context, {
    double? width,
    double? height,
  }) async {
    var link =
        "https://act.mihoyo.com/bbs/event/signin/zzz/e202406242138391.html?"
        "act_id=e202406242138391&mhy_auth_required=true&"
        "mhy_presentation_style=fullscreen&utm_source=bbs&utm_medium=zzz&"
        "utm_campaign=icon";
    return create(context, link, width: width, height: height);
  }

  static Future<bool> check() async {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      return await WebviewController.getWebViewVersion() != null;
    }
    return false;
  }

  @override
  ConsumerState<MysClientWin> createState() => _MysClientWinState();
}

class _MysClientWinState extends ConsumerState<MysClientWin> {
  @override
  void initState() {
    widget.controller.ref = ref;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Webview(
      widget.controller.webview.webview,
      width: widget.controller.width,
      height: widget.controller.height,
    );
  }
}