// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';

// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_windows/webview_windows.dart';

// Project imports:
import '../../models/bbs/bbs_base_model.dart';
import '../../models/bbs/bbs_constant_enum.dart';
import '../../models/bbs/bridge/bbs_bridge_model.dart';
import '../../tools/log_tool.dart';
import 'bridge_handler.dart';

class MiyousheController extends ChangeNotifier {
  late WidgetRef? ref;

  late BuildContext context;

  /// 窗口链接
  late String url;

  /// 窗口宽度
  late double width;

  /// 窗口高度
  late double height;

  /// 窗口标题
  late String title;

  /// 窗口userAgent
  late String userAgent;

  /// 窗口控制器
  late WebviewController webview;

  List<String> routeStack = [];

  Future<void> initialize(
    String url, {
    String? title,
    double? width,
    double? height,
    String? userAgent,
  }) async {
    this.url = url;
    this.width = width ?? 400.sp;
    this.height = height ?? 600.sp;
    this.title = title ?? '米游社';
    this.userAgent = userAgent ?? bbsUaMobile;
    webview = WebviewController();
    routeStack = [url];
    try {
      await initWebviewController();
    } on PlatformException catch (e) {
      SPLogTool.warn('[Miyoushe] Fail to initialize webview: ${e.message}');
    }
    notifyListeners();
  }

  Future<void> initWebviewController() async {
    await webview.initialize();
    await loadJSBridge(isFirst: true);
    await webview.setUserAgent(userAgent);
    await webview.loadUrl(url);
    await loadJSBridge();
    SPLogTool.debug('[Miyoushe] Initialize webview: $url');
    await webview.setBackgroundColor(Colors.transparent);
    await webview.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
  }

  @override
  void dispose() {
    super.dispose();
    webview.dispose();
    notifyListeners();
  }

  /// 执行脚本
  Future<dynamic> executeScript(String script) async {
    return await webview.executeScript(script);
  }

  /// 加载 JSBridge
  Future<void> loadJSBridge({bool isFirst = false}) async {
    if (isFirst) webview.webMessage.listen(handleMessage);
    var bridgeJS = '''javascript:(function() {
      if(window.MiHoYoJSInterface) return;
      window.MiHoYoJSInterface = {
        postMessage: function(arg) { 
          window.chrome.webview.postMessage(arg);
        },
        closePage: function() { this.postMessage('{"method":"closePage"}') },
      };
    })();''';
    await webview.executeScript(bridgeJS);
  }

  /// callback null
  Future<void> callbackNull(String cb) async => await callback(cb, null);

  /// callback
  Future<void> callback(String cb, dynamic data) async {
    BBSResp resp = BBSResp.success(data: data);
    SPLogTool.debug('[Miyoushe] Callback: $cb, $resp');
    await webview.executeScript('javascript:mhyWebBridge("$cb", $resp)');
  }

  /// 处理消息
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

  /// 刷新
  Future<void> reload() async {
    await webview.reload();
    await loadJSBridge();
  }

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
                  icon: const Icon(material.Icons.developer_mode),
                  onPressed: webview.openDevTools,
                ),
              IconButton(
                icon: const Icon(FluentIcons.chrome_close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          content: MiyousheClient(this),
        ),
      );
    }
  }

  /// close
  Future<void> close() async => Navigator.pop(context);
}

class MiyousheClient extends ConsumerStatefulWidget {
  /// webview controller
  final MiyousheController controller;

  const MiyousheClient(this.controller, {super.key});

  static Future<MiyousheController> create(
    BuildContext context,
    String url, {
    double? width,
    double? height,
    String? title,
    String? userAgent,
  }) async {
    var controller = MiyousheController();
    await controller.initialize(
      url,
      title: title,
      width: width,
      height: height,
      userAgent: userAgent,
    );
    return controller;
  }

  /// 创建页面-战绩
  static Future<MiyousheController> createGameRecords(
    BuildContext context, {
    double? width,
    double? height,
  }) async {
    var link =
        "https://webstatic.mihoyo.com/app/community-game-records/index.html?bbs_presentation_style=fullscreen";
    return create(context, link, width: width, height: height);
  }

  /// 创建页面-签到
  static Future<MiyousheController> createSign(
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

  @override
  ConsumerState<MiyousheClient> createState() => _MiyousheClientState();
}

class _MiyousheClientState extends ConsumerState<MiyousheClient> {
  @override
  void initState() {
    widget.controller.ref = ref;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Webview(
      widget.controller.webview,
      width: widget.controller.width,
      height: widget.controller.height,
    );
  }
}
