// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';

// Project imports:
import '../shared/database/sp_sqlite.dart';
import '../shared/tools/log_tool.dart';
import 'app.dart';

Future<void> mainMac() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await SystemTheme.accentColor.load();
  await SPLogTool().init();
  await SPSqlite().init();
  WindowOptions windowOptions = const WindowOptions(
    title: 'ShufflePlay',
    size: Size(1280, 720),
    center: true,
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
  });
  runApp(const ProviderScope(child: SPApp()));
}
