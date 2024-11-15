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
import '../../request/nap/nap_api_passport.dart';
import '../../shared/store/user_bbs.dart';
import '../../shared/tools/file_tool.dart';
import '../../shared/utils/get_app_theme.dart';
import '../pages/app_config.dart';
import '../pages/app_dev.dart';
import '../pages/nap_anno.dart';
import '../pages/user_gacha.dart';
import '../plugins/miyoushe_webview.dart';
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

  UserNapModel? get account => ref.watch(userBbsStoreProvider).account;

  List<UserNapModel> get accounts => ref.watch(userBbsStoreProvider).accounts;

  UserBBSModel? get user => ref.watch(userBbsStoreProvider).user;

  SpAppThemeConfig get themeConfig => getThemeConfig(curThemeMode);

  /// flyout
  final FlyoutController flyoutTool = FlyoutController();

  final FlyoutController flyoutUser = FlyoutController();

  /// webview controller
  late MysControllerWin controller = MysControllerWin();

  /// 文件工具
  final SPFileTool fileTool = SPFileTool();

  /// 窗口管理
  bool isOnTop = false;

  /// 测试的时候置为false
  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      isOnTop = await windowManager.isAlwaysOnTop();
    });
  }

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
    isOnTop = !isOnTop;
    await windowManager.setAlwaysOnTop(isOnTop);
    var str = isOnTop ? '已置顶' : '已取消置顶';
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
              onPressed: () async => await tryLaunchGame(account!, user!),
            ),
          if (account != null && user != null)
            MenuFlyoutItem(
              leading: SPIcon(FluentIcons.giftbox),
              text: const Text('签到'),
              onPressed: () async {
                if (mounted) {
                  controller = await MysClientWin.createSign(context);
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
            leading: isOnTop
                ? const Icon(FluentIcons.pinned_fill)
                : const Icon(FluentIcons.pin),
            text: isOnTop ? const Text('取消置顶') : const Text('置顶'),
            onPressed: changeAlwaysOnTop,
          ),
        ],
      ),
    );
  }

  /// 构建主题模式项
  PaneItemAction buildThemeModeItem() {
    return PaneItemAction(
      icon: Icon(themeConfig.icon),
      title: Text(themeConfig.label),
      onTap: () async {
        await ref.read(appConfigStoreProvider).setThemeMode(themeConfig.next);
      },
    );
  }

  MenuFlyoutItem buildAccountFlyout(UserNapModel act) {
    return MenuFlyoutItem(
      selected: act.uid == account?.uid,
      text: Text('${act.nickname}-${act.gameUid} ${act.regionName}'),
      trailing:
          act.uid == account?.uid ? const Icon(FluentIcons.check_mark) : null,
      onPressed: () async {
        if (act.uid != account?.uid) {
          ref.read(userBbsStoreProvider).setAccount(act);
          if (mounted) await SpInfobar.success(context, '切换账户成功');
          return;
        }
        if (mounted) await SpInfobar.warn(context, '已经是当前账户');
      },
    );
  }

  /// 构建用户项
  PaneItemAction buildUserPaneItem() {
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
        child: user!.brief?.avatar != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: user!.brief!.avatar,
                  width: 18,
                  height: 18,
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(FluentIcons.user_sync),
      ),
      title: Text(user!.brief?.username ?? user!.uid),
      onTap: () async {
        await flyoutUser.showFlyout(
          placementMode: FlyoutPlacementMode.bottomLeft,
          builder: (context) => MenuFlyout(
            items: accounts.map(buildAccountFlyout).toList(),
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
          if (mounted) setState(() {});
        },
        displayMode: PaneDisplayMode.compact,
        items: getNavItems(context),
        footerItems: getFooterItems(),
      ),
    );
  }
}
