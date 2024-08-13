// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../tools/file_tool.dart';
import '../../tools/log_tool.dart';
import '../../ui/sp_webview.dart';

/// 测试页面
class AppDevPage extends ConsumerStatefulWidget {
  /// 构造函数
  const AppDevPage({super.key});

  @override
  ConsumerState<AppDevPage> createState() => _AppDevPageState();
}

/// 测试页面状态
class _AppDevPageState extends ConsumerState<AppDevPage> {
  SpWebviewController? controller;

  /// 创建新窗口
  Future<void> createNewWindow() async {
    if (!mounted) return;
    var fileTool = SPFileTool();
    var filePath = await fileTool.getAssetsPath('lib/test.html');
    if (!mounted) return;
    controller = await SpWebview.createWebview(context, filePath);
    controller!.listen('message', callback: (event) {
      SPLogTool.info('[Webview] Receive message: $event');
    });
    if (mounted) await controller!.show(context);
  }

  /// 构建函数
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(title: Text('Test Page')),
      content: Center(
        child: IconButton(
          icon: const Icon(FluentIcons.f12_dev_tools),
          onPressed: () async {
            await createNewWindow();
          },
        ),
      ),
    );
  }
}
