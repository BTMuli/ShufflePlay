// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:window_manager/window_manager.dart';

// Project imports:
import '../../models/database/user/user_bbs_model.dart';
import '../../models/database/user/user_nap_model.dart';
import '../../models/nap/token/nap_auth_ticket_model.dart';
import '../../plugins/Miyoushe/miyoushe_client.dart';
import '../../request/nap/nap_api_passport.dart';
import '../../shared/store/user_bbs.dart';
import '../../shared/tools/file_tool.dart';
import '../../shared/utils/get_app_theme.dart';
import '../pages/app_config.dart';
import '../pages/app_dev.dart';
import '../pages/nap_anno.dart';
import '../pages/user_gacha.dart';
import '../store/app_config.dart';
import '../ui/sp_icon.dart';
import '../ui/sp_infobar.dart';

class AppNavWidget extends ConsumerStatefulWidget {
  const AppNavWidget({super.key});

  @override
  ConsumerState<AppNavWidget> createState() => _AppNavWidgetState();
}

class _AppNavWidgetState extends ConsumerState<AppNavWidget>
    with AutomaticKeepAliveClientMixin {
  /// 当前索引
  int curIndex = 0;

  /// 当前主题模式
  ThemeMode get curThemeMode => ref.watch(appConfigStoreProvider).themeMode;

  /// 游戏目录
  String? get gameDir => ref.watch(appConfigStoreProvider).gameDir;

  /// flyout
  final FlyoutController flyoutTool = FlyoutController();

  final FlyoutController flyoutUser = FlyoutController();

  /// webview controller
  late MiyousheController controller = MiyousheController();

  /// 文件工具
  final SPFileTool fileTool = SPFileTool();

  /// 测试的时候置为false
  @override
  bool get wantKeepAlive => false;

  /// dispose
  /// dispose
  @override
  void dispose() {
    flyoutTool.dispose();
    flyoutUser.dispose();
    controller.dispose();
    super.dispose();
  }

  /// 启动游戏
  Future<void> tryLaunchGame(UserNapModel account, UserBBSModel user) async {
    if (gameDir == null || gameDir!.isEmpty) {
      if (mounted) await SpInfobar.warn(context, '请先设置游戏路径');
      return;
    }
    var gamePath = path.join(gameDir!, 'ZenlessZoneZero.exe');
    var checkFile = await fileTool.isFileExist(gamePath);
    if (!checkFile) {
      if (mounted) await SpInfobar.warn(context, '未检测到 ZenlessZoneZero.exe');
      return;
    }
    var apiNap = SprNapApiPassport();
    var tickResp = await apiNap.getLoginAuthTicket(account, user.cookie!);
    if (tickResp.retcode != 0) {
      if (mounted) await SpInfobar.bbs(context, tickResp);
      return;
    }
    var ticketData = tickResp.data as NapAuthTicketModelData;
    await Process.run(
      gamePath,
      ['login_auth_ticket=${ticketData.ticket}'],
      runInShell: true,
    );
  }

  /// 重置窗口大小
  Future<void> resetWindowSize() async {
    var size = await windowManager.getSize();
    var target = const Size(1280, 720);
    if (size == target) {
      if (mounted) await SpInfobar.warn(context, '无需重置大小！');
      return;
    }
    await windowManager.setSize(target);
    if (mounted) await SpInfobar.success(context, '已成功重置窗口大小！');
  }

  /// 改变置顶状态
  Future<void> changeAlwaysOnTop() async {
    var isAlwaysOnTop = await windowManager.isAlwaysOnTop();
    await windowManager.setAlwaysOnTop(!isAlwaysOnTop);
    var str = isAlwaysOnTop ? '取消置顶' : '置顶';
    if (mounted) await SpInfobar.success(context, '$str成功');
  }

  /// 封装导航项
  PaneItem getPaneItem(int index, Widget body, IconData icon, String title) {
    return PaneItem(
      icon: curIndex == index ? SPIcon(icon) : Icon(icon),
      title: Text(title),
      body: body,
    );
  }

  /// 获取导航项
  List<PaneItem> getNavItems(BuildContext context) {
    return [
      getPaneItem(0, const NapAnnoPage(), FluentIcons.home, '游戏公告'),
      getPaneItem(
        1,
        const UserGachaPage(),
        FluentIcons.auto_enhance_on,
        '调频记录',
      ),
      if (kDebugMode)
        getPaneItem(2, const AppDevPage(), FluentIcons.test_beaker, '测试页'),
    ];
  }

  /// 展示设置flyout
  Future<void> showOptionsFlyout() async {
    var account = ref.read(userBbsStoreProvider).account;
    var user = ref.read(userBbsStoreProvider).user;
    await flyoutTool.showFlyout(
      barrierDismissible: true,
      dismissOnPointerMoveAway: false,
      dismissWithEsc: true,
      builder: (_) => MenuFlyout(
        items: [
          if (defaultTargetPlatform == TargetPlatform.windows &&
              account != null &&
              user != null)
            MenuFlyoutItem(
              leading: SPIcon(FluentIcons.game),
              text: const Text('启动游戏'),
              onPressed: () async => await tryLaunchGame(account, user),
            ),
          if (account != null && user != null)
            MenuFlyoutItem(
              leading: SPIcon(FluentIcons.giftbox),
              text: const Text('签到'),
              onPressed: () async {
                var check = await MiyousheClient.check();
                if (!check) {
                  if (mounted) {
                    await SpInfobar.error(context, '未检测到webview2Runtime');
                  }
                  return;
                }
                if (mounted) {
                  controller = await MiyousheClient.createSign(context);
                  if (mounted) await controller.show(context);
                }
              },
            ),
          MenuFlyoutItem(
            leading: const Icon(FluentIcons.reset_device),
            text: const Text('重置窗口大小'),
            onPressed: resetWindowSize,
          ),
          MenuFlyoutItem(
            leading: const Icon(FluentIcons.pinned_solid),
            text: const Text('窗口置顶/取消置顶'),
            onPressed: changeAlwaysOnTop,
          ),
        ],
      ),
    );
  }

  /// 构建主题模式项
  PaneItemAction buildThemeModeItem() {
    var config = getThemeConfig(curThemeMode);
    return PaneItemAction(
      icon: Icon(config.icon),
      title: Text(config.label),
      onTap: () async {
        await ref.read(appConfigStoreProvider).setThemeMode(config.next);
      },
    );
  }

  /// 构建用户项
  PaneItemAction buildUserPaneItem() {
    var user = ref.watch(userBbsStoreProvider).user;
    if (user == null) {
      return PaneItemAction(
        icon: const Icon(FluentIcons.reminder_person),
        title: const Text('未登录'),
        onTap: () async {
          if (mounted) await SpInfobar.warn(context, '请先登录');
        },
      );
    }
    return PaneItemAction(
      icon: FlyoutTarget(
        controller: flyoutUser,
        child: user.brief?.avatar != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: user.brief!.avatar,
                  width: 18,
                  height: 18,
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(FluentIcons.user_sync),
      ),
      title: Text(user.brief?.username ?? user.uid),
      onTap: () {
        var accounts = ref.read(userBbsStoreProvider).accounts;
        var curAccount = ref.read(userBbsStoreProvider).account;
        flyoutUser.showFlyout(
          placementMode: FlyoutPlacementMode.bottomLeft,
          builder: (context) => MenuFlyout(
            items: [
              for (var account in accounts)
                MenuFlyoutItem(
                  selected: account.uid == curAccount?.uid,
                  text: Text('${account.nickname}-${account.gameUid} '
                      '${account.regionName}'),
                  trailing: account.uid == curAccount?.uid
                      ? const Icon(FluentIcons.check_mark)
                      : null,
                  onPressed: () async {
                    if (account.uid != curAccount?.uid) {
                      ref.read(userBbsStoreProvider).setAccount(account);
                      if (mounted) {
                        await SpInfobar.success(context, '切换账户成功');
                      }
                      return;
                    }
                    if (mounted) {
                      await SpInfobar.warn(context, '已经是当前账户');
                    }
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  /// 获取底部导航
  List<PaneItem> getFooterItems() {
    return [
      buildUserPaneItem(),
      PaneItemAction(
        icon: FlyoutTarget(
          controller: flyoutTool,
          child: const Icon(FluentIcons.graph_symbol),
        ),
        title: const Text('更多设置'),
        onTap: showOptionsFlyout,
      ),
      buildThemeModeItem(),
      getPaneItem(
        kDebugMode ? 3 : 2,
        const AppConfigPage(),
        FluentIcons.settings,
        '设置',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NavigationView(
      pane: NavigationPane(
        selected: curIndex,
        onChanged: (index) {
          curIndex = index;
          setState(() {});
        },
        displayMode: PaneDisplayMode.compact,
        items: getNavItems(context),
        footerItems: getFooterItems(),
      ),
    );
  }
}