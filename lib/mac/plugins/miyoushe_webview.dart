// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Project imports:
import '../../models/bbs/bbs_base_model.dart';
import '../../models/bbs/bbs_constant_enum.dart';
import '../../models/bbs/bridge/bbs_bridge_model.dart';
import '../../plugins/Miyoushe/bridge_handler.dart';
import '../../plugins/Miyoushe/miyoushe_webview.dart';
import '../../shared/tools/log_tool.dart';

class MysControllerMac extends ChangeNotifier implements MiyousheController {
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

  late WebViewController webview =
      WebViewController(onPermissionRequest: (request) {
    SPLogTool.debug('[Miyoushe] Permission request: $request');
  });

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
    routeStack = [url];
    await webview.setJavaScriptMode(JavaScriptMode.unrestricted);
    await webview.setUserAgent(this.userAgent);
    await webview.addJavaScriptChannel(
      'MiHoYoJSInterface',
      onMessageReceived: (res) => {
        SPLogTool.debug('[Miyoushe] Received message: ${res.message}'),
        handleMessage(res.message),
      },
    );
    await webview.loadRequest(Uri.parse('about:blank'));
    await webview.loadRequest(Uri.parse(url));
  }

  @override
  Future<void> callback(String cb, dynamic data) async {
    BBSResp resp = BBSResp.success(data: data);
    await executeScript('javascript:mhyWebBridge("$cb", $resp)');
  }

  @override
  Future<void> callbackNull(String cb) async => await callback(cb, null);

  @override
  Future<void> close() async => Navigator.of(context).pop();

  @override
  Future<void> executeScript(String script) async {
    await webview.runJavaScript(script);
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
  Future<void> loadUrl(String url) async {
    await webview.loadRequest(Uri.parse(url));
  }

  @override
  Future<void> show(BuildContext context) async {
    this.context = context;
    await showMacosSheet(
      context: context,
      builder: (_) => MacosSheet(
        insetPadding: EdgeInsets.symmetric(
          horizontal: (1280.w - width) / 2,
          vertical: 60.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(title),
                MacosIconButton(
                  icon: MacosIcon(Icons.refresh),
                  onPressed: webview.reload,
                ),
                MacosIconButton(
                  icon: MacosIcon(Icons.clear),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            MysClientMac(this),
          ],
        ),
      ),
    );
  }

  @override
  Future<void> loadJSBridge() async {
    SPLogTool.debug('[Miyoushe] Load JS bridge');
  }
}

class MysClientMac extends ConsumerStatefulWidget {
  final MysControllerMac controller;

  const MysClientMac(this.controller, {super.key});

  static Future<MysControllerMac> create(
    BuildContext context,
    String url, {
    double? width,
    double? height,
    String? title,
    String? userAgent,
  }) async {
    var controller = MysControllerMac();
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
  static Future<MysControllerMac> createGameRecords(
    BuildContext context, {
    double? width,
    double? height,
  }) async {
    var link =
        "https://webstatic.mihoyo.com/app/community-game-records/index.html?bbs_presentation_style=fullscreen";
    return create(context, link, width: width, height: height);
  }

  /// 创建页面-签到
  static Future<MysControllerMac> createSign(
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
  ConsumerState<MysClientMac> createState() => _MysClientMacState();
}

class _MysClientMacState extends ConsumerState<MysClientMac> {
  @override
  void initState() {
    widget.controller.ref = ref;
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: WebViewWidget(
        controller: widget.controller.webview,
      ),
    );
  }
}
