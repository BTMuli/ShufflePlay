// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:webview_windows/webview_windows.dart';

// Project imports:
import 'log_tool.dart';

/// webview 工具
class SPWebviewTool {
  SPWebviewTool._();

  static final SPWebviewTool _instance = SPWebviewTool._();

  /// 获取实例
  factory SPWebviewTool() => _instance;

  /// 初始化
  static Future<void> init() async {
    var webviewDataDir = await getTemporaryDirectory();
    try {
      await WebviewController.initializeEnvironment(
        userDataPath: path.join(webviewDataDir.path, 'ShufflePlay', 'Webview'),
      );
    } on PlatformException catch (e) {
      SPLogTool.warn('[Webview] Fail to initialize webview: ${e.message}');
    }
  }
}
