// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';

// Project imports:
import 'app.dart';
import 'database/sp_sqlite.dart';
import 'tools/log_tool.dart';
import 'tools/webview_tool.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await Window.initialize();
  await SystemTheme.accentColor.load();

  /// 初始化配置
  await SPLogTool().init();
  await SPSqlite().init();
  // 如果是Windows平台，初始化WebView，否则不初始化
  if (defaultTargetPlatform == TargetPlatform.windows) {
    await SPWebviewTool.init();
  }

  WindowOptions windowOptions = const WindowOptions(
    title: 'ShufflePlay',
    size: Size(1280, 720),
    center: true,
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
  });

  runApp(const ProviderScope(child: SPApp()));
  if (defaultTargetPlatform == TargetPlatform.windows) {
    await Window.setEffect(effect: WindowEffect.acrylic);
  }
}
