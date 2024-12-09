// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:window_manager/window_manager.dart';

// Project imports:
import '../../models/database/user/user_bbs_model.dart';
import '../../models/database/user/user_nap_model.dart';
import '../../shared/store/user_bbs.dart';
import '../../shared/tools/file_tool.dart';
import '../../shared/utils/get_app_theme.dart';
import '../models/ui_model.dart';
import '../pages/nap_anno.dart';
import '../pages/user_gacha.dart';
import '../plugins/miyoushe_webview.dart';
import '../store/app_config.dart';
import '../ui/sp_infobar.dart';
import 'app_config_device.dart';
import 'app_config_info.dart';
import 'app_config_user.dart';

class AppNavWidget extends ConsumerStatefulWidget {
  const AppNavWidget({super.key});

  @override
  ConsumerState<AppNavWidget> createState() => _AppNavWidgetState();
}

class _AppNavWidgetState extends ConsumerState<AppNavWidget> {
  int curIndex = 0;
  int curIndexEnd = 0;
  PackageInfo? packageInfo;
  MysControllerMac controller = MysControllerMac();
  final SPFileTool fileTool = SPFileTool();

  ThemeMode get curThemeMode => ref.watch(appConfigStoreProvider).themeMode;

  AccentColor get curColor => ref.watch(appConfigStoreProvider).accentColor;

  UserNapModel? get account => ref.watch(userBbsStoreProvider).account;

  UserBBSModel? get user => ref.watch(userBbsStoreProvider).user;

  SpAppThemeConfig get themeConfig => getThemeConfig(curThemeMode);
  final pages = [NapAnnoPage(), UserGachaPage()];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      packageInfo = await PackageInfo.fromPlatform();
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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

  /// 签到
  Future<void> createSign() async {
    if (mounted) {
      controller = await MysClientMac.createSign(context, width: 400);
      if (mounted) await controller.show(context);
    }
  }

  List<PlatformMenuItem> buildMenus() {
    return [
      PlatformMenu(label: 'ShufflePlay', menus: [
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.about),
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.quit),
      ]),
      PlatformMenu(label: 'View', menus: [
        PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.toggleFullScreen,
        )
      ]),
      PlatformMenu(label: 'Window', menus: [
        PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.minimizeWindow,
        ),
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.zoomWindow),
      ]),
    ];
  }

  List<SidebarItem> buildSidebarItems() {
    return [
      SidebarItem(
        leading: Icon(Icons.announcement),
        label: Text('公告'),
        selectedColor: curColor.color,
      ),
      SidebarItem(
        leading: Icon(Icons.music_note),
        label: Text('调频记录'),
        selectedColor: curColor.color,
      ),
    ];
  }

  Widget buildSidebarTop(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'ShufflePlay',
          style: MacosTheme.of(context).typography.headline,
        ),
        if (packageInfo != null)
          Text(
            'Version ${packageInfo!.version}',
            style: MacosTheme.of(context).typography.body,
          ),
      ],
    );
  }

  Widget buildSidebarBottomAction(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MacosIconButton(
          icon: MacosIcon(themeConfig.icon),
          onPressed: () async => await ref
              .read(appConfigStoreProvider)
              .setThemeMode(themeConfig.next),
        ),
        MacosIconButton(
          icon: MacosIcon(Icons.reset_tv),
          onPressed: resetWindowSize,
        ),
        if (account != null && user != null)
          MacosIconButton(
            icon: MacosIcon(Icons.wallet_giftcard),
            onPressed: createSign,
          ),
      ],
    );
  }

  Widget buildSidebarBottom(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 16.0),
        Text(
          '© 2024 BTMuli',
          style: MacosTheme.of(context).typography.body,
        ),
        const SizedBox(height: 16.0),
        buildSidebarBottomAction(context),
      ],
    );
  }

  Widget buildSidebarLeft(BuildContext context, ScrollController controller) {
    return SidebarItems(
      currentIndex: curIndex,
      scrollController: controller,
      itemSize: SidebarItemSize.large,
      onChanged: (i) => setState(() => curIndex = i),
      items: buildSidebarItems(),
    );
  }

  Widget buildSidebarEnd(BuildContext context, ScrollController controller) {
    return SidebarItems(
      currentIndex: curIndexEnd,
      scrollController: controller,
      itemSize: SidebarItemSize.large,
      items: [],
      onChanged: (v) => {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformMenuBar(
      menus: defaultTargetPlatform == TargetPlatform.macOS ? buildMenus() : [],
      child: MacosWindow(
        sidebar: Sidebar(
          top: buildSidebarTop(context),
          minWidth: 150.w,
          builder: buildSidebarLeft,
          isResizable: false,
          bottom: buildSidebarBottom(context),
        ),
        disableWallpaperTinting: true,
        endSidebar: Sidebar(
          top: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('设置', style: MacosTheme.of(context).typography.largeTitle),
                MacosIconButton(
                  icon: const MacosIcon(Icons.explore),
                  onPressed: () async {
                    await launchUrlString(
                        'https://github.com/BTMuli/ShufflePlay');
                  },
                )
              ]),
              AppConfigDeviceWidget(),
              AppConfigInfoWidget(),
              AppConfigUserWidget(),
            ],
          ),
          minWidth: 150.w,
          builder: buildSidebarEnd,
          isResizable: false,
          shownByDefault: false,
          topOffset: 10.0,
          bottom: buildSidebarBottom(context),
        ),
        child: pages[curIndex],
      ),
    );
  }
}
