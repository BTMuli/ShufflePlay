// Dart imports:
import 'dart:io';

// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../models/nap/token/nap_auth_ticket_model.dart';
import '../../request/nap/nap_api_passport.dart';
import '../../store/user/user_bbs.dart';
import '../../tools/file_tool.dart';
import '../../tools/log_tool.dart';
import '../../ui/sp_infobar.dart';
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

  Future<void> getAuthTicket() async {
    var curUser = ref.read(userBbsStoreProvider).user;
    if (curUser == null) {
      if (mounted) {
        await SpInfobar.warn(context, '请先登录');
      }
      return;
    }
    var curAccount = ref.read(userBbsStoreProvider).account;
    if (curAccount == null) {
      if (mounted) {
        await SpInfobar.warn(context, '请先登录');
      }
      return;
    }
    var apiNap = SprNapApiPassport();
    var authTicketResp = await apiNap.getLoginAuthTicket(
      curAccount,
      curUser.cookie!,
    );
    if (authTicketResp.retcode != 0) {
      if (mounted) {
        await SpInfobar.bbs(context, authTicketResp);
      }
      return;
    }
    var ticketData = authTicketResp.data as NapAuthTicketModelData;
    if (mounted) {
      await SpInfobar.success(context, '成功获取 authTicket: ${ticketData.ticket}');
    }
    // todo 用户设置游戏路径
    var startTime = DateTime.now();
    const gamePath =
        "D:\\Games\\miHoYo Launcher\\games\\ZenlessZoneZero Game\\ZenlessZoneZero.exe";
    // 以管理员权限运行 exe login_auth_ticket=xxx
    var result = await Process.run(
      gamePath,
      ['login_auth_ticket=${ticketData.ticket}'],
      runInShell: true,
    );
    var timeCost = DateTime.now().difference(startTime).inMilliseconds;
    SPLogTool.info('Run game time cost: $timeCost ms');
    SPLogTool.info(result.stdout);
    SPLogTool.info(result.stderr);
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
            // await createNewWindow();
            await getAuthTicket();
          },
        ),
      ),
    );
  }
}
