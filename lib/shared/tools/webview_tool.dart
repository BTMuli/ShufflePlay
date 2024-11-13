// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:webview_windows/webview_windows.dart';

// Project imports:
import 'file_tool.dart';
import 'log_tool.dart';

/// webview 工具
class SPWebviewTool {
  SPWebviewTool._();

  static final SPWebviewTool _instance = SPWebviewTool._();

  /// 获取实例
  factory SPWebviewTool() => _instance;

  /// 初始化
  static Future<void> init() async {
    var fileTool = SPFileTool();
    var webviewDataDir = await fileTool.getAppDataPath('webview');
    try {
      await WebviewController.initializeEnvironment(
        userDataPath: webviewDataDir,
      );
    } on PlatformException catch (e) {
      SPLogTool.warn('[Webview] Fail to initialize webview: ${e.message}');
    }
  }
}
