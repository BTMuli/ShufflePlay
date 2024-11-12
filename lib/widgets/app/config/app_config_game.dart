// Dart imports:
import 'dart:io';

// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

// Project imports:
import '../../../models/database/user/user_bbs_model.dart';
import '../../../models/database/user/user_nap_model.dart';
import '../../../models/nap/token/nap_auth_ticket_model.dart';
import '../../../request/nap/nap_api_passport.dart';
import '../../../store/app/app_config.dart';
import '../../../store/user/user_bbs.dart';
import '../../../tools/file_tool.dart';
import '../../../ui/sp_dialog.dart';
import '../../../ui/sp_icon.dart';
import '../../../ui/sp_infobar.dart';

class AppConfigGameWidget extends ConsumerStatefulWidget {
  const AppConfigGameWidget({super.key});

  @override
  ConsumerState<AppConfigGameWidget> createState() =>
      _AppConfigGameWidgetState();
}

class _AppConfigGameWidgetState extends ConsumerState<AppConfigGameWidget> {
  /// 当前用户
  UserBBSModel? get user => ref.watch(userBbsStoreProvider).user;

  /// 当前账户
  UserNapModel? get account => ref.watch(userBbsStoreProvider).account;

  /// 文件工具
  final SPFileTool fileTool = SPFileTool();

  /// api
  final SprNapApiPassport apiNap = SprNapApiPassport();

  /// 游戏目录
  String? get gameDir => ref.watch(appConfigStoreProvider).gameDir;

  /// 尝试编辑游戏目录
  Future<void> tryEditGameDir() async {
    var dir = await fileTool.selectDir();
    if (dir == null) {
      if (mounted) await SpInfobar.warn(context, '未选择目录');
      return;
    }
    var gamePath = path.join(dir, 'ZenlessZoneZero.exe');
    var checkFile = await fileTool.isFileExist(gamePath);
    if (!checkFile) {
      if (mounted) await SpInfobar.warn(context, '未检测到 ZenlessZoneZero.exe');
      return;
    }
    await ref.read(appConfigStoreProvider.notifier).setGameDir(dir);
    if (mounted) await SpInfobar.success(context, '成功设置游戏目录');
    setState(() {});
  }

  /// 尝试启动游戏
  Future<void> tryLaunchGame() async {
    if (gameDir == null || gameDir!.isEmpty) {
      if (mounted) await SpInfobar.warn(context, '请先设置游戏目录');
      return;
    }
    var gamePath = path.join(gameDir!, 'ZenlessZoneZero.exe');
    var checkFile = await fileTool.isFileExist(gamePath);
    if (!checkFile) {
      if (mounted) {
        await SpInfobar.warn(context, '未检测到 ZenlessZoneZero.exe');
      }
      return;
    }
    if (account == null || user == null) {
      if (mounted) await SpInfobar.warn(context, '请先登录');
      return;
    }
    if (mounted) {
      var confirm = await SpDialog.confirm(
        context,
        '启动游戏',
        '当前账户：${account!.gameUid}(${account!.regionName})',
      );
      if (confirm == null || !confirm) {
        if (mounted) await SpInfobar.warn(context, '取消启动游戏');
        return;
      }
      var ticketResp = await apiNap.getLoginAuthTicket(account!, user!.cookie!);
      if (ticketResp.retcode != 0) {
        if (mounted) await SpInfobar.bbs(context, ticketResp);
        return;
      }
      var ticketData = ticketResp.data as NapAuthTicketModelData;
      await Process.run(
        gamePath,
        ['login_auth_ticket=${ticketData.ticket}'],
        runInShell: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expander(
      leading: Icon(FluentIcons.game),
      header: Text('游戏相关'),
      trailing: Tooltip(
        message: '启动游戏',
        child: IconButton(
          icon: SPIcon(FluentIcons.rocket),
          onPressed: tryLaunchGame,
        ),
      ),
      content: Column(
        children: [
          ListTile(
            leading: Icon(FluentIcons.folder),
            title: Text('游戏目录'),
            subtitle: Text(gameDir ?? '未设置'),
            trailing: IconButton(
              icon: SPIcon(FluentIcons.edit),
              onPressed: tryEditGameDir,
            ),
          )
        ],
      ),
    );
  }
}
