// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'app.dart';
import 'database/sp_sqlite.dart';
import 'tools/log_tool.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 初始化配置
  await SPLogTool().init();
  await SPSqlite().init();

  runApp(const SPApp());
}
