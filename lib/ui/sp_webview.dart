// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';

// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_windows/webview_windows.dart';

// Project imports:
import '../tools/log_tool.dart';

class SpWebviewController extends ChangeNotifier {
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

  /// 默认userAgent
  static const String _defaultUserAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
      'AppleWebKit/537.36 (KHTML, like Gecko) '
      'Chrome/58.0.3029.110 Safari/537.3';

  /// 初始化
  Future<void> initWebviewController() async {
    await webview.initialize();
    await webview.setUserAgent(userAgent);
    await webview.loadUrl(url);
    await webview.setBackgroundColor(Colors.transparent);
    await webview.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
  }

  /// 初始化
  Future<void> initialize(
    String url, {
    String? title,
    double? width,
    double? height,
    String? userAgent,
  }) async {
    this.url = url;
    this.width = width ?? 1000.w;
    this.height = height ?? 600.h;
    this.title = title ?? 'Webview';
    this.userAgent = userAgent ?? _defaultUserAgent;
    webview = WebviewController();
    try {
      await initWebviewController();
    } on PlatformException catch (e) {
      SPLogTool.warn('[Webview] Fail to initialize webview: ${e.message}');
    }
    notifyListeners();
  }

  /// 显示
  Future<void> show(BuildContext context) async {
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (_) => ContentDialog(
          title: Row(
            children: [
              Text(title),
              SizedBox(width: 10.w),
              Text(url, style: const TextStyle(fontSize: 12)),
              const Spacer(),
              IconButton(
                icon: const Icon(FluentIcons.refresh),
                onPressed: webview.reload,
              ),
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
          constraints: BoxConstraints(
            maxWidth: width,
            maxHeight: height,
            minWidth: width,
            minHeight: height,
          ),
          content: SpWebview(this),
        ),
      );
    }
  }

  /// 执行脚本
  Future<dynamic> executeScript(String script) async {
    return await webview.executeScript(script);
  }

  @override
  void dispose() {
    super.dispose();
    webview.dispose();
    notifyListeners();
  }
}

class SpWebview extends StatefulWidget {
  final SpWebviewController controller;

  const SpWebview(this.controller, {super.key});

  static Future<SpWebviewController> createWebview(
    BuildContext context,
    String url, {
    double? width,
    double? height,
    String? title,
    String? userAgent,
  }) async {
    var controller = SpWebviewController();
    await controller.initialize(
      url,
      title: title,
      width: width,
      height: height,
      userAgent: userAgent,
    );
    return controller;
  }

  @override
  State<SpWebview> createState() => _SpWebviewState();
}

class _SpWebviewState extends State<SpWebview> {
  @override
  Widget build(BuildContext context) {
    return Webview(
      widget.controller.webview,
      width: widget.controller.width,
      height: widget.controller.height,
    );
  }
}
